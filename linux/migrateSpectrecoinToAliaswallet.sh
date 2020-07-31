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
# Check disk space and and if at least the same amount +10% used by the data
# dir is available, copy data directory from ~/.spectrecoin to ~/.aliaswallet
if [[ -d ~/.spectrecoin/ ]] ; then
    usedDiskSpace=$(du -s ~/.spectrecoin | awk '{print $1}')
    usedDiskSpaceWithBuffer=$(echo "${usedDiskSpace} * 1.1" | bc -l)
    freeSpaceOnHomeDir=$(df ~ | tail -n 1 | awk '{print $4}')
    printf "Free disk space:                                      %15s\n" ${freeSpaceOnHomeDir}
    printf "Used disk space for spectrecoin data:                 %15s\n" ${usedDiskSpace}
    printf "Used disk space for spectrecoin data with 10%% buffer: %15s\n" ${usedDiskSpaceWithBuffer}
    if [[ ${freeSpaceOnHomeDir} -gt ${usedDiskSpaceWithBuffer} ]] ; then
        echo "Renaming data directory ~/.spectrecoin to ~/.aliaswallet"
        echo "Patience please..."
        cp -r ~/.spectrecoin ~/.aliaswallet
        echo "    Done"
    else
        echo
        echo "Not enough disk space to duplicate Spectrecoin data directory!"
        echo
        echo -n "Rename it instead of creating a copy [y/n]? "
        read input
        if [[ "${input}" = 'y' ]] ; then
            mv ~/.spectrecoin ~/.aliaswallet
        else
            exit 1
        fi
        echo "    Done"
    fi
fi
if [[ -e ~/.aliaswallet/spectrecoin.conf ]] ; then
    echo "Renaming configuration file spectrecoin.conf to aliaswallet.conf"
    mv ~/.aliaswallet/spectrecoin.conf ~/.aliaswallet/aliaswallet.conf
    echo "    Done"
fi
echo ""

# ----------------------------------------------------------------------------
# Use ca-certificates if available
if [[ -e /etc/ssl/certs/ca-certificates.crt ]] ; then
    cacertParam='--cacert /etc/ssl/certs/ca-certificates.crt'
fi

curl ${cacertParam} -L -s https://raw.githubusercontent.com/aliascash/installer/master/linux/updateAliaswallet.sh | sudo bash -s "${versionToInstall}"
