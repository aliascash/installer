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
tmpWorkdir=/tmp/SpectrecoinUpdate
tmpChecksumfile=checksumfile.txt
tmpBinaryArchive=Spectrecoin.tgz

echo "Determining system"
if [[ -e /etc/os-release ]] ; then
    . /etc/os-release
else
    echo "File /etc/os-release not found, not updating anything"
    exit 1
fi
echo "   Determined $NAME"

if [[ -e ${installPath}/spectrecoind ]] ; then
    currentVersion=$(${installPath}/spectrecoind -version)
    echo "Creating backup of current version ${currentVersion}"
    if [[ -f ${installPath}/spectrecoind-${currentVersion} ]] ; then
        echo "   Backup of current version already existing"
    else
        mv ${installPath}/spectrecoin  ${installPath}/spectrecoin-${currentVersion}
        mv ${installPath}/spectrecoind ${installPath}/spectrecoind-${currentVersion}
        echo "   Done"
    fi
else
    echo "Binary ${installPath}/spectrecoind not found, skip backup creation"
fi

echo "Downloading checksum file"
checksumfile=''
case ${NAME} in
    "Debian GNU/Linux")
        checksumfile="Checksum-Spectrecoin-Debian.txt"
        ;;
    "Ubuntu")
        checksumfile="Checksum-Spectrecoin-Ubuntu.txt"
        ;;
    "Fedora")
        checksumfile="Checksum-Spectrecoin-Fedora.txt"
        ;;
esac

mkdir -p ${tmpWorkdir}

#https://github.com/spectrecoin/spectre/releases/latest
#https://github.com/spectrecoin/spectre/releases/download/2.2.1/Spectrecoin-2.2.1-8706c85-Ubuntu.tgz
#https://github.com/spectrecoin/spectre/releases/download/Build127/Spectrecoin-Build127-8e152a8-Debian.tgz
checksumfileToDownload=https://github.com/spectrecoin/spectre/releases/download/Build1/Checksum-Spectrecoin-${checksumfile}.txt
wget ${checksumfileToDownload} -o ${tmpWorkdir}/${tmpChecksumfile}

filenameToDownload=$(head -n 1 ${tmpWorkdir}/${tmpChecksumfile})
givenMD5Hash=$(head -n 2 ${tmpWorkdir}/${tmpChecksumfile} | tail -n 1)
givenSHA1Hash=$(head -n 3 ${tmpWorkdir}/${tmpChecksumfile} | tail -n 1)
givenSHA256Hash=$(head -n 4 ${tmpWorkdir}/${tmpChecksumfile} | tail -n 1)
echo "   Done"

echo "Downloading binaries"
wget https://github.com/spectrecoin/spectre/releases/download/Build2/${filenameToDownload} -o ${tmpWorkdir}/${tmpBinaryArchive}
echo "   Done"

echo "Verifying checksums"
determinedMD5Hash=$(md5sum ${tmpWorkdir}/${tmpBinaryArchive} | awk '{ print $1 }')
determinedSHA1Hash=$(sha1sum ${tmpWorkdir}/${tmpBinaryArchive} | awk '{ print $1 }')
determinedSHA256Hash=$(sha256sum ${tmpWorkdir}/${tmpBinaryArchive} | awk '{ print $1 }')

if [[ "${givenMD5Hash}" != "${determinedMD5Hash}" ]] ; then
    echo "ERROR: MD5 hash of downloaded file not matching value from ${checksumfileToDownload}"
    exit 1
fi
if [[ "${givenSHA1Hash}" != "${determinedSHA1Hash}" ]] ; then
    echo "ERROR: SHA1 hash of downloaded file not matching value from ${checksumfileToDownload}"
    exit 1
fi
if [[ "${givenSHA256Hash}" != "${determinedSHA256Hash}" ]] ; then
    echo "ERROR: SHA256 hash of downloaded file not matching value from ${checksumfileToDownload}"
    exit 1
fi
echo "   Downloaded archive is ok, checksums match values from ${checksumfileToDownload}"

echo "Installing new binaries"
cd ${tmpWorkdir}
tar xzf ${tmpBinaryArchive} .
mv usr/local/bin/spectre* /usr/local/bin/
echo "   Done"

echo "Cleanup"
rm -rf ${tmpWorkdir}
echo "   Done"
