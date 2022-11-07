# highgui

const                       #These 3 flags are used by cvSet/GetWindowProperty
  WND_PROP_FULLSCREEN* = 0  #to change/get window's fullscreen property
  WND_PROP_AUTOSIZE* = 1    #to change/get window's autosize property
  WND_PROP_ASPECTRATIO* = 2 #to change/get window's aspectratio property
  WND_PROP_OPENGL* = 3      #to change/get window's opengl support
                            #These 2 flags are used by cvNamedWindow and cvSet/GetWindowProperty
  WINDOW_NORMAL* = 0x00000000 #the user can resize the window (no constraint)  / also use to switch a fullscreen window to a normal size
  WINDOW_AUTOSIZE* = 0x00000001 #the user cannot resize the window, the size is constrainted by the image displayed
  WINDOW_OPENGL* = 0x00001000 #window with opengl support
                              #Those flags are only for Qt
  GUI_EXPANDED* = 0x00000000 #status bar and tool bar
  GUI_NORMAL* = 0x00000010  #old fashious way
                            #These 3 flags are used by cvNamedWindow and cvSet/GetWindowProperty
  WINDOW_FULLSCREEN* = 1    #change the window to fullscreen
  WINDOW_FREERATIO* = 0x00000100 #the image expends as much as it can (no ratio constraint)
  WINDOW_KEEPRATIO* = 0x00000000 #the ration image is respected.

const
  CAP_ANY* = 0           # autodetect
  CAP_MIL* = 100         # MIL proprietary drivers
  CAP_VFW* = 200         # platform native
  CAP_V4L* = 200
  CAP_V4L2* = 200
  CAP_FIREWARE* = 300    # IEEE 1394 drivers
  CAP_FIREWIRE* = 300
  CAP_IEEE1394* = 300
  CAP_DC1394* = 300
  CAP_CMU1394* = 300
  CAP_STEREO* = 400      # TYZX proprietary drivers
  CAP_TYZX* = 400
  TYZX_LEFT* = 400
  TYZX_RIGHT* = 401
  TYZX_COLOR* = 402
  TYZX_Z* = 403
  CAP_QT* = 500          # QuickTime
  CAP_UNICAP* = 600      # Unicap drivers
  CAP_DSHOW* = 700       # DirectShow (via videoInput)
  CAP_PVAPI* = 800       # PvAPI, Prosilica GigE SDK
  CAP_OPENNI* = 900      # OpenNI (for Kinect)
  CAP_OPENNI_ASUS* = 910 # OpenNI (for Asus Xtion)
  CAP_ANDROID* = 1000    # Android
  CAP_XIAPI* = 1100      # XIMEA Camera API
  CAP_AVFOUNDATION* = 1200 # AVFoundation framework for iOS (OS X Lion will have the same API)
  CAP_GIGANETIX* = 1300  # Smartek Giganetix GigEVisionSDK

