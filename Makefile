GO_EASY_ON_ME = 1
include /framework/makefiles/common.mk

TWEAK_NAME = WOS7
WOS7_FILES = Tweak.xm
WOS7_FRAMEWORKS = Foundation UIKit CoreGraphics QuartzCore
WOS7_OBJC_FILES = WOS7Tile.m WOS7ListApp.m WOS7.m

include /framework/makefiles/tweak.mk