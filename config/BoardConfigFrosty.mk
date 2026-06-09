# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0

# Charger
ifeq ($(WITH_FROSTY_CHARGER),true)
    BOARD_HAL_STATIC_LIBRARIES := libhealthd.frosty
endif

# things to be set on AB devices
ifeq ($(TARGET_IS_AB_DEVICE),true)
    AB_OTA_UPDATER := true
endif

include vendor/frosty/config/BoardConfigSoong.mk
include vendor/frosty/config/BoardConfigLineage.mk
