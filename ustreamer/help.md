```bash
uStreamer - Lightweight and fast MJPEG-HTTP streamer
═════════════��═════════════════════════════════════
Version: 6.18; license: GPLv3
Copyright (C) 2018-2024 Maxim Devaev <mdevaev@gmail.com>

Capturing options:
══════════════════
    -d|--device </dev/path>  ───────────── Path to V4L2 device. Default: /dev/video0.

    -i|--input <N>  ────────────────────── Input channel. Default: 0.

    -r|--resolution <WxH>  ─────────────── Initial image resolution. Default: 640x480.

    -m|--format <fmt>  ─────────────────── Image format.
                                           Available: YUYV, YVYU, UYVY, RGB565, RGB24, BGR24, MJPEG, JPEG; default: YUYV.

       --format-swap-rgb  ──────────────── Enable R-G-B order swapping: RGB to BGR and vice versa.
                                           Default: disabled.

    -a|--tv-standard <std>  ────────────── Force TV standard.
                                           Available: PAL, NTSC, SECAM; default: disabled.

    -I|--io-method <method>  ───────────── Set V4L2 IO method (see kernel documentation).
                                           Changing of this parameter may increase the performance. Or not.
                                           Available: MMAP, USERPTR; default: MMAP.

    -f|--desired-fps <N>  ──────────────── Desired FPS. Default: maximum possible.

    -z|--min-frame-size <N>  ───────────── Drop frames smaller then this limit. Useful if the device
                                           produces small-sized garbage frames. Default: 128 bytes.

    -T|--allow-truncated-frames  ───────── Allows to handle truncated frames. Useful if the device
                                           produces incorrect but still acceptable frames. Default: disabled.

    -n|--persistent  ───────────────────── Don't re-initialize device on timeout. Default: disabled.

    -t|--dv-timings  ───────────────────── Enable DV-timings querying and events processing
                                           to automatic resolution change. Default: disabled.

    -b|--buffers <N>  ──────────────────── The number of buffers to receive data from the device.
                                           Each buffer may processed using an independent thread.
                                           Default: 5 (the number of CPU cores (but not more than 4) + 1).

    -w|--workers <N>  ──────────────────── The number of worker threads but not more than buffers.
                                           Default: 4 (the number of CPU cores (but not more than 4)).

    -q|--quality <N>  ──────────────────── Set quality of JPEG encoding from 1 to 100 (best). Default: 80.
                                           Note: If HW encoding is used (JPEG source format selected),
                                           this parameter attempts to configure the camera
                                           or capture device hardware's internal encoder.
                                           It does not re-encode MJPEG to MJPEG to change the quality level
                                           for sources that already output MJPEG.

    -c|--encoder <type>  ───────────────── Use specified encoder. It may affect the number of workers.
                                           Available:
                                             * CPU  ──────── Software MJPEG encoding (default);
                                             * HW  ───────── Use pre-encoded MJPEG frames directly from camera hardware;
                                             * M2M-VIDEO  ── GPU-accelerated MJPEG encoding using V4L2 M2M video interface;
                                             * M2M-IMAGE  ── GPU-accelerated JPEG encoding using V4L2 M2M image interface.

    -g|--glitched-resolutions <WxH,...>  ─ It doesn't do anything. Still here for compatibility.

    -k|--blank <path>  ─────────────────── It doesn't do anything. Still here for compatibility.

    -K|--last-as-blank <sec>  ──────────── It doesn't do anything. Still here for compatibility.

    -l|--slowdown  ─────────────────────── Slowdown capturing to 1 FPS or less when no stream or sink clients
                                           are connected. Useful to reduce CPU consumption. Default: disabled.

    --device-timeout <sec>  ────────────── Timeout for device querying. Default: 1.

    --device-error-delay <sec>  ────────── Delay before trying to connect to the device again
                                           after an error (timeout for example). Default: 1.

    --m2m-device </dev/path>  ──────────── Path to V4L2 M2M encoder device. Default: auto select.

Image control options:
══════════════════════
    --image-default  ────────────────────── Reset all image settings below to default. Default: no change.

    --brightness <N|auto|default>  ──────── Set brightness. Default: no change.

    --contrast <N|default>  ─────────────── Set contrast. Default: no change.

    --saturation <N|default>  ───────────── Set saturation. Default: no change.

    --hue <N|auto|default>  ─────────────── Set hue. Default: no change.

    --gamma <N|default> ─────────────────── Set gamma. Default: no change.

    --sharpness <N|default>  ────────────── Set sharpness. Default: no change.

    --backlight-compensation <N|default>  ─ Set backlight compensation. Default: no change.

    --white-balance <N|auto|default>  ───── Set white balance. Default: no change.

    --gain <N|auto|default>  ────────────── Set gain. Default: no change.

    --color-effect <N|default>  ─────────── Set color effect. Default: no change.

    --rotate <N|default>  ───────────────── Set rotation. Default: no change.

    --flip-vertical <1|0|default>  ──────── Set vertical flip. Default: no change.

    --flip-horizontal <1|0|default>  ────── Set horizontal flip. Default: no change.

    Hint: use v4l2-ctl --list-ctrls-menus to query available controls of the device.

HTTP server options:
════════════════════
    -s|--host <address>  ──────── Listen on Hostname or IP. Default: 127.0.0.1.

    -p|--port <N>  ────────────── Bind to this TCP port. Default: 8080.

    -U|--unix <path>  ─────────── Bind to UNIX domain socket. Default: disabled.

    -D|--unix-rm  ─────────────── Try to remove old UNIX socket file before binding. Default: disabled.

    -M|--unix-mode <mode>  ────── Set UNIX socket file permissions (like 777). Default: disabled.

    --user <name>  ────────────── HTTP basic auth user. Default: disabled.

    --passwd <str>  ───────────── HTTP basic auth passwd. Default: empty.

    --static <path> ───────��───── Path to dir with static files instead of embedded root index page.
                                  Symlinks are not supported for security reasons. Default: disabled.

    -e|--drop-same-frames <N>  ── Don't send identical frames to clients, but no more than specified number.
                                  It can significantly reduce the outgoing traffic, but will increase
                                  the CPU loading. Don't use this option with analog signal sources
                                  or webcams, it's useless. Default: disabled.

    -R|--fake-resolution <WxH>  ─ Override image resolution for the /state. Default: disabled.

    --tcp-nodelay  ────────────── Set TCP_NODELAY flag to the client /stream socket. Only for TCP socket.
                                  Default: disabled.

    --allow-origin <str>  ─────── Set Access-Control-Allow-Origin header. Default: disabled.

    --instance-id <str>  ──────── A short string identifier to be displayed in the /state handle.
                                  It must satisfy regexp ^[a-zA-Z0-9\./+_-]*$. Default: an empty string.

    --server-timeout <sec>  ───── Timeout for client connections. Default: 10.

JPEG sink options:
══════════════════
    --jpeg-sink <name>  ──────────── Use the shared memory to sink JPEG frames. Default: disabled.
                                     The name should end with a suffix ".jpeg" or ".jpeg".
                                     Default: disabled.

    --jpeg-sink-mode <mode>  ─────── Set JPEG sink permissions (like 777). Default: 660.

    --jpeg-sink-rm  ──────────────── Remove shared memory on stop. Default: disabled.

    --jpeg-sink-client-ttl <sec>  ── Client TTL. Default: 10.

    --jpeg-sink-timeout <sec>  ───── Timeout for lock. Default: 1.

RAW sink options:
══════════════════
    --raw-sink <name>  ──────────── Use the shared memory to sink RAW frames. Default: disabled.
                                     The name should end with a suffix ".raw" or ".raw".
                                     Default: disabled.

    --raw-sink-mode <mode>  ─────── Set RAW sink permissions (like 777). Default: 660.

    --raw-sink-rm  ──────────────── Remove shared memory on stop. Default: disabled.

    --raw-sink-client-ttl <sec>  ── Client TTL. Default: 10.

    --raw-sink-timeout <sec>  ───── Timeout for lock. Default: 1.

H264 sink options:
══════════════════
    --h264-sink <name>  ──────────── Use the shared memory to sink H264 frames. Default: disabled.
                                     The name should end with a suffix ".h264" or ".h264".
                                     Default: disabled.

    --h264-sink-mode <mode>  ─────── Set H264 sink permissions (like 777). Default: 660.

    --h264-sink-rm  ──────────────── Remove shared memory on stop. Default: disabled.

    --h264-sink-client-ttl <sec>  ── Client TTL. Default: 10.

    --h264-sink-timeout <sec>  ───── Timeout for lock. Default: 1.

    --h264-bitrate <kbps>  ───────── H264 bitrate in Kbps. Default: 5000.

    --h264-gop <N>  ──────────────── Interval between keyframes. Default: 30.

    --h264-m2m-device </dev/path>  ─ Path to V4L2 M2M encoder device. Default: auto select.

Process options:
════════════════
    --exit-on-parent-death  ─────── Exit the program if the parent process is dead. Default: disabled.

    --exit-on-no-clients <sec> ──── Exit the program if there have been no stream or sink clients
                                    or any HTTP requests in the last N seconds. Default: 0 (disabled)

    --process-name-prefix <str>  ── Set process name prefix which will be displayed in the process list
                                    like '<str>: ustreamer --blah-blah-blah'. Default: disabled.

    --notify-parent  ────────────── Send SIGUSR2 to the parent process when the stream parameters are changed.
                                    Checking changes is performed for the online flag and image resolution.

Logging options:
════════════════
    --log-level <N>  ──── Verbosity level of messages from 0 (info) to 3 (debug).
                          Enabling debugging messages can slow down the program.
                          Available levels: 0 (info), 1 (performance), 2 (verbose), 3 (debug).
                          Default: 0.

    --perf  ───────────── Enable performance messages (same as --log-level=1). Default: disabled.

    --verbose  ────────── Enable verbose messages and lower (same as --log-level=2). Default: disabled.

    --debug  ──────────── Enable debug messages and lower (same as --log-level=3). Default: disabled.

    --force-log-colors  ─ Force color logging. Default: colored if stderr is a TTY.

    --no-log-colors  ──── Disable color logging. Default: ditto.

Help options:
═════════════
    -h|--help  ─────── Print this text and exit.

    -v|--version  ──── Print version and exit.

    --features  ��───── Print list of supported features.
```