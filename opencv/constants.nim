# imgcodecs

type
  ImreadModes* = enum
    IMREAD_UNCHANGED = -1,  # image as is alpha/cropped Ignore EXIF orientation
    IMREAD_GRAYSCALE = 0,   # always 1ch grayscale (codec internal conversion)
    IMREAD_COLOR = 1,       # always 3ch BGR
    IMREAD_ANYDEPTH = 2,    # 16/32bit when corresponding depth or to 8bit
    IMREAD_ANYCOLOR = 4,    # any possible color format
    IMREAD_LOAD_GDAL = 8,   # the gdal driver for loading the image
    IMREAD_REDUCED_GRAYSCALE_2 = 16,  # always 1ch grayscale size reduced 1/2
    IMREAD_REDUCED_COLOR_2 = 17,      # always 3ch BGR size reduced 1/2
    IMREAD_REDUCED_GRAYSCALE_4 = 32,  # always 1ch grayscale size reduced 1/4
    IMREAD_REDUCED_COLOR_4 = 33,      # always 3ch BGR size reduced 1/4
    IMREAD_REDUCED_GRAYSCALE_8 = 64,  # always 1ch grayscale size reduced 1/8
    IMREAD_REDUCED_COLOR_8 = 65,      # always 3ch BGR size reduced 1/8
    IMREAD_IGNORE_ORIENTATION = 128   #

type
  ImwriteFlags* = enum
    IMWRITE_JPEG_QUALITY = 1,         # Low 0 - 100 High (default 95)
    IMWRITE_JPEG_PROGRESSIVE = 2,     # default False
    IMWRITE_JPEG_OPTIMIZE = 3,        # default False
    IMWRITE_JPEG_RST_INTERVAL = 4,    # restart interval 0 - 65535 (default 0)
    IMWRITE_JPEG_LUMA_QUALITY = 5,    # 0 - 100 (default 0) don't use
    IMWRITE_JPEG_CHROMA_QUALITY = 6,  # 0 - 100 (default 0) don't use
    IMWRITE_PNG_COMPRESSION = 16,     # 0 - 9 (default 1)
    IMWRITE_PNG_STRATEGY = 17,        # (default IMWRITE_PNG_STRATEGY_RLE)
    IMWRITE_PNG_BILEVEL = 18,         # Binary level PNG 0 or 1 (default 0)
    IMWRITE_PXM_BINARY = 32,          # PPM, PGM, or PBM binary (default 1)
    IMWRITE_EXR_TYPE = 48,        # (3 << 4)+0 EXR storage type (default FP32)
    IMWRITE_EXR_COMPRESSION = 49, # (3 << 4)+1 (default ZIP_COMPRESSION=3)
    IMWRITE_WEBP_QUALITY = 64,        # 1 - 100 (default above 100 lossless)
    IMWRITE_PAM_TUPLETYPE = 128,      #
    IMWRITE_TIFF_RESUNIT = 256,       # DPI resolution unit
    IMWRITE_TIFF_XDPI = 257,          # X direction DPI
    IMWRITE_TIFF_YDPI = 258,          # Y direction DPI
    IMWRITE_TIFF_COMPRESSION = 259,   # CV_32F (default LZW)
    IMWRITE_JPEG2000_COMPRESSION_X1000 = 272  # 0 - 1000 (default 1000)

template ImFlags*(flags: varargs[ImreadModes or ImwriteFlags]): int =
  var result = 0
  for f in flags: result += f.int
  result

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

const
  CN_MAX* = 512
  CN_SHIFT* = 3
  DEPTH_MAX* = (1 shl CN_SHIFT)
  CV_8U* = 0
  CV_8S* = 1
  CV_16U* = 2
  CV_16S* = 3
  CV_32S* = 4
  CV_32F* = 5
  CV_64F* = 6
  USRTYPE1* = 7
  MAT_DEPTH_MASK* = (DEPTH_MAX - 1)

template Mat_Depth*(flags: untyped): untyped =
  ((flags) and MAT_DEPTH_MASK)

template maketype*(depth, cn: untyped): untyped =
  (MAT_DEPTH(depth) + (((cn) - 1) shl CN_SHIFT))

const
  CV_8UC1* = maketype(CV_8U, 1)
  CV_8UC2* = maketype(CV_8U, 2)
  CV_8UC3* = maketype(CV_8U, 3)
  CV_8UC4* = maketype(CV_8U, 4)

