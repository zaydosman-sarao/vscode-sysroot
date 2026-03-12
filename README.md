# vscode-sysroot

This repository contains a precompiled sysroot and patchelf binary that allows vscode
server to run on older linux systems with glibc versions that support has been deprecated
for.

This repository is intended to be used on Meerkat development systems at SARAO, but should
work on any linux system.

The sysroot and patchelf binary were compiled using the instructions found at this
[link](https://code.visualstudio.com/docs/remote/faq#_can-i-run-vs-code-server-on-older-linux-distributions).
If you have any security concerns (which is valid), you are welcome to compile the
sysroot and patchelf binary yourself by following the same instructions, and using the
installation script from this repository.

## Prerequisites

1. Install git-lfs. This is required to pull the actual tarball containing the sysroot
and patchelf binary in the repository directory. On Ubuntu:

```terminal
apt install git-lfs
```

## Installation

1. Clone this repository.

2. In the repository directory, pull the tarball containing the sysroot and patchelf
binary with git-lfs:

```terminal
git lfs pull
```

3. (OPTIONAL AND NOT RECOMMENDED) Override the installation path or `.profile` file
location.

By default, the directory `$HOME/.vscode-sysroot` is created and the sysroot and patchelf
binary are installed it. It is highly recommended to leave this default as-is.
Optionally, the default may be overidden by setting the environment variable
`$INSTALL_PATH` to an alternative installation path.

By default, variables are added to the file `$HOME/.profile` to persist environment
variables used by vscode server to locate the patchelf and sysroot binaries. It is highly
recommended to leave this default as-is. Optionally, the default may be overidden by
setting the environment variable `$PROFILE_PATH` to an alternative path for the
`.profile` file.

> [!CAUTION]
The option to overwrite an existing installation will first remove the existing
installation. If the installation path is unintentionally overridden to a critical path
via the `$INSTALL_PATH` environment variable, it's removal will cause loss of data and
potentially system corruption, depending on the exact overridden path. It is highly
recommended to stick to the defaults.

4. Execute the `install.sh` script:

```terminal
chmod +x install.sh && sudo ./install.sh
```
