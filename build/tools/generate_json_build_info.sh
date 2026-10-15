#!/bin/bash

BASE_URL="https://frosty.b-cdn.net/"

read -r -a EXTRA_FILES <<<"${EXTRA_FILES:-boot.img dtbo.img init_boot.img recovery.img super_empty.img vbmeta.img vbmeta_system.img vbmeta_vendor.img vendor_boot.img vendor_kernel_boot.img build-manifest.xml}"

if [ "$1" ]
then
  ZIP_PATH=$1
  ZIP_NAME=$(basename "$ZIP_PATH")
  DEVICE=$(echo $TARGET_PRODUCT | cut -d "_" -f2)

  if [[ -f $ZIP_PATH && $FROSTY_BUILDTYPE != "UNOFFICIAL" ]]; then
    ZIP_SIZE=$(stat -c%s $ZIP_PATH)
    SHA256=$(cat "$ZIP_PATH.sha256sum" | cut -d' ' -f1)
    SHA1="$(sha1sum "$ZIP_PATH" | cut -d' ' -f1)"
    DATETIME=$(grep ro\.build\.date\.utc ./out/target/product/$DEVICE/system/build.prop | cut -d= -f2);
    ROM_VERSION=$(grep ro\.frosty\.version ./out/target/product/$DEVICE/product/etc/build.prop | cut -d= -f2 | cut -d "v" -f2);
    CUSTOM_BUILD_TYPE=$(grep ro\.frosty\.releasetype ./out/target/product/$DEVICE/product/etc/build.prop | cut -d= -f2);

    if [[ ! $DATETIME =~ ^[0-9]+$ ]]; then
        DATETIME="$(stat -c %Y "$ZIP")"
        echo "warning: no post-timestamp in metadata, falling back to file mtime" >&2
    fi
    DATE="$(date -u -d "@$DATETIME" +%F)"
    DATE_COMPACT="${DATE//-/}"

    METADATA="$(unzip -p "$ZIP_PATH" META-INF/com/android/metadata 2>/dev/null || true)"
    [[ -n $METADATA ]] || echo "no META-INF/com/android/metadata in $FILENAME — is this an OTA zip?"
     
    # Prints the value of a key=value line from the metadata (first match only).
    meta() { sed -n "s/^$1=//;T;p;q" <<<"$METADATA"; }

    OS_PATCH_LEVEL="$(meta post-security-patch-level)"
    OS_SDK_LEVEL="$(meta post-sdk-level)"
    OTA_PROPERTY_FILES="$(meta ota-property-files)"   # trailing padding is kept on purpose

    PATH_PREFIX="$DEVICE/$ROM_VERSION/$DATE_COMPACT"


    EXTRAS_JSON="$(
        for name in "${EXTRA_FILES[@]}"; do
            f="./out/target/product/$DEVICE/$name"
            [[ -f $f ]] || continue
            echo "OTA JSON: Adding $name" >&2
            jq -nc \
                --arg filename "$name" \
                --arg filepath "$PATH_PREFIX/$name" \
                --arg sha1 "$(sha1sum "$f" | cut -d' ' -f1)" \
                --arg sha256 "$(sha256sum "$f" | cut -d' ' -f1)" \
                --argjson size "$(stat -c %s "$f")" \
                --arg url "$BASE_URL$PATH_PREFIX/$name" \
                '{filename: $filename, filepath: $filepath, sha1: $sha1, sha256: $sha256, size: $size, url: $url}'
        done | jq -s '.'
    )"

    TMP="$(mktemp "$ZIP_PATH.json.XXXXXX")"
    trap 'rm -f "$TMP"' EXIT
     
    jq -n -S \
        --arg date "$DATE" \
        --argjson datetime "$DATETIME" \
        --arg type "$CUSTOM_BUILD_TYPE" \
        --arg version "$ROM_VERSION" \
        --arg filename "$ZIP_NAME" \
        --arg filepath "$PATH_PREFIX/$ZIP_NAME" \
        --arg sha1 "$SHA1" \
        --arg sha256 "$SHA256" \
        --argjson size "$ZIP_SIZE" \
        --arg url "$BASE_URL$PATH_PREFIX/$ZIP_NAME" \
        --arg patch "$OS_PATCH_LEVEL" \
        --arg sdk "$OS_SDK_LEVEL" \
        --arg opf "$OTA_PROPERTY_FILES" \
        --argjson extras "$EXTRAS_JSON" \
        '[{
            date: $date,
            datetime: $datetime,
            type: $type,
            version: $version,
            files: ([
                ({
                    date: $date,
                    datetime: $datetime,
                    filename: $filename,
                    filepath: $filepath,
                    sha1: $sha1,
                    sha256: $sha256,
                    size: $size,
                    type: $type,
                    url: $url
                }
                + (if $patch != "" then {os_patch_level: $patch} else {} end)
                + (if $sdk   != "" then {os_sdk_level: ($sdk | tonumber)} else {} end)
                + (if $opf   != "" then {ota_property_files: $opf} else {} end))
            ] + $extras)
        }]' >"$TMP"

    mv "$TMP" "$ZIP_PATH.json"
    trap - EXIT

    echo "OTA JSON: $ZIP_PATH.json"
  fi
fi
