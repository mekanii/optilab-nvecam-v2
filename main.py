#!/usr/bin/env python3
import base64
import signal
import time

import cv2
import numpy as np
from fastapi import Response

from nicegui import Client, app, core, run, ui

black_1px = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAA1JREFUGFdjYGBg+A8AAQQBAHAgZQsAAAAASUVORK5CYII='
placeholder = Response(content=base64.b64decode(black_1px.encode('ascii')), media_type='image/png')



ui.add_head_html('<script type="text/javascript" src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>')

def convert(frame: np.ndarray, quality: int = 85) -> bytes:
  """Convert a frame to JPEG format with compression.

    Args:
      frame (np.ndarray): The frame to convert.
      quality (int): The quality of the JPEG image (1-100).

    Returns:
      bytes: The JPEG image as bytes.
    """
  # encode_param = [int(cv2.IMWRITE_JPEG_QUALITY), quality]
  _, imencode_image = cv2.imencode('.jpg', frame)
  # _, imencode_image = cv2.imencode('.jpg', frame)
  return imencode_image.tobytes()

def setup() -> None:

  @app.get('/video/frame')
  # Create a web route which always provides the latest image from OpenCV.
  async def grab_video_frame() -> Response:
    if not video_capture.isOpened():
        return placeholder
    # The `video_capture.read` call is a blocking function.
    # Run it in a separate thread (default executor) to avoid blocking the event loop.
    _, frame = await run.io_bound(video_capture.read)
    if frame is None:
        return placeholder
    # `convert` is a CPU-intensive function, run it in a separate process to avoid blocking the event loop and GIL.
    jpeg = await run.cpu_bound(convert, frame)
    return Response(content=jpeg, media_type='image/jpeg')
  
  async def snap():
    await ui.run_javascript('''
      html2canvas(document.body).then((canvas) => {
        const base64image = canvas.toDataURL();
        const link = document.createElement('a');
        link.download = 'snapshot.jpg';
        link.href = base64image;
        link.click();
    ''', respond=True)
    # ui.image('data:image/png;base64,' + base64.b64encode(response).decode()).classes('border-2')

  with ui.row().classes('full-width').classes('justify-center'):
    input_rm = ui.input('Nomor RM').classes('col-xs-12 col-sm-12 col-md-4')

  with ui.row().classes('full-width').classes('justify-center'):
    with ui.input('Tanggal Lahir').classes('col-xs-12 col-sm-12 col-md-4').props('readonly') as input_date:
          with ui.menu().props('no-parent-event') as menu:
            with ui.date().bind_value(input_date).on_value_change(menu.close):
              with ui.row().classes('justify-end'):
                ui.button('Close', on_click=menu.close).props('flat')
          with input_date.add_slot('append'):
            ui.icon('highlight_off').on('click', input_date.set_value(None)).classes('cursor-pointer q-pr-sm')
            ui.icon('edit_calendar').on('click', menu.open).classes('cursor-pointer')

  with ui.row().classes('full-width').classes('justify-center'):
    with ui.column().classes('col-xs-12 col-sm-12 col-md-4 col-md-offset-3'):
      video_capture = cv2.VideoCapture(0)
      # For non-flickering image updates and automatic bandwidth adaptation an interactive image is much better than `ui.image()`.
      video_image = ui.interactive_image().classes('w-100').style('height: auto; aspect-ratio: 1 / 1; object-fit: cover;')
      # A timer constantly updates the source of the image.
      # Because data from same paths is cached by the browser,
      # force an update by adding the current timestamp to the source.
      ui.timer(interval=0.01, callback=lambda: video_image.set_source(f'/video/frame?{time.time()}'))
  with ui.row().classes('full-width').classes('justify-center'):
    ui.button('Download', on_click=lambda: snap).classes('col-xs-12 col-sm-12 col-md-4')

  async def disconnect() -> None:
    """Disconnect all clients from current running server."""
    for client_id in Client.instances:
      await core.sio.disconnect(client_id)

  def handle_sigint(signum, frame) -> None:
    # `disconnect` is async, so it must be called from the event loop; we use `ui.timer` to do so.
    ui.timer(0.1, disconnect, once=True)
    # Delay the default handler to allow the disconnect to complete.
    ui.timer(1, lambda: signal.default_int_handler(signum, frame), once=True)

  async def cleanup() -> None:
    # This prevents ugly stack traces when auto-reloading on code change,
    # because otherwise disconnected clients try to reconnect to the newly started server.
    await disconnect()
    # Release the webcam hardware so it can be used by other applications again.
    video_capture.release()

  app.on_shutdown(cleanup)
  # Need to disconnect clients when the app is stopped with Ctrl+C,
  # because otherwise they will keep requesting images which lead to unfinished subprocesses blocking the shutdown.
  signal.signal(signal.SIGINT, handle_sigint)


# All the setup is only done when the server starts. This avoids the webcam being accessed by the auto-reload main process
app.on_startup(setup)

ui.run()