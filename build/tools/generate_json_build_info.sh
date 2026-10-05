#!/bin/bash
if [ "$1" ]
then
  file_path=$1
  file_name=$(basename "$file_path")
  DEVICE=$(echo $TARGET_PRODUCT | cut -d "_" -f2)
  if [[ -f $file_path && $FROSTY_BUILDTYPE != "UNOFFICIAL" ]]; then
    file_size=$(stat -c%s $file_path)
    id=$(cat "$file_path.sha256sum" | cut -d' ' -f1)
    datetime=$(grep ro\.build\.date\.utc ./out/target/product/$DEVICE/system/build.prop | cut -d= -f2);
    rom_version=$(grep ro\.frosty\.version ./out/target/product/$DEVICE/product/etc/build.prop | cut -d= -f2 | cut -d "v" -f2);
    custom_build_type=$(grep ro\.frosty\.releasetype ./out/target/product/$DEVICE/product/etc/build.prop | cut -d= -f2);
    echo "{\n  \"response\": [\n    {\n      \"datetime\": $datetime,\n      \"filename\": \"$file_name\",\n      \"id\": \"$id\",\n      \"romtype\": \"$custom_build_type\",\n      \"size\": $file_size,\n      \"url\": \"https://frosty.b-cdn.net/$DEVICE/$file_name\",\n      \"version\": \"$rom_version\"\n    }\n  ]\n}" > $file_path.json
    echo "OTA JSON: $file_path.json"
  fi
fi
