#!/bin/bash

INSTALL_PATH_RAW=${INSTALL_PATH:-"$HOME/.vscode-sysroot"}
ABS_INSTALL_PATH=$(realpath -m "$INSTALL_PATH_RAW")
PROFILE_PATH=${PROFILE_PATH:-"$HOME/.profile"}

if [ "$ABS_INSTALL_PATH" == "$HOME" ] || [ "$ABS_INSTALL_PATH" == "/" ] || [ "$ABS_INSTALL_PATH" == "/root" ]; then
    echo "ERROR: INSTALL_PATH cannot be $HOME, /root, or the system root (/)."
    exit 1
fi

if [ ! -f "$PROFILE_PATH" ]; then
    echo "ERROR: Profile file at ${PROFILE_PATH} does not exist."
    exit 1
fi

if [ -d "$ABS_INSTALL_PATH" ]; then
    echo "WARNING: existing installation found at $ABS_INSTALL_PATH"
    read -p "Press [Enter] to overwrite, or [Ctrl-C] to exit."
    echo "Removing $ABS_INSTALL_PATH..."
    rm -rf "$ABS_INSTALL_PATH"
fi

mkdir -p "$ABS_INSTALL_PATH"

echo "Extracting sysroot and patchelf binary to $ABS_INSTALL_PATH..."
if tar -xzf ./vscode-sysroot-linux-x86_64.tar.gz -C "$ABS_INSTALL_PATH" --strip-components=1; then
    echo "Extraction successful."
else
    echo "ERROR: Extraction failed. Ensure the tarball exists in the current directory."
    exit 1
fi

echo "Updating $PROFILE_PATH..."

# Markers to identify vscod-sysroot variables
START_MARKER="# >>> vscode-sysroot-start >>>"
END_MARKER="# <<< vscode-sysroot-end <<<"

# Delete existing block if it exists
sed -i "/$START_MARKER/,/$END_MARKER/d" "$PROFILE_PATH"

{
    echo "$START_MARKER"
    echo "export VSCODE_SERVER_CUSTOM_GLIBC_LINKER=\"$ABS_INSTALL_PATH/sysroot/lib64/ld-linux-x86-64.so.2\""
    echo "export VSCODE_SERVER_CUSTOM_GLIBC_PATH=\"$ABS_INSTALL_PATH/sysroot/lib64\""
    echo "export VSCODE_SERVER_PATCHELF_PATH=\"$ABS_INSTALL_PATH/patchelf\""
    echo "$END_MARKER"
} >> "$PROFILE_PATH"

echo "Installation complete. Run 'source $PROFILE_PATH' to apply changes."