template Cv_8uc*(n: untyped): untyped =
  MAKETYPE(CV_8U, (n))

const
  CV_8SC1* = maketype(CV_8S, 1)
  CV_8SC2* = maketype(CV_8S, 2)
  CV_8SC3* = maketype(CV_8S, 3)
  CV_8SC4* = maketype(CV_8S, 4)

template Cv_8sc*(n: untyped): untyped =
  MAKETYPE(CV_8S, (n))

const
  CV_16UC1* = maketype(CV_16U, 1)
  CV_16UC2* = maketype(CV_16U, 2)
  CV_16UC3* = maketype(CV_16U, 3)
  CV_16UC4* = maketype(CV_16U, 4)

template Cv_16uc*(n: untyped): untyped =
  MAKETYPE(CV_16U, (n))

const
  CV_16SC1* = maketype(CV_16S, 1)
  CV_16SC2* = maketype(CV_16S, 2)
  CV_16SC3* = maketype(CV_16S, 3)
  CV_16SC4* = maketype(CV_16S, 4)

template Cv_16sc*(n: untyped): untyped =
  MAKETYPE(CV_16S, (n))

const
  CV_32SC1* = maketype(CV_32S, 1)
  CV_32SC2* = maketype(CV_32S, 2)
  CV_32SC3* = maketype(CV_32S, 3)
  CV_32SC4* = maketype(CV_32S, 4)

template Cv_32sc*(n: untyped): untyped =
  MAKETYPE(CV_32S, (n))

const
  CV_32FC1* = maketype(CV_32F, 1)
  CV_32FC2* = maketype(CV_32F, 2)
  CV_32FC3* = maketype(CV_32F, 3)
  CV_32FC4* = maketype(CV_32F, 4)

template Cv_32fc*(n: untyped): untyped =
  MAKETYPE(CV_32F, (n))

const
  CV_64FC1* = maketype(CV_64F, 1)
  CV_64FC2* = maketype(CV_64F, 2)
  CV_64FC3* = maketype(CV_64F, 3)
  CV_64FC4* = maketype(CV_64F, 4)

template Cv_64fc*(n: untyped): untyped =
  MAKETYPE(CV_64F, (n))

# imgproc

# Constants for color conversion

