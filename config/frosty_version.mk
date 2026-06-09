FROSTY_BRANCH=ananas

# FROSTY RELEASE VERSION
FROSTY_VERSION_MAJOR = 1
FROSTY_VERSION_MINOR = 0
FROSTY_VERSION_MAINTENANCE = 0
# Base Lineage version for kernel builds
LINEAGE_VERSION_MAJOR = 23
LINEAGE_VERSION_MINOR = 2

PRODUCT_VERSION_MAJOR := $(FROSTY_VERSION_MAJOR)
PRODUCT_VERSION_MINOR := $(FROSTY_VERSION_MINOR)
PRODUCT_VERSION_MAINTENANCE := $(FROSTY_VERSION_MAINTENANCE)

VERSION := $(FROSTY_VERSION_MAJOR).$(FROSTY_VERSION_MINOR)
DEVICE_NAME := $(shell echo $(TARGET_PRODUCT) | sed -e 's|^frosty_||g')

ifndef FROSTY_BUILDTYPE
    ifdef RELEASE_TYPE
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^FROSTY_||g')
        FROSTY_BUILDTYPE := $(RELEASE_TYPE)
    else
        FROSTY_BUILDTYPE := UNOFFICIAL
    endif
endif

ifdef FROSTY_BUILDTYPE
    ifeq ($(FROSTY_BUILDTYPE), NIGHTLY)
        FROSTY_VERSION := $(TARGET_PRODUCT)_$(FROSTY_BRANCH)-$(VERSION)-NIGHTLY-$(shell date -u +%Y%m%d)
    endif
    ifeq ($(FROSTY_BUILDTYPE), WEEKLY)
       FROSTY_VERSION := $(TARGET_PRODUCT)_$(FROSTY_BRANCH)-$(VERSION)-WEEKLY-$(shell date -u +%Y%m%d)
    endif
    ifeq ($(FROSTY_BUILDTYPE), EXPERIMENTAL)
        FROSTY_VERSION := $(TARGET_PRODUCT)_$(FROSTY_BRANCH)-$(VERSION)-EXPERIMENTAL-$(shell date -u +%Y%m%d)
    endif
    ifeq ($(FROSTY_BUILDTYPE), UNOFFICIAL)
        FROSTY_VERSION := $(TARGET_PRODUCT)_$(FROSTY_BRANCH)-$(VERSION)-UNOFFICIAL-$(shell date -u +%Y%m%d)
    endif
else
#We reset back to UNOFFICIAL
        FROSTY_VERSION := $(TARGET_PRODUCT)_$(FROSTY_BRANCH)-$(VERSION)-UNOFFICIAL-$(shell date -u +%Y%m%d)
endif

# Build fingerprint
ifneq ($(BUILD_FINGERPRINT),)
PRODUCT_PRODUCT_PROPERTIES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)
endif

# Frosty Version
PRODUCT_PRODUCT_PROPERTIES += \
    ro.frosty.version=$(FROSTY_VERSION) \
    ro.frosty.build_version=$(FROSTY_BUILD_VERSION) \
    ro.frosty.releasetype=$(FROSTY_BUILDTYPE) \
    ro.frosty.branch=$(FROSTY_BRANCH)

# additions for LOS-recovery
PRODUCT_PRODUCT_PROPERTIES += \
    ro.lineage.display.version=$(VERSION)-$(shell date -u +%Y%m%d)-${FROSTY_BUILDTYPE}-$(DEVICE_NAME) \
    ro.lineage.version=$(VERSION)-$(shell date -u +%Y%m%d)-${FROSTY_BUILDTYPE}-$(DEVICE_NAME)

