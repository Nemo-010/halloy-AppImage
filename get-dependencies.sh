#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Downloading and extracting Halloy assets..."
echo "---------------------------------------------------------------"

TAR_LINK=$(curl -s "https://api.github.com/repos/squidowl/halloy/releases/latest" | 
           jq -r '.assets[] | select(.name | endswith("-x86_64-linux.tar.gz")) | .browser_download_url' | 
           head -n 1)

if wget --retry-connrefused --tries=30 "$TAR_LINK" -O halloy_latest.tar.gz 2>/tmp/download.log; then
    tar -xvf halloy_latest.tar.gz
    rm -f halloy_latest.tar.gz

    mkdir -p ./AppDir/bin
    mkdir -p ./AppDir/.DirIcon

    mv ./tmp_extract/bin/halloy ./AppDir/bin/halloy

    cp /share/icons/hicolor/512x512/apps/org.squidowl.halloy.png ./AppDir/.DirIcon/org.squidowl.halloy.png

    mv ./tmp_extract/share/applications/org.squidowl.halloy.desktop ./AppDir/org.squidowl.halloy.desktop

    echo "Installing debloated packages..."
    echo "---------------------------------------------------------------"
    get-debloated-pkgs --add-common --prefer-nano