const # modes of the controlling registers (can be: auto, manual, auto single push, absolute Latter allowed with any other mode)
      # every feature can have only one mode turned on at a time
  CAP_PROP_DC1394_OFF*         = -4  ## turn the feature off (not controlled manually nor automatically)
  CAP_PROP_DC1394_MODE_MANUAL* = -3  ## set automatically when a value of the feature is set by the user
  CAP_PROP_DC1394_MODE_AUTO* = -2
  CAP_PROP_DC1394_MODE_ONE_PUSH_AUTO* = -1
  CAP_PROP_POS_MSEC* = 0
  CAP_PROP_POS_FRAMES* = 1
  CAP_PROP_POS_AVI_RATIO* = 2
  CAP_PROP_FRAME_WIDTH* = 3
  CAP_PROP_FRAME_HEIGHT* = 4
  CAP_PROP_FPS* = 5
  CAP_PROP_FOURCC* = 6
  CAP_PROP_FRAME_COUNT* = 7
  CAP_PROP_FORMAT* = 8
  CAP_PROP_MODE* = 9
  CAP_PROP_BRIGHTNESS* = 10
  CAP_PROP_CONTRAST* = 11
  CAP_PROP_SATURATION* = 12
  CAP_PROP_HUE* = 13
  CAP_PROP_GAIN* = 14
  CAP_PROP_EXPOSURE* = 15
  CAP_PROP_CONVERT_RGB* = 16
  CAP_PROP_WHITE_BALANCE_BLUE_U* = 17
  CAP_PROP_RECTIFICATION* = 18
  CAP_PROP_MONOCROME* = 19
  CAP_PROP_SHARPNESS* = 20
  CAP_PROP_AUTO_EXPOSURE* = 21 # exposure control done by camera,
                               # user can adjust refernce level
                               # using this feature
  CAP_PROP_GAMMA* = 22
  CAP_PROP_TEMPERATURE* = 23
  CAP_PROP_TRIGGER* = 24
  CAP_PROP_TRIGGER_DELAY* = 25
  CAP_PROP_WHITE_BALANCE_RED_V* = 26
  CAP_PROP_ZOOM* = 27
  CAP_PROP_FOCUS* = 28
  CAP_PROP_GUID* = 29
  CAP_PROP_ISO_SPEED* = 30
  CAP_PROP_MAX_DC1394* = 31
  CAP_PROP_BACKLIGHT* = 32
  CAP_PROP_PAN* = 33
  CAP_PROP_TILT* = 34
  CAP_PROP_ROLL* = 35
  CAP_PROP_IRIS* = 36
  CAP_PROP_SETTINGS* = 37
  CAP_PROP_AUTOGRAB* = 1024 # property for highgui class CvCapture_Android only
  CAP_PROP_SUPPORTED_PREVIEW_SIZES_STRING* = 1025 # readonly, tricky property, returns cpnst char* indeed
  CAP_PROP_PREVIEW_FORMAT* = 1026 # readonly, tricky property, returns cpnst char* indeed
                                  # OpenNI map generators
                                  #CV_CAP_OPENNI_DEPTH_GENERATOR = 1 << 31,
                                  #CV_CAP_OPENNI_IMAGE_GENERATOR = 1 << 30,
                                  #CV_CAP_OPENNI_GENERATORS_MASK = CV_CAP_OPENNI_DEPTH_GENERATOR + CV_CAP_OPENNI_IMAGE_GENERATOR,
                                  # Properties of cameras available through OpenNI interfaces
  CAP_PROP_OPENNI_OUTPUT_MODE* = 100
  CAP_PROP_OPENNI_FRAME_MAX_DEPTH* = 101 # in mm
  CAP_PROP_OPENNI_BASELINE* = 102 # in mm
  CAP_PROP_OPENNI_FOCAL_LENGTH* = 103 # in pixels
  CAP_PROP_OPENNI_REGISTRATION* = 104 # flag
                                      #CV_CAP_PROP_OPENNI_REGISTRATION_ON = CV_CAP_PROP_OPENNI_REGISTRATION, // flag that synchronizes the remapping depth map to image map
                                      # by changing depth generator's view point (if the flag is "on") or
                                      # sets this view point to its normal one (if the flag is "off").
  CAP_PROP_OPENNI_APPROX_FRAME_SYNC* = 105
  CAP_PROP_OPENNI_MAX_BUFFER_SIZE* = 106
  CAP_PROP_OPENNI_CIRCLE_BUFFER* = 107
  CAP_PROP_OPENNI_MAX_TIME_DURATION* = 108
  CAP_PROP_OPENNI_GENERATOR_PRESENT* = 109 #CV_CAP_OPENNI_IMAGE_GENERATOR_PRESENT         = CV_CAP_OPENNI_IMAGE_GENERATOR + CV_CAP_PROP_OPENNI_GENERATOR_PRESENT,
                                           #CV_CAP_OPENNI_IMAGE_GENERATOR_OUTPUT_MODE     = CV_CAP_OPENNI_IMAGE_GENERATOR + CV_CAP_PROP_OPENNI_OUTPUT_MODE,
                                           #CV_CAP_OPENNI_DEPTH_GENERATOR_BASELINE        = CV_CAP_OPENNI_DEPTH_GENERATOR + CV_CAP_PROP_OPENNI_BASELINE,
                                           #CV_CAP_OPENNI_DEPTH_GENERATOR_FOCAL_LENGTH    = CV_CAP_OPENNI_DEPTH_GENERATOR + CV_CAP_PROP_OPENNI_FOCAL_LENGTH,
                                           #CV_CAP_OPENNI_DEPTH_GENERATOR_REGISTRATION    = CV_CAP_OPENNI_DEPTH_GENERATOR + CV_CAP_PROP_OPENNI_REGISTRATION,
                                           #CV_CAP_OPENNI_DEPTH_GENERATOR_REGISTRATION_ON = CV_CAP_OPENNI_DEPTH_GENERATOR_REGISTRATION,
                                           # Properties of cameras available through GStreamer interface
  CAP_GSTREAMER_QUEUE_LENGTH* = 200 # default is 1
  CAP_PROP_PVAPI_MULTICASTIP* = 300 # ip for anable multicast master mode. 0 for disable multicast
                                    # Properties of cameras available through XIMEA SDK interface
  CAP_PROP_XI_DOWNSAMPLING* = 400 # Change image resolution by binning or skipping.
  CAP_PROP_XI_DATA_FORMAT* = 401 # Output data format.
  CAP_PROP_XI_OFFSET_X* = 402 # Horizontal offset from the origin to the area of interest (in pixels).
  CAP_PROP_XI_OFFSET_Y* = 403 # Vertical offset from the origin to the area of interest (in pixels).
  CAP_PROP_XI_TRG_SOURCE* = 404 # Defines source of trigger.
  CAP_PROP_XI_TRG_SOFTWARE* = 405 # Generates an internal trigger. PRM_TRG_SOURCE must be set to TRG_SOFTWARE.
  CAP_PROP_XI_GPI_SELECTOR* = 406 # Selects general purpose input
  CAP_PROP_XI_GPI_MODE* = 407 # Set general purpose input mode
  CAP_PROP_XI_GPI_LEVEL* = 408 # Get general purpose level
  CAP_PROP_XI_GPO_SELECTOR* = 409 # Selects general purpose output
  CAP_PROP_XI_GPO_MODE* = 410 # Set general purpose output mode
  CAP_PROP_XI_LED_SELECTOR* = 411 # Selects camera signalling LED
  CAP_PROP_XI_LED_MODE* = 412 # Define camera signalling LED functionality
  CAP_PROP_XI_MANUAL_WB* = 413 # Calculates White Balance(must be called during acquisition)
  CAP_PROP_XI_AUTO_WB* = 414 # Automatic white balance
  CAP_PROP_XI_AEAG* = 415   # Automatic exposure/gain
  CAP_PROP_XI_EXP_PRIORITY* = 416 # Exposure priority (0.5 - exposure 50%, gain 50%).
  CAP_PROP_XI_AE_MAX_LIMIT* = 417 # Maximum limit of exposure in AEAG procedure
  CAP_PROP_XI_AG_MAX_LIMIT* = 418 # Maximum limit of gain in AEAG procedure
  CAP_PROP_XI_AEAG_LEVEL* = 419 # Average intensity of output signal AEAG should achieve(in %)
  CAP_PROP_XI_TIMEOUT* = 420 # Image capture timeout in milliseconds
                             # Properties for Android cameras
  CAP_PROP_ANDROID_FLASH_MODE* = 8001
  CAP_PROP_ANDROID_FOCUS_MODE* = 8002
  CAP_PROP_ANDROID_WHITE_BALANCE* = 8003
  CAP_PROP_ANDROID_ANTIBANDING* = 8004
  CAP_PROP_ANDROID_FOCAL_LENGTH* = 8005
  CAP_PROP_ANDROID_FOCUS_DISTANCE_NEAR* = 8006
  CAP_PROP_ANDROID_FOCUS_DISTANCE_OPTIMAL* = 8007
  CAP_PROP_ANDROID_FOCUS_DISTANCE_FAR* = 8008 # Properties of cameras available through AVFOUNDATION interface
  CAP_PROP_IOS_DEVICE_FOCUS* = 9001
  CAP_PROP_IOS_DEVICE_EXPOSURE* = 9002
  CAP_PROP_IOS_DEVICE_FLASH* = 9003
  CAP_PROP_IOS_DEVICE_WHITEBALANCE* = 9004
  CAP_PROP_IOS_DEVICE_TORCH* = 9005 # Properties of cameras available through Smartek Giganetix Ethernet Vision interface
                                    # --- Vladimir Litvinenko (litvinenko.vladimir@gmail.com) ---
  CAP_PROP_GIGA_FRAME_OFFSET_X* = 10001
  CAP_PROP_GIGA_FRAME_OFFSET_Y* = 10002
  CAP_PROP_GIGA_FRAME_WIDTH_MAX* = 10003
  CAP_PROP_GIGA_FRAME_HEIGH_MAX* = 10004
  CAP_PROP_GIGA_FRAME_SENS_WIDTH* = 10005
  CAP_PROP_GIGA_FRAME_SENS_HEIGH* = 10006

