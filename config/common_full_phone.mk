# Inherit mobile full common Lineage stuff
$(call inherit-product, vendor/frosty/config/common_mobile_full.mk)

# Enable support of one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode?=true

$(call inherit-product, vendor/frosty/config/telephony.mk)