const
  BGR2BGRA* = 0
  RGB2RGBA* = BGR2BGRA
  BGRA2BGR* = 1
  RGBA2RGB* = BGRA2BGR
  BGR2RGBA* = 2
  RGB2BGRA* = BGR2RGBA
  RGBA2BGR* = 3
  BGRA2RGB* = RGBA2BGR
  BGR2RGB* = 4
  RGB2BGR* = BGR2RGB
  BGRA2RGBA* = 5
  RGBA2BGRA* = BGRA2RGBA
  BGR2GRAY* = 6
  RGB2GRAY* = 7
  GRAY2BGR* = 8
  GRAY2RGB* = GRAY2BGR
  GRAY2BGRA* = 9
  GRAY2RGBA* = GRAY2BGRA
  BGRA2GRAY* = 10
  RGBA2GRAY* = 11
  BGR2BGR565* = 12
  RGB2BGR565* = 13
  BGR5652BGR* = 14
  BGR5652RGB* = 15
  BGRA2BGR565* = 16
  RGBA2BGR565* = 17
  BGR5652BGRA* = 18
  BGR5652RGBA* = 19
  GRAY2BGR565* = 20
  BGR5652GRAY* = 21
  BGR2BGR555* = 22
  RGB2BGR555* = 23
  BGR5552BGR* = 24
  BGR5552RGB* = 25
  BGRA2BGR555* = 26
  RGBA2BGR555* = 27
  BGR5552BGRA* = 28
  BGR5552RGBA* = 29
  GRAY2BGR555* = 30
  BGR5552GRAY* = 31
  BGR2XYZ* = 32
  RGB2XYZ* = 33
  XYZ2BGR* = 34
  XYZ2RGB* = 35
  BGR2YCrCb* = 36
  RGB2YCrCb* = 37
  YCrCb2BGR* = 38
  YCrCb2RGB* = 39
  BGR2HSV* = 40
  RGB2HSV* = 41
  BGR2Lab* = 44
  RGB2Lab* = 45
  BayerBG2BGR* = 46
  BayerGB2BGR* = 47
  BayerRG2BGR* = 48
  BayerGR2BGR* = 49
  BayerBG2RGB* = BayerRG2BGR
  BayerGB2RGB* = BayerGR2BGR
  BayerRG2RGB* = BayerBG2BGR
  BayerGR2RGB* = BayerGB2BGR
  BGR2Luv* = 50
  RGB2Luv* = 51
  BGR2HLS* = 52
  RGB2HLS* = 53
  HSV2BGR* = 54
  HSV2RGB* = 55
  Lab2BGR* = 56
  Lab2RGB* = 57
  Luv2BGR* = 58
  Luv2RGB* = 59
  HLS2BGR* = 60
  HLS2RGB* = 61
  BayerBG2BGR_VNG* = 62
  BayerGB2BGR_VNG* = 63
  BayerRG2BGR_VNG* = 64
  BayerGR2BGR_VNG* = 65
  BayerBG2RGB_VNG* = BayerRG2BGR_VNG
  BayerGB2RGB_VNG* = BayerGR2BGR_VNG
  BayerRG2RGB_VNG* = BayerBG2BGR_VNG
  BayerGR2RGB_VNG* = BayerGB2BGR_VNG
  BGR2HSV_FULL* = 66
  RGB2HSV_FULL* = 67
  BGR2HLS_FULL* = 68
  RGB2HLS_FULL* = 69
  HSV2BGR_FULL* = 70
  HSV2RGB_FULL* = 71
  HLS2BGR_FULL* = 72
  HLS2RGB_FULL* = 73
  LBGR2Lab* = 74
  LRGB2Lab* = 75
  LBGR2Luv* = 76
  LRGB2Luv* = 77
  Lab2LBGR* = 78
  Lab2LRGB* = 79
  Luv2LBGR* = 80
  Luv2LRGB* = 81
  BGR2YUV* = 82
  RGB2YUV* = 83
  YUV2BGR* = 84
  YUV2RGB* = 85
  BayerBG2GRAY* = 86
  BayerGB2GRAY* = 87
  BayerRG2GRAY* = 88
  BayerGR2GRAY* = 89          #YUV 4:2:0 formats family
  YUV2RGB_NV12* = 90
  YUV2BGR_NV12* = 91
  YUV2RGB_NV21* = 92
  YUV2BGR_NV21* = 93
  YUV420sp2RGB* = YUV2RGB_NV21
  YUV420sp2BGR* = YUV2BGR_NV21
  YUV2RGBA_NV12* = 94
  YUV2BGRA_NV12* = 95
  YUV2RGBA_NV21* = 96
  YUV2BGRA_NV21* = 97
  YUV420sp2RGBA* = YUV2RGBA_NV21
  YUV420sp2BGRA* = YUV2BGRA_NV21
  YUV2RGB_YV12* = 98
  YUV2BGR_YV12* = 99
  YUV2RGB_IYUV* = 100
  YUV2BGR_IYUV* = 101
  YUV2RGB_I420* = YUV2RGB_IYUV
  YUV2BGR_I420* = YUV2BGR_IYUV
  YUV420p2RGB* = YUV2RGB_YV12
  YUV420p2BGR* = YUV2BGR_YV12
  YUV2RGBA_YV12* = 102
  YUV2BGRA_YV12* = 103
  YUV2RGBA_IYUV* = 104
  YUV2BGRA_IYUV* = 105
  YUV2RGBA_I420* = YUV2RGBA_IYUV
  YUV2BGRA_I420* = YUV2BGRA_IYUV
  YUV420p2RGBA* = YUV2RGBA_YV12
  YUV420p2BGRA* = YUV2BGRA_YV12
  YUV2GRAY_420* = 106
  YUV2GRAY_NV21* = YUV2GRAY_420
  YUV2GRAY_NV12* = YUV2GRAY_420
  YUV2GRAY_YV12* = YUV2GRAY_420
  YUV2GRAY_IYUV* = YUV2GRAY_420
  YUV2GRAY_I420* = YUV2GRAY_420
  YUV420sp2GRAY* = YUV2GRAY_420
  YUV420p2GRAY* = YUV2GRAY_420 #YUV 4:2:2 formats family
  YUV2RGB_UYVY* = 107
  YUV2BGR_UYVY* = 108         #CV_YUV2RGB_VYUY = 109,
                              #CV_YUV2BGR_VYUY = 110,
  YUV2RGB_Y422* = YUV2RGB_UYVY
  YUV2BGR_Y422* = YUV2BGR_UYVY
  YUV2RGB_UYNV* = YUV2RGB_UYVY
  YUV2BGR_UYNV* = YUV2BGR_UYVY
  YUV2RGBA_UYVY* = 111
  YUV2BGRA_UYVY* = 112        #CV_YUV2RGBA_VYUY = 113,
                              #CV_YUV2BGRA_VYUY = 114,
  YUV2RGBA_Y422* = YUV2RGBA_UYVY
  YUV2BGRA_Y422* = YUV2BGRA_UYVY
  YUV2RGBA_UYNV* = YUV2RGBA_UYVY
  YUV2BGRA_UYNV* = YUV2BGRA_UYVY
  YUV2RGB_YUY2* = 115
  YUV2BGR_YUY2* = 116
  YUV2RGB_YVYU* = 117
  YUV2BGR_YVYU* = 118
  YUV2RGB_YUYV* = YUV2RGB_YUY2
  YUV2BGR_YUYV* = YUV2BGR_YUY2
  YUV2RGB_YUNV* = YUV2RGB_YUY2
  YUV2BGR_YUNV* = YUV2BGR_YUY2
  YUV2RGBA_YUY2* = 119
  YUV2BGRA_YUY2* = 120
  YUV2RGBA_YVYU* = 121
  YUV2BGRA_YVYU* = 122
  YUV2RGBA_YUYV* = YUV2RGBA_YUY2
  YUV2BGRA_YUYV* = YUV2BGRA_YUY2
  YUV2RGBA_YUNV* = YUV2RGBA_YUY2
  YUV2BGRA_YUNV* = YUV2BGRA_YUY2
  YUV2GRAY_UYVY* = 123
  YUV2GRAY_YUY2* = 124        #CV_YUV2GRAY_VYUY = CV_YUV2GRAY_UYVY,
  YUV2GRAY_Y422* = YUV2GRAY_UYVY
  YUV2GRAY_UYNV* = YUV2GRAY_UYVY
  YUV2GRAY_YVYU* = YUV2GRAY_YUY2
  YUV2GRAY_YUYV* = YUV2GRAY_YUY2
  YUV2GRAY_YUNV* = YUV2GRAY_YUY2 # alpha premultiplication
  RGBA2mRGBA* = 125
  mRGBA2RGBA* = 126
  RGB2YUV_I420* = 127
  BGR2YUV_I420* = 128
  RGB2YUV_IYUV* = RGB2YUV_I420
  BGR2YUV_IYUV* = BGR2YUV_I420
  RGBA2YUV_I420* = 129
  BGRA2YUV_I420* = 130
  RGBA2YUV_IYUV* = RGBA2YUV_I420
  BGRA2YUV_IYUV* = BGRA2YUV_I420
  RGB2YUV_YV12* = 131
  BGR2YUV_YV12* = 132
  RGBA2YUV_YV12* = 133
  BGRA2YUV_YV12* = 134
  COLORCVT_MAX* = 135

