#!/usr/bin/env bash
# ============================================================================
#
# FILE:         updateSpectrecoin.sh
#
# DESCRIPTION:  Simple installer script to update local Spectrecoin binaries
#
# AUTHOR:       HLXEasy
# PROJECT:      https://spectreproject.io/
#               https://github.com/spectrecoin/spectre
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
                ;;
            "10")
                releaseName='-buster'
                ;;
            *)
                case ${PRETTY_NAME} in
                    "*bullseye*")
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
    "ubuntu")
        usedDistro="ubuntu"
        case ${VERSION_CODENAME} in
            "bionic")
                releaseName='-18-04'
                ;;
            "disco")
                releaseName='-19-04'
                ;;
            *)
                echo "Unsupported operating system ID=${ID}, VERSION_ID=${VERSION_CODENAME}"
                exit
                ;;
        esac
        ;;
    "fedora")
        usedDistro="Fedora"
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
                    "*bullseye*")
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

curl ${cacertParam} -L -s https://raw.githubusercontent.com/spectrecoin/installer/splitUpdaterscripts/linux/updateSpectrecoin-${usedDistro}${releaseName}.sh | sudo bash -s "${versionToInstall}"
