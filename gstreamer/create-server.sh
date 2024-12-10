sudo tee optilab-nvecam-v2/gstreamer/server.py <<EOF
from flask import Flask, render_template, request, Response
import subprocess
import os
import signal

app = Flask(__name__, static_url_path='/static')
process = None

home_dir = os.path.expanduser("~")
output_directory = os.path.join(home_dir, "optilab-nvecam-v2", "gstreamer", "templates")

PIPELINE_MJPEG = f"gst-launch-1.0 v4l2src device=/dev/video0 ! video/x-raw,width={640},height={480},framerate={30}/1 ! jpegenc ! multipartmux ! appsink"
PIPELINE_H264 = f"gst-launch-1.0 v4l2src device=/dev/video0 ! video/x-raw,width={640},height={480},framerate={30}/1 ! x264enc bitrate=2000 tune=zerolatency ! tcpserversink host=0.0.0.0 port=1905"
PIPELINE = f'gst-launch-1.0 v4l2src device=/dev/video0 ! videoconvert ! clockoverlay ! x264enc tune=zerolatency ! mpegtsmux ! hlssink playlist-root=http://192.168.10.1:8080 location={output_directory}/segment_%05d.ts target-duration=5 max-files=5'

def stream_mjpeg():
  process = subprocess.Popen(PIPELINE_MJPEG, shell=True)
  process.wait()
  while True:
    # Read the output from the GStreamer process
    frame = process.stdout.read(1024)  # Adjust the size as needed
    if not frame:
      break
    
    yield (b'--frame\r\n'
            b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')
    
def stream_h264():
    process = subprocess.Popen(PIPELINE_H264, shell=True)
    process.wait()

def stream_test():
    process = subprocess.Popen(PIPELINE, shell=True)
    process.wait()

  
  
@app.route('/')
def index():
    stream_test()
    return render_template("index.html")

@app.route('/start_stream', methods=['POST'])
def start_stream():
    global process

    # Stop any running GStreamer process
    if process:
        process.terminate()

    # Get parameters from the form
    encoding = request.form.get("encoding")
    bitrate = request.form.get("bitrate")
    resolution = request.form.get("resolution").split('x')
    fps = request.form.get("fps")

    width, height = resolution

    # Construct GStreamer pipeline
    if encoding == 'h264':
        pipeline = (
            f"gst-launch-1.0 v4l2src device=/dev/video0 ! video/x-raw,width={width},height={height},framerate={fps}/1 ! "
            f"videoconvert ! "
            f"x264enc bitrate={bitrate} ! "
            f"rtph264pay ! "
            f"tcpserversink port=1905"
        )
    elif encoding == 'mjpeg':
        pipeline = (
            f"gst-launch-1.0 v4l2src device=/dev/video0 ! video/x-raw,width={width},height={height},framerate={fps}/1 ! "
            f"videoconvert ! "
            f"jpegenc ! "
            # f"rtpjpegpay ! "
            # f"udpsink host=0.0.0.0 port=5000"
            # f"multifilesink location=/tmp/frame%05d.jpg"
            f"multipartmux boundary=spionisto ! "
            f"tcpserversink port=1905"
        )
    elif encoding == 'vp8':
        pipeline = (
            f"gst-launch-1.0 v4l2src device=/dev/video0 ! video/x-raw,width={width},height={height},framerate={fps}/1 ! "
            f"videoconvert ! "
            f"vp8enc ! "
            f"rtpvp8pay ! "
            f"tcpserversink port=1905"
        )

    # Start GStreamer process
    process = subprocess.Popen(pipeline, shell=True)

    return Response("Streaming started!")

@app.route('/stop_stream', methods=['POST'])
def stop_stream():
    global process
    if process:
        # process.terminate()
        os.kill(process.pid, signal.SIGTERM)
        process = None
    return "Streaming stopped!"

@app.route('/video_feed')
def video_feed():
    stream_h264()
    # return Response(mjpeg_stream(), mimetype='multipart/x-mixed-replace; boundary=frame')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
EOF