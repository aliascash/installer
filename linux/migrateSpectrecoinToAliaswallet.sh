#!/usr/bin/env bash
# ============================================================================
#
# FILE:         migrateSpectrecoinToAliaswallet.sh
#
# SPDX-FileCopyrightText: © 2020 Alias Developers
# SPDX-FileCopyrightText: © 2016 SpectreCoin Developers
# SPDX-License-Identifier: MIT
#
# DESCRIPTION:  Helper script to migrate from Spectrecoin to Alias
#
# AUTHOR:       HLXEasy
# PROJECT:      https://alias.cash/
#               https://github.com/aliascash/aliaswallet
#
# ============================================================================

versionToInstall=$1
installPath=/usr/local/bin

# ----------------------------------------------------------------------------
# Create backup of wallet.dat
if [[ -e ~/.spectrecoin/testnet/wallet.dat ]] ; then
    backupFile=$(date +%Y-%m-%d_%H-%M)-testnet-wallet.dat
    echo "Creating backup of testnet wallet.dat (${backupFile})"
    cp ~/.spectrecoin/testnet/wallet.dat ~/${backupFile}
    echo "    Done"
fi
if [[ -e ~/.spectrecoin/wallet.dat ]] ; then
    backupFile=$(date +%Y-%m-%d_%H-%M)-wallet.dat
    echo "Creating backup of wallet.dat (${backupFile})"
    cp ~/.spectrecoin/wallet.dat ~/${backupFile}
    echo "    Done"
fi

# ----------------------------------------------------------------------------
# Check disk space and and if at least the same amount as the data dir +10%
# is available, copy data directory from ~/.spectrecoin to ~/.aliaswallet.
# Otherwise ask if the folder should be renamed.
if [[ -d ~/.spectrecoin/ ]] ; then
    usedDiskSpace=$(du -s ~/.spectrecoin | awk '{print $1}')
    usedDiskSpaceWithBuffer=$(echo "scale = 0; ${usedDiskSpace} * 1.1 / 1" | bc -l)
    freeSpaceOnHomeDir=$(df ~ | tail -n 1 | awk '{print $4}')
    printf "Available disk space:                             %15s\n" ${freeSpaceOnHomeDir}
    printf "Used disk space for spectrecoin data:             %15s\n" ${usedDiskSpace}
    printf "Used disk space for spectrecoin data +10%% buffer: %15s\n" ${usedDiskSpaceWithBuffer}
    if [[ ${freeSpaceOnHomeDir} -gt ${usedDiskSpaceWithBuffer} ]] ; then
        echo "Copying data directory ~/.spectrecoin to ~/.aliaswallet"
        echo "Patience please..."
        cp -r ~/.spectrecoin ~/.aliaswallet
        echo "    Done"
    else
        echo
        echo "Not enough disk space to duplicate Spectrecoin data directory!"
        echo
        echo "Rename it instead of creating a copy [y/n]?"
        echo -n "Everything else than 'y' will cancel the update: "
        read input
        if [[ -n "${input}" && "${input}" = 'y' ]] ; then
            mv ~/.spectrecoin ~/.aliaswallet
        else
            echo "Update canceled"
            exit 1
        fi
        echo "    Done"
    fi
fi

# ----------------------------------------------------------------------------
# Rename configuration file
if [[ -e ~/.aliaswallet/spectrecoin.conf ]] ; then
    echo "Renaming configuration file spectrecoin.conf to alias.conf"
    mv ~/.aliaswallet/spectrecoin.conf ~/.aliaswallet/alias.conf
    echo "    Done"
fi
echo ""

# ----------------------------------------------------------------------------
# Remove spectrecoin binaries
if [[ -e ${installPath}/spectrecoind ]] ; then
    echo "Determining spectrecoind binary version"
    # Version is something like "v2.2.2.0 (86e9b92 - 2019-01-26 17:20:20 +0100)"
    # but only the version and the commit hash separated by "_" is used later on.
    # Option '-version' is working since v3.x
    queryResult=$(${installPath}/spectrecoind -version)
    currentVersion=$(echo ${queryResult/\(/} | cut -d ' ' -f 1)
    gitHash=$(echo ${queryResult/\(/} | cut -d ' ' -f 2)
    if [[ -n "${gitHash}" ]] ; then
        fullVersion=${currentVersion}-${gitHash}
    else
        fullVersion=${currentVersion}
    fi
    if [[ -z "${fullVersion}" ]] ; then
        fullVersion=$(date +%Y%m%d-%H%M)
        echo "    Unable to determine version of current binaries, using timestamp '${fullVersion}'"
    else
        echo "    Creating backup of current version ${fullVersion}"
    fi
    if [[ -f ${installPath}/spectrecoind-${fullVersion} ]] ; then
        echo "    Backup of current version already existing"
    else
        sudo mv ${installPath}/spectrecoind ${installPath}/spectrecoind-${fullVersion}
        if [[ -e ${installPath}/spectrecoin ]] ; then
            sudo mv ${installPath}/spectrecoin  ${installPath}/spectrecoin-${fullVersion}
        fi
        echo "    Done"
    fi
else
    echo "Binary ${installPath}/spectrecoind not found, skip backup creation"
fi
echo ""

# ----------------------------------------------------------------------------
# Rename and update service
sudo systemctl disable spectrecoind
sudo mv /lib/systemd/system/spectrecoind.service /lib/systemd/system/aliaswalletd.service
sudo sed -i \
    -e "s/Spectrecoin/Aliaswallet/g" \
    -e "s/spectrecoind/aliaswalletd/g" \
    /lib/systemd/system/aliaswalletd.service
sudo systemctl daemon-reload
sudo systemctl enable aliaswalletd

# ----------------------------------------------------------------------------
# Rename Shell-UI directory
if [[ -d ~/spectrecoin-sh-rpc-ui ]] ; then
    mv ~/spectrecoin-sh-rpc-ui ~/aliaswallet-sh-rpc-ui
    cd ~/aliaswallet-sh-rpc-ui
    git remote set-url origin https://github.com/aliascash/aliaswallet-sh-rpc-ui.git
    git pull
    cd - >/dev/null
fi

# ----------------------------------------------------------------------------
# Update alias definitions
sed -i \
    -e "s/spectrecoin/aliaswallet/g" \
    ~/.bash_aliases

# ----------------------------------------------------------------------------
# Use ca-certificates if available
if [[ -e /etc/ssl/certs/ca-certificates.crt ]] ; then
    cacertParam='--cacert /etc/ssl/certs/ca-certificates.crt'
fi

curl ${cacertParam} -L -s https://raw.githubusercontent.com/aliascash/installer/master/linux/updateAliaswallet.sh | sudo bash -s "${versionToInstall}"
