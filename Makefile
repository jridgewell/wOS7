# GO_EASY_ON_ME = 1
THEOS_BUILD_DIR = build
ARCHS = armv7
DEBUG = 1

include /framework/makefiles/common.mk

TWEAK_NAME = WOS7
WOS7_FILES = Tweak.xm
WOS7_FRAMEWORKS = Foundation UIKit CoreGraphics QuartzCore
WOS7_OBJC_FILES = $(wildcard Classes/*.m)
WOS7_OBJCFLAGS = -Wswitch -Wshadow -Wmissing-braces -Wreturn-type -Wparentheses -Wmissing-field-initializers -Wsign-compare -Wunused-function -Wunused-label -Wno-unused-parameter -Wunused-variable -Wunused-value -Wundeclared-selector -Wmissing-prototypes
#WOS7_OBJCFLAGS += -Wshorten-64-to-32

include /framework/makefiles/tweak.mk

update:
	$(ECHO_NOTHING)mkdir -p "$(THEOS_PROJECT_DIR)/layout/var/mobile/Library/DreamBoard/" $(ECHO_END)
	$(ECHO_NOTHING)rsync -a "$(THEOS_PROJECT_DIR)/_DreamBoardTheme/wOS7" "$(THEOS_PROJECT_DIR)/layout/var/mobile/Library/DreamBoard/" $(_THEOS_RSYNC_EXCLUDE_COMMANDLINE)$(ECHO_END)
	$(ECHO_NOTHING)rsync -a "$(THEOS_PROJECT_DIR)/_Library/wOS7" "$(THEOS_PROJECT_DIR)/layout/var/mobile/Library/" $(_THEOS_RSYNC_EXCLUDE_COMMANDLINE)$(ECHO_END)

new:: all update
