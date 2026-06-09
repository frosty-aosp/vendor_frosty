# Inherit mobile full common Lineage stuff
$(call inherit-product, vendor/frosty/config/common_mobile_full.mk)

# Inherit tablet common Lineage stuff
$(call inherit-product, vendor/frosty/config/tablet.mk)

$(call inherit-product, vendor/frosty/config/wifionly.mk)
