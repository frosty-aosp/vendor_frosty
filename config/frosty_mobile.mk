# FaceUnlock
ifneq ($(PRODUCT_NO_CAMERA), true)
ifneq ($(TARGET_FACE_UNLOCK_OPTOUT), true)
PRODUCT_PACKAGES += \
    LMOFaceUnlock

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/app/LMOFaceUnlock/LMOFaceUnlock.apk \
    system/app/LMOFaceUnlock/oat/%/LMOFaceUnlock.odex \
    system/app/LMOFaceUnlock/oat/%/LMOFaceUnlock.vdex \
    system/app/LMOFaceUnlock/lib/%/libtensorflowlite_jni.so \
    system/etc/face/detect-class1.tflite \
    system/etc/face/detect-class1.txt \
    system/etc/face/mobile_face_net.tflite \
    system/etc/face/mobile_face_net.txt \
    system/etc/permissions/android.hardware.biometrics.face.xml \
    system/lib%/libtensorflowlite_jni.so
endif
endif

# FaceUnlock - Settings RRO
PRODUCT_PACKAGES += \
    FaceUnlockSettingsOverlay

