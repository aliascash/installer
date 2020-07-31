#!/usr/bin/env bash
# ============================================================================
#
# FILE:         updateSpectrecoin-raspberry-stretch.sh
#
# SPDX-FileCopyrightText: © 2020 Alias Developers
# SPDX-FileCopyrightText: © 2016 SpectreCoin Developers
# SPDX-License-Identifier: MIT
#
# DESCRIPTION:  Simple installer script to update Spectrecoin binaries
#               on Raspbian Stretch
#
# AUTHOR:       HLXEasy
# PROJECT:      https://alias.cash/
#               https://github.com/aliascash/aliaswallet
#
# ============================================================================

versionToInstall=$1

# ----------------------------------------------------------------------------
# Use ca-certificates if available
if [[ -e /etc/ssl/certs/ca-certificates.crt ]] ; then
    cacertParam="--cacert /etc/ssl/certs/ca-certificates.crt"
fi

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
# Check current system
case ${ID} in
    "raspbian")
        case ${VERSION_ID} in
            "9")
                echo "Running on ${ID}/${VERSION_ID}"
                ;;
            *)
                echo "Unable to execute update script for Raspbian Stretch on this system:"
                cat /etc/os-release
                exit 1
                ;;
        esac
        ;;
    *)
        echo "Wrong update script for operating system ${ID}!"
        exit 1
        ;;
esac

echo ""
echo "======================================================================"
echo "=                                                                    ="
echo "=              Your system is running Raspbian Buster                ="
echo "=                                                                    ="
echo "=         A silent system upgrade is not possible this way           ="
echo "=                                                                    ="
echo "=              Please stop the Wallet on this system,                ="
echo "=                  backup your wallet.dat file                       ="
echo "=             and install the latest raspbian image from             ="
echo "=           https://alias.cash/index.html#download            ="
echo "=      onto a different SD card, so you have this one as backup.     ="
echo "=                                                                    ="
echo "======================================================================"
echo ""
