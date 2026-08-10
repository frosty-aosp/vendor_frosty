PRODUCT_BRAND ?= Frosty

# Frosty packages
PRODUCT_PACKAGES += \
    AicpExtras \
    AppCompatConfig \
    Talk \
    GoogleVoice

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/app/Talk/Talk.apk \
    system/app/GoogleVoice/GoogleVoice.apk \
    system/app/CarHome/CarHome.apk \
    system/etc/default-permissions/app.grapheneos.gmscompat.xml \
    system/etc/sysconfig/app.grapheneos.gmscompat.xml

# Frosty Ad-block
PRODUCT_PACKAGES += \
    hosts.frosty_adblock

# A/B OTA Optimization
ifneq ($(AB_OTA_PARTITIONS),)
PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script
endif

# Bootanimation include
PRODUCT_PACKAGES += \
    bootanimation.zip

# Custom off-mode charger
PRODUCT_PACKAGES += \
    charger_res_images

ifeq ($(WITH_FROSTY_CHARGER),true)
PRODUCT_PACKAGES += \
    frosty_charger_res_images \
    font_log.png \
    libhealthd.frosty
endif

# System Allow List
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/clean_cache.sh \
    system/etc/hosts.frosty_adblock \
    system/etc/permissions/android.software.nfc.beam.xml \
    system/etc/permissions/android.software.sip.voip.xml \
    system/etc/permissions/privapp-permissions-frosty.xml \
    system/etc/permissions/privapp_whitelist_org.omnirom.omnijaws-ext.xml \
    system/lib/content-types.properties \
    system/lib/libsepol.so \
    system/lib64/libsepol.so \
    system/xbin/wget

# OmniJaws
PRODUCT_PACKAGES += \
    OmniJaws

# Optional packages
PRODUCT_PACKAGES += \
    WallpaperPicker2

PRODUCT_PACKAGES += \
    GameSpace

# Extra tools
PRODUCT_PACKAGES += \
    e2fsck \
    libsepol \
    mke2fs \
    tune2fs \
    wget

# AOSP recovery flashing
ifeq ($(TARGET_USES_AOSP_RECOVERY),true)
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.recovery_update=true
endif

# Google sounds
include vendor/frosty/google/GoogleAudio.mk

# TWRP
ifeq ($(BUILD_TWRP),true)
RECOVERY_TYPE := twrp
else
RECOVERY_TYPE := aosp
endif

# Clean cache script
PRODUCT_COPY_FILES += \
    vendor/frosty/prebuilt/common/bin/clean_cache.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/clean_cache.sh

# system mount
PRODUCT_COPY_FILES += \
    vendor/frosty/prebuilt/common/bin/system-mount.sh:install/bin/system-mount.sh

# Don't compile SystemUITests
EXCLUDE_SYSTEMUI_TESTS := true

# Frosty permissions
PRODUCT_COPY_FILES += \
    vendor/frosty/config/permissions/privapp-permissions-frosty-system.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-frosty.xml \
    vendor/frosty/config/permissions/privapp-permissions-frosty-system-ext.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-frosty.xml \
    vendor/frosty/config/permissions/privapp-permissions-frosty-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-frosty.xml

# Audio files
$(call inherit-product, vendor/frosty/audio/audio.mk)

# Font files
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,vendor/frosty/prebuilt/common/fonts,$(TARGET_COPY_OUT_PRODUCT)/fonts)

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/frosty/prebuilt/common/lib/content-types.properties:$(TARGET_COPY_OUT_SYSTEM)/lib/content-types.properties

# FROSTY overlays
-include packages/overlays/Frosty/product_packages.mk
