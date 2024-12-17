sudo tee /usr/local/etc/mediamtx.yml << 'EOF'
logLevel: info
logDestinations: [stdout]
logFile: mediamtx.log

readTimeout: 10s
writeTimeout: 10s
writeQueueSize: 2048
udpMaxPayloadSize: 1472

runOnConnect:
runOnConnectRestart: no
runOnDisconnect:

authMethod: internal

authInternalUsers:
- user: any
  pass:
  ips: []
  permissions:
  - action: publish
    path:
  - action: read
    path:
  - action: playback
    path:

- user: any
  pass:
  ips: ['127.0.0.1', '::1']
  permissions:
  - action: api
  - action: metrics
  - action: pprof

authHTTPAddress:
authHTTPExclude:
- action: api
- action: metrics
- action: pprof

authJWTJWKS:
authJWTClaimKey: mediamtx_permissions

api: no
apiAddress: :9997
apiEncryption: no
apiServerKey: server.key
apiServerCert: server.crt
apiAllowOrigin: '*'
apiTrustedProxies: []

metrics: no
metricsAddress: :9998
metricsEncryption: no
metricsServerKey: server.key
metricsServerCert: server.crt
metricsAllowOrigin: '*'
metricsTrustedProxies: []

pprof: no
pprofAddress: :9999
pprofEncryption: no
pprofServerKey: server.key
pprofServerCert: server.crt
pprofAllowOrigin: '*'
pprofTrustedProxies: []

playback: no
playbackAddress: :9996
playbackEncryption: no
playbackServerKey: server.key
playbackServerCert: server.crt
playbackAllowOrigin: '*'
playbackTrustedProxies: []

rtsp: yes
protocols: [udp, multicast, tcp]
encryption: "no"
rtspAddress: :8554
rtspsAddress: :8322
rtpAddress: :8000
rtcpAddress: :8001
multicastIPRange: 224.1.0.0/16
multicastRTPPort: 8002
multicastRTCPPort: 8003
serverKey: server.key
serverCert: server.crt
rtspAuthMethods: [basic]

rtmp: yes
rtmpAddress: :1935
rtmpEncryption: "no"
rtmpsAddress: :1936
rtmpServerKey: server.key
rtmpServerCert: server.crt

hls: yes
hlsAddress: :8888
hlsEncryption: no
hlsServerKey: server.key
hlsServerCert: server.crt
hlsAllowOrigin: '*'
hlsTrustedProxies: []
hlsAlwaysRemux: no
hlsVariant: lowLatency
hlsSegmentCount: 7
hlsSegmentDuration: 1s
hlsPartDuration: 200ms
hlsSegmentMaxSize: 50M
hlsDirectory: ''
hlsMuxerCloseAfter: 60s

webrtc: yes
webrtcAddress: :8889
webrtcEncryption: no
webrtcServerKey: server.key
webrtcServerCert: server.crt
webrtcAllowOrigin: '*'
webrtcTrustedProxies: []
webrtcLocalUDPAddress: :8189
webrtcLocalTCPAddress: ''
webrtcIPsFromInterfaces: yes
webrtcIPsFromInterfacesList: []
webrtcAdditionalHosts: []
webrtcICEServers2: []
webrtcHandshakeTimeout: 10s
webrtcTrackGatherTimeout: 2s

srt: yes
srtAddress: :8890

pathDefaults:
  source: publisher
  sourceFingerprint:
  sourceOnDemand: no
  sourceOnDemandStartTimeout: 10s
  sourceOnDemandCloseAfter: 10s
  maxReaders: 0
  srtReadPassphrase:
  fallback:

  record: no
  recordPath: ./recordings/%path/%Y-%m-%d_%H-%M-%S-%f
  recordFormat: fmp4
  recordPartDuration: 1s
  recordSegmentDuration: 1h
  recordDeleteAfter: 24h

  overridePublisher: yes
  srtPublishPassphrase:

  rtspTransport: automatic
  rtspAnyPort: no
  rtspRangeType:
  rtspRangeStart:

  sourceRedirect:

  rpiCameraCamID: 0
  rpiCameraWidth: 1920
  rpiCameraHeight: 1080
  rpiCameraHFlip: false
  rpiCameraVFlip: false
  rpiCameraBrightness: 0
  rpiCameraContrast: 1
  rpiCameraSaturation: 1
  rpiCameraSharpness: 1
  rpiCameraExposure: normal
  rpiCameraAWB: auto
  rpiCameraAWBGains: [0, 0]
  rpiCameraDenoise: "off"
  rpiCameraShutter: 0
  rpiCameraMetering: centre
  rpiCameraGain: 0
  rpiCameraEV: 0
  rpiCameraROI:
  rpiCameraHDR: false
  rpiCameraTuningFile:
  rpiCameraMode:
  rpiCameraFPS: 30
  rpiCameraAfMode: continuous
  rpiCameraAfRange: normal
  rpiCameraAfSpeed: normal
  rpiCameraLensPosition: 0.0
  rpiCameraAfWindow:
  rpiCameraFlickerPeriod: 0
  rpiCameraTextOverlayEnable: false
  rpiCameraTextOverlay: '%Y-%m-%d %H:%M:%S - MediaMTX'
  rpiCameraCodec: auto
  rpiCameraIDRPeriod: 60
  rpiCameraBitrate: 5000000
  rpiCameraProfile: main
  rpiCameraLevel: '4.1'

  runOnInit:
  runOnInitRestart: no

  runOnDemand:
  runOnDemandRestart: no
  runOnDemandStartTimeout: 10s
  runOnDemandCloseAfter: 10s
  runOnUnDemand:

  runOnReady:
  runOnReadyRestart: no
  runOnNotReady:

  runOnRead:
  runOnReadRestart: no
  runOnUnread:

  runOnRecordSegmentCreate:

  runOnRecordSegmentComplete:

paths:
  stream600:
    runOnDemand: ffmpeg -f v4l2 -input_format yuyv422 -video_size 800x600 -framerate 20 -i /dev/video0 -pix_fmt yuv420p -s 800x600 -r 20 -b:v 1600000 -c:v libx264 -bf 0 -preset ultrafast -tune zerolatency -f rtsp rtsp://localhost:$RTSP_PORT/$MTX_PATH
    
  stream480:
    runOnDemand: ffmpeg -f v4l2 -input_format yuyv422 -video_size 640x480 -framerate 30 -i /dev/video0 -pix_fmt yuv420p -s 640x480 -r 30 -b:v 1600000 -c:v libx264 -bf 0 -preset ultrafast -tune zerolatency -f rtsp rtsp://localhost:$RTSP_PORT/$MTX_PATH

  all_others:
EOF