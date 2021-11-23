# Alias Installer
[![GitHub version](https://badge.fury.io/gh/aliascash%2Finstaller.svg)](https://badge.fury.io/gh/aliascash%2Finstaller)
[![HitCount](http://hits.dwyl.io/aliascash/https://github.com/aliascash/installer.svg)](http://hits.dwyl.io/aliascash/https://github.com/aliascash/installer)
[![Build Status](https://github.com/aliascash/installer/actions/workflows/windows-installer.yml/badge.svg/)](https://github.com/aliascash/installer/actions)

This repository contains various components to create standalone installer packages
or to update an existing Alias installation.

## Licensing

- SPDX-FileCopyrightText: © 2020 Alias Developers
- SPDX-FileCopyrightText: © 2016 SpectreCoin Developers

SPDX-License-Identifier: MIT

## Linux
For the supportet Linux distributions there's a simple updater script
located under the folder _linux_. This is the easiest way to update an
existing installation, as long as we cannot provide dedicated packages.

### Requirements
The script is able to update an existing Alias installation resp.
backup and update the Alias wallet binaries located on _/usr/local/bin/_.

To do so, the following additional requirements must be installed:
- bash (to execute the updater script itself)
- curl (to download components to install)
- sudo (to replace binaries)

### How to use
At first, aliaswalletd must be stopped to replace the binaries.

Execute the updater script afterwards with

```
curl -L -s https://raw.githubusercontent.com/aliascash/installer/master/linux/updateAliaswallet.sh | sudo bash -s
```

This will update the local installation to the latest release.

To update with a dedicated (develop-) version, just add the corresponding
tag to the cmdline. The following example shows the installation of `Build129`:

```
curl -L -s https://raw.githubusercontent.com/aliascash/installer/master/linux/updateAliaswallet.sh | sudo bash -s Build129
```

### What it does
1. Determine current OS by examining `/etc/os-release`
1. Download checksum file
1. Download binary archive
1. Verify sha256 hashes
1. Backup current binaries if no backup of current version exists.
1. Install new binaries
1. Cleanup download folder

### Alias Shell UI
If you're using the [Alias Shell UI](https://github.com/aliascash/alias-sh-rpc-ui),
the update script is fully integrated since version 2.5.
Go to _`Advanced -> Update`_ to use it.

## Windows

### Requirements
* [Inno Setup](https://jrsoftware.org/isinfo.php)
* Plugins:
  * [Inno Download Plugin](https://mitrichsoftware.wordpress.com/inno-setup-tools/inno-download-plugin)
* Setup env var `INNOSETUP_DIR` with path to installed Inno Setup folder

### Build installer
* Extract Alias wallet archive to `<clone-location>/windows/content/Alias/`
* Execute `windows/createInstaller.bat` as Administrator
_or_
* Run Inno Setup Compiler and load `<clone-location>/windows/Alias.iss`

The resulting `Alias-Installer.exe` will be located on `<clone-location>/windows/Output/`.