# Sub-pixel interpolation methods

const
  INTER_NN* = 0
  INTER_LINEAR* = 1
  INTER_CUBIC* = 2
  INTER_AREA* = 3
  INTER_LANCZOS4* = 4

#

const # LineTypes
  FILLED* = -1
  LINE_4* = 4       # 4-connected line
  LINE_8* = 8       # 8-connected line
  LINE_AA* = 16     # antialiased line

const # HersheyFonts
  FONT_HERSHEY_SIMPLEX* = 0           # normal size sans-serif font
  FONT_HERSHEY_PLAIN* = 1             # small size sans-serif font
  FONT_HERSHEY_DUPLEX* = 2            # normal size sans-serif font (more complex than FONT_HERSHEY_SIMPLEX)
  FONT_HERSHEY_COMPLEX* = 3           # normal size serif font
  FONT_HERSHEY_TRIPLEX* = 4           # normal size serif font (more complex than FONT_HERSHEY_COMPLEX)
  FONT_HERSHEY_COMPLEX_SMALL* = 5     # smaller version of FONT_HERSHEY_COMPLEX
  FONT_HERSHEY_SCRIPT_SIMPLEX* = 6    # hand-writing style font
  FONT_HERSHEY_SCRIPT_COMPLEX* = 7    # more complex variant of FONT_HERSHEY_SCRIPT_SIMPLEX
  FONT_ITALIC* = 16                   # flag for italic font
