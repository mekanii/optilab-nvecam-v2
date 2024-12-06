from flask import Flask, render_template, request
import subprocess

app = Flask(__name__, static_url_path='/static')
process = None  # To store the GStreamer subprocess

@app.route('/')
def index():
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
    pipeline = (
        f"v4l2src device=/dev/video0 ! video/x-raw,width={width},height={height},framerate={fps}/1 ! "
        f"videoconvert ! "
        f"{'x264enc bitrate=' + bitrate if encoding == 'h264' else ''}"
        f"{'jpegenc' if encoding == 'mjpeg' else ''}"
        f"{'vp8enc' if encoding == 'vp8' else ''} ! "
        f"rtpjpegpay name=pay0 ! "
        f"udpsink host=0.0.0.0 port=5000"
    )

    # Start GStreamer process
    process = subprocess.Popen(pipeline, shell=True)

    return "Streaming started!"

@app.route('/stop_stream', methods=['POST'])
def stop_stream():
    global process
    if process:
        process.terminate()
        process = None
    return "Streaming stopped!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)