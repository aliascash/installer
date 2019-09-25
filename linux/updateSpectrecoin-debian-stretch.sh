#!/usr/bin/env bash
# ============================================================================
#
# FILE:         updateSpectrecoin-debian-stretch.sh
#
# DESCRIPTION:  Simple installer script to update Spectrecoin binaries
#               on Debian Stretch
#
# AUTHOR:       HLXEasy
# PROJECT:      https://spectreproject.io/
#               https://github.com/spectrecoin/spectre
#
# ============================================================================

versionToInstall=$1
installPath=/usr/local/bin
tmpWorkdir=/tmp/SpectrecoinUpdate
tmpChecksumfile=checksumfile.txt
tmpBinaryArchive=Spectrecoin.tgz
backportsFile="/etc/apt/sources.list.d/stretch-backports.list"
backportsRepo="deb http://ftp.debian.org/debian stretch-backports main"
testingFile="/etc/apt/sources.list.d/testing.list"
testingRepo="deb http://http.us.debian.org/debian/ testing non-free contrib main"
boostVersion='1.67.0'
usedDistro="Debian"
releaseName='-Stretch'

# ----------------------------------------------------------------------------
# Use ca-certificates if available
if [[ -e /etc/ssl/certs/ca-certificates.crt ]] ; then
    cacertParam="--cacert /etc/ssl/certs/ca-certificates.crt"
fi

# ----------------------------------------------------------------------------
# Define version to install
if [[ -z "${versionToInstall}" ]] ; then
    echo "No version to install (tag) given, installing latest release"
    githubTag=$(curl ${cacertParam} -L -s https://api.github.com/repos/spectrecoin/spectre/releases/latest | grep tag_name | cut -d: -f2 | cut -d '"' -f2)
else
    githubTag=${versionToInstall}
fi
echo ""

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
