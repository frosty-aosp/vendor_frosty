# Inherit mobile mini common Lineage stuff
$(call inherit-product, vendor/frosty/config/common_mobile_mini.mk)

# Inherit tablet common Lineage stuff
$(call inherit-product, vendor/frosty/config/tablet.mk)

$(call inherit-product, vendor/frosty/config/telephony.mk)
