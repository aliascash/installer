#!/usr/bin/env bash
# ============================================================================
#
# FILE:         updateAliaswallet.sh
#
# SPDX-FileCopyrightText: © 2020 Alias Developers
# SPDX-FileCopyrightText: © 2016 SpectreCoin Developers
# SPDX-License-Identifier: MIT
#
# DESCRIPTION:  Simple installer script to update local Alias wallet binaries
#
# AUTHOR:       HLXEasy
# PROJECT:      https://alias.cash/
#               https://github.com/aliascash/alias-wallet
#
# ============================================================================

versionToInstall=$1

# ----------------------------------------------------------------------------
# Determining current operating system (distribution)
echo "Determining system"
if [[ -e /etc/os-release ]] ; then
    . /etc/os-release
else
    echo "File /etc/os-release not found, not updating anything"
    exit 1
fi
echo "    Determined $NAME"
echo ""

# ----------------------------------------------------------------------------
# Current aarch64 Raspberry Pi OS has ID=debian on /etc/os-release
# So check if we're really on a Raspi or not
handleRaspiAarch64() {
    if [ "$(uname -m)" = aarch64 ] ; then
        usedDistro="raspberry"
        releaseName="${releaseName}-aarch64"
    fi
}

# ----------------------------------------------------------------------------
# Use ca-certificates if available
if [[ -e /etc/ssl/certs/ca-certificates.crt ]] ; then
    cacertParam='--cacert /etc/ssl/certs/ca-certificates.crt'
fi

usedDistro=''
releaseName=''
case ${ID} in
    "debian")
        usedDistro="debian"
        case ${VERSION_ID} in
            "9")
                releaseName='-stretch'
                handleRaspiAarch64
                ;;
            "10")
                releaseName='-buster'
                handleRaspiAarch64
                ;;
            *)
                case ${PRETTY_NAME} in
                    *"bullseye"*)
                        echo "Detected ${PRETTY_NAME}, installing Buster binaries"
                        releaseName='-buster'
                        handleRaspiAarch64
                        ;;
                    *)
                        echo "Unsupported operating system ID=${ID}, VERSION_ID=${VERSION_ID}"
                        cat /etc/os-release
                        exit 1
                        ;;
                esac
                ;;
        esac
        ;;
    "ubuntu")
        usedDistro="ubuntu"
        case ${VERSION_CODENAME} in
            "bionic"|"cosmic")
                releaseName='-18-04'
                ;;
            "disco")
                releaseName='-19-04'
                ;;
            "focal")
                releaseName='-20-04'
                ;;
            *)
                echo "Unsupported operating system ID=${ID}, VERSION_ID=${VERSION_CODENAME}"
                exit
                ;;
        esac
        ;;
    "centos")
        usedDistro="centos"
        ;;
    "fedora")
        usedDistro="fedora"
        ;;
    "raspbian")
        usedDistro="raspberry"
        case ${VERSION_ID} in
            "9")
                releaseName='-stretch'
                ;;
            "10")
                releaseName='-buster'
                ;;
            *)
                case ${PRETTY_NAME} in
                    *"bullseye"*)
                        echo "Detected ${PRETTY_NAME}, installing Buster binaries"
                        releaseName='-buster'
                        ;;
                    *)
                        echo "Unsupported operating system ID=${ID}, VERSION_ID=${VERSION_ID}"
                        cat /etc/os-release
                        exit 1
                        ;;
                esac
                ;;
        esac
        ;;
    *)
        echo "Unsupported operating system ${ID}, VERSION_ID=${VERSION_ID}"
        exit
        ;;
esac

curl ${cacertParam} -L -s https://raw.githubusercontent.com/aliascash/installer/master/linux/updateAliaswallet-${usedDistro}${releaseName}.sh | sudo bash -s "${versionToInstall}"
