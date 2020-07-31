#!/usr/bin/env bash
# ============================================================================
#
# FILE:         updateAliaswallet-debian-stretch.sh
#
# SPDX-FileCopyrightText: © 2020 Alias Developers
# SPDX-FileCopyrightText: © 2016 SpectreCoin Developers
# SPDX-License-Identifier: MIT
#
# DESCRIPTION:  Simple installer script to update Aliaswallet binaries
#               on Debian Stretch
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
    "debian")
        case ${VERSION_ID} in
            "9")
                echo "Running on ${ID}/${VERSION_ID}"
                ;;
            *)
                echo "Unable to execute update script for Debian Stretch on this system:"
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
echo "=       Your system will be updated/upgraded to Debian Buster        ="
echo "=                                                                    ="
echo "=          At first all packages will be updated/upgraded            ="
echo "=        and afterwards the system upgrade will be performed         ="
echo "=             Last step is to reboot the whole system                ="
echo "=                   to boot into Debian Buster                       ="
echo "======================================================================"
echo ""
echo "Press return to see the list of steps which will be performed."

read a

echo ""
echo "The following steps will be performed:"
echo "- Update /etc/apt/sources.list"
echo "- Remove backports and testing repo on /etc/apt/sources.list.d/"
echo "- apt update"
echo "- apt upgrade"
echo "- apt full-upgrade"
echo "- reboot"
echo ""
echo "During these steps there might be additional user input required"
echo ""

echo "======================================================================"
echo "    Go ahead with upgrade? "
echo -n "    Type 'YES' to go ahead or anything else to cancel: "
read doUpgrade

if [[ "${doUpgrade}" -ne "YES" ]] ; then
    echo "System upgrade canceled, press return to exit update script"
    read a
    exit
fi

echo "Updating /etc/apt/sources.list"
sudo sed -i "s/stretch/buster/g" /etc/apt/sources.list

echo "Removing /etc/apt/sources.list.d/*backport*.list"
sudo rm /etc/apt/sources.list.d/*backport*.list

echo "Removing /etc/apt/sources.list.d/*test*.list"
sudo rm /etc/apt/sources.list.d/*test*.list

echo "Performing apt update"
sudo apt update

echo "Performing apt upgrade"
sudo apt upgrade

echo "Performing apt full-upgrade"
sudo apt full-upgrade

echo ""
echo "All finished. The system will reboot now."
echo "Please start the update afterwards again!"
echo "Press return to reboot the system."
read a
sudo reboot
