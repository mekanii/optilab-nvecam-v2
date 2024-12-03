# Import necessary modules
from flask import Flask, render_template, Response
import cv2
import logging
import time

# Create a Flask app instance
app = Flask(__name__, static_url_path='/static')

# Function to generate video frames from the camera
def generate_frames():
    camera = cv2.VideoCapture(0)  # Use 0 for default camera
    while True:
        success, frame = camera.read()
        if not success:
            break
        else:
            # Encode frame as JPEG
            ret, buffer = cv2.imencode('.jpg', frame)
            frame = buffer.tobytes()
            
            # Yield the frame in the correct format for streaming
            yield (b'--frame\r\n'
                   b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')

# Route to render the HTML template
@app.route('/')
def index():
    return render_template('index.html')

# Route to stream video frames
@app.route('/video_feed')
def video_feed():
    return Response(generate_frames(),
                    mimetype='multipart/x-mixed-replace; boundary=frame')

# Run the Flask app
if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=8080)