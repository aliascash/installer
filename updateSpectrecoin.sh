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

installPath=/usr/local/bin

echo "Determining system"
if [[ -e /etc/os-release ]] ; then
    . /etc/os-release
else
    echo "File /etc/os-release not found, not updating anything"
    exit 1
fi

currentVersion=$(${installPath}/spectrecoind -version)
if [[ -f ${installPath}/spectrecoind-${currentVersion} ]] ; then
    echo "Backup of current version already existing"
else
    echo "Creating backup of current version ${currentVersion}"
    mv ${installPath}/spectrecoin  ${installPath}/spectrecoin-${currentVersion}
    mv ${installPath}/spectrecoind ${installPath}/spectrecoind-${currentVersion}
    echo "Done"
fi

echo "Installing new binaries"
case ${NAME} in
    "Debian GNU/Linux")
        ;;
    "Ubuntu")
        ;;
    "Fedora")
        ;;
esac
