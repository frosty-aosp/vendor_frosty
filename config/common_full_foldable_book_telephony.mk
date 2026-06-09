# Inherit mobile full common Lineage stuff
$(call inherit-product, vendor/frosty/config/common_mobile_full.mk)

# Enable support of one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode?=true

# Inherit tablet common Lineage stuff
$(call inherit-product, vendor/frosty/config/tablet.mk)

$(call inherit-product, vendor/frosty/config/telephony.mk)

PRODUCT_PACKAGE_OVERLAYS += vendor/frosty/overlay/foldable_book
