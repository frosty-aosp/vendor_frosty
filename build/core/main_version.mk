# Build fingerprint
ifneq ($(BUILD_FINGERPRINT),)
PRODUCT_SYSTEM_PROPERTIES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)
endif

# Frosty System Version
PRODUCT_SYSTEM_PROPERTIES += \
    ro.frosty.display.version=$(FROSTY_VERSION) \
    ro.frosty.buildtype=$(FROSTY_BUILDTYPE) \
    ro.frosty.version.update=$(FROSTY_BRANCH)-$(VERSION) \
    ro.modversion=$(FROSTY_VERSION) \
    ro.frosty.version=$(VERSION)-$(FROSTY_BUILDTYPE)

# additions for LOS-recovery
#PRODUCT_SYSTEM_PROPERTIES += \
#    ro.lineage.build.version=$(VERSION) \
#    ro.lineage.version=-$(shell date +%Y%m%d)_$(shell date +%H%M%S)-

# Frosty Stats
PRODUCT_SYSTEM_PROPERTIES += \
    ro.frosty.branch=$(FROSTY_BRANCH) \
    ro.romstats.url=https://stats.frosty-rom.com/ \
    ro.romstats.name=Frosty \
    ro.romstats.buildtype=$(FROSTY_BUILDTYPE) \
    ro.romstats.version=$(VERSION) \
    ro.romstats.tframe=1 \
    ro.romstats.askfirst=1
