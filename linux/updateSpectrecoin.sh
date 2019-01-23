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
installPath=/usr/local/bin
tmpWorkdir=/tmp/SpectrecoinUpdate
tmpChecksumfile=checksumfile.txt
tmpBinaryArchive=Spectrecoin.tgz

if [[ -z "${versionToInstall}" ]] ; then
    echo "No version to install (tag) given, installing latest release"
    githubTag=$(curl -L -s https://api.github.com/repos/spectrecoin/spectre/releases/latest | grep tag_name | cut -d: -f2 | cut -d '"' -f2)
else
    githubTag=${versionToInstall}
fi
echo ""

echo "Determining system"
if [[ -e /etc/os-release ]] ; then
    . /etc/os-release
else
    echo "File /etc/os-release not found, not updating anything"
    exit 1
fi
echo "    Determined $NAME"
echo ""

if [[ -e ${installPath}/spectrecoind ]] ; then
    # Option '-version' is working since v3.x
    #currentVersion=$(${installPath}/spectrecoind -version)
    # At the moment use a workaround
    currentVersion=$(strings ${installPath}/spectrecoind | grep "v[123]\..\..\." | head -n 1)
    if [[ -z "${currentVersion}" ]] ; then
        currentVersion=$(date +%Y%m%d-%H%M)
        echo "Unable to determine version of current binaries, using timestamp '${currentVersion}'"
    else
        echo "Creating backup of current version ${currentVersion}"
    fi
    if [[ -f ${installPath}/spectrecoind-${currentVersion} ]] ; then
        echo "    Backup of current version already existing"
    else
        mv ${installPath}/spectrecoin  ${installPath}/spectrecoin-${currentVersion}
        mv ${installPath}/spectrecoind ${installPath}/spectrecoind-${currentVersion}
        echo "    Done"
    fi
else
    echo "Binary ${installPath}/spectrecoind not found, skip backup creation"
fi
echo ""

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
downloadBaseURL=https://github.com/spectrecoin/spectre/releases/download/${githubTag}
checksumfileToDownload=${downloadBaseURL}/${checksumfile}
echo "Downloading checksum file ${checksumfileToDownload}"
curl -L -o ${tmpWorkdir}/${tmpChecksumfile} ${checksumfileToDownload}
if [[ $(cat ${tmpWorkdir}/${tmpChecksumfile}) = 'Not Found' ]] ; then
    echo "Checksum file ${checksumfileToDownload} not found!"
    exit 1
fi
echo "    Done"
echo ""
filenameToDownload=$(head -n 1 ${tmpWorkdir}/${tmpChecksumfile})
givenMD5Hash=$(head -n 2 ${tmpWorkdir}/${tmpChecksumfile} | tail -n 1 | tr -s " " | cut -d ' ' -f 2)
givenSHA1Hash=$(head -n 3 ${tmpWorkdir}/${tmpChecksumfile} | tail -n 1 | tr -s " " | cut -d ' ' -f 2)
givenSHA256Hash=$(head -n 4 ${tmpWorkdir}/${tmpChecksumfile} | tail -n 1 | tr -s " " | cut -d ' ' -f 2)
givenSHA512Hash=$(head -n 5 ${tmpWorkdir}/${tmpChecksumfile} | tail -n 1 | tr -s " " | cut -d ' ' -f 2)

echo "Downloading binary archive ${downloadBaseURL}/${filenameToDownload}"
curl -L -o ${tmpWorkdir}/${tmpBinaryArchive} ${downloadBaseURL}/${filenameToDownload} || echo "Error downloading archive file ${downloadBaseURL}/${filenameToDownload}"
if [[ "$(head -n 1 ${tmpWorkdir}/${tmpBinaryArchive})" = 'Not Found' ]] ; then
    echo "Archive ${downloadBaseURL}/${filenameToDownload} not found!"
    exit 1
fi
echo "    Done"
echo ""

echo "Verifying checksums"
determinedMD5Hash=$(md5sum ${tmpWorkdir}/${tmpBinaryArchive} | awk '{ print $1 }')
if [[ "${givenMD5Hash}" != "${determinedMD5Hash}" ]] ; then
    echo "ERROR: MD5 hash of downloaded file not matching value from ${checksumfileToDownload} (${givenMD5Hash} != ${determinedMD5Hash})"
    exit 1
else
    echo "    MD5 hash OK"
fi
determinedSHA1Hash=$(sha1sum ${tmpWorkdir}/${tmpBinaryArchive} | awk '{ print $1 }')
if [[ "${givenSHA1Hash}" != "${determinedSHA1Hash}" ]] ; then
    echo "ERROR: SHA1 hash of downloaded file not matching value from ${checksumfileToDownload} (${givenSHA1Hash} != ${determinedSHA1Hash})"
    exit 1
else
    echo "    SHA1 hash OK"
fi
determinedSHA256Hash=$(sha256sum ${tmpWorkdir}/${tmpBinaryArchive} | awk '{ print $1 }')
if [[ "${givenSHA256Hash}" != "${determinedSHA256Hash}" ]] ; then
    echo "ERROR: SHA256 hash of downloaded file not matching value from ${checksumfileToDownload} (${givenSHA256Hash} != ${determinedSHA256Hash})"
    exit 1
else
    echo "    SHA256 hash OK"
fi
determinedSHA512Hash=$(sha512sum ${tmpWorkdir}/${tmpBinaryArchive} | awk '{ print $1 }')
if [[ "${givenSHA512Hash}" != "${determinedSHA512Hash}" ]] ; then
    echo "ERROR: SHA512 hash of downloaded file not matching value from ${checksumfileToDownload} (${givenSHA512Hash} != ${determinedSHA512Hash})"
    exit 1
else
    echo "    SHA512 hash OK"
fi
echo "    Downloaded archive is ok, checksums match values from ${checksumfileToDownload}"
echo ""

echo "Installing new binaries"
cd ${tmpWorkdir}
tar xzf ${tmpBinaryArchive} .
mv usr/local/bin/spectre* /usr/local/bin/
chmod +x /usr/local/bin/spectre*
echo "    Done"
echo ""

echo "Cleanup"
rm -rf ${tmpWorkdir}
echo "    Done"
echo ""
