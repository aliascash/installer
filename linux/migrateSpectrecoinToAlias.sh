#!/usr/bin/env bash
# ============================================================================
#
# FILE:         migrateSpectrecoinToAlias.sh
#
# SPDX-FileCopyrightText: © 2020 Alias Developers
# SPDX-FileCopyrightText: © 2016 SpectreCoin Developers
# SPDX-License-Identifier: MIT
#
# DESCRIPTION:  Helper script to migrate from Spectrecoin to Alias
#
# AUTHOR:       HLXEasy
# PROJECT:      https://alias.cash/
#               https://github.com/aliascash/alias-wallet
#
# ============================================================================

versionToInstall=$1
installPath=/usr/local/bin

# Debug output
#set -ex

# ----------------------------------------------------------------------------
# Remove spectrecoin binaries
if [[ -e ${installPath}/spectrecoind ]] ; then
    echo "Determining current spectrecoind binary version"
    # Version is something like "v2.2.2.0 (86e9b92 - 2019-01-26 17:20:20 +0100)"
    # but only the version and the commit hash separated by "_" is used later on.
    # Option '-version' is working since v3.x
    queryResult=$(${installPath}/spectrecoind -version || true)
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
# Create backup of wallet.dat
if [[ -e ~/.spectrecoin/testnet/wallet.dat ]] ; then
    backupFile=$(date +%Y-%m-%d_%H-%M)-testnet-wallet.dat
    echo "Creating backup of testnet wallet.dat (~/${backupFile})"
    cp ~/.spectrecoin/testnet/wallet.dat ~/${backupFile}
    echo "    Done"
fi
if [[ -e ~/.spectrecoin/wallet.dat ]] ; then
    backupFile=$(date +%Y-%m-%d_%H-%M)-wallet.dat
    echo "Creating backup of wallet.dat (~/${backupFile})"
    cp ~/.spectrecoin/wallet.dat ~/${backupFile}
    echo "    Done"
fi

# ----------------------------------------------------------------------------
# Rename data folder
if [[ -d ~/.spectrecoin/ ]] ; then
    echo "Renaming data directory ~/.spectrecoin to ~/.aliaswallet"
    mv ~/.spectrecoin ~/.aliaswallet
    echo "    Done"
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
# Rename and update service
if [[ -e /lib/systemd/system/spectrecoind.service ]] ; then
    echo "Renaming spectrecoind service to aliaswallet"
    sudo systemctl disable spectrecoind
    sudo mv /lib/systemd/system/spectrecoind.service /lib/systemd/system/aliaswalletd.service
    sudo sed -i \
        -e "s/Spectrecoin/Alias wallet/g" \
        -e "s/spectrecoind/aliaswalletd/g" \
        /lib/systemd/system/aliaswalletd.service

    # Fix potential wrong binary reference
    sudo sed -i \
        -e "s#/usr/bin/aliaswalletd#/usr/local/bin/aliaswalletd#g" \
        /lib/systemd/system/aliaswalletd.service

    sudo systemctl daemon-reload
    sudo systemctl enable aliaswalletd
    echo "    Done"
fi

# ----------------------------------------------------------------------------
# Rename Shell-UI directory
if [[ -d ~/spectrecoin-sh-rpc-ui ]] ; then
    echo "Renaming Shell-UI directory and update Github reference"
    mv ~/spectrecoin-sh-rpc-ui ~/alias-sh-rpc-ui
    cd ~/alias-sh-rpc-ui || exit
    git remote set-url origin https://github.com/aliascash/alias-sh-rpc-ui.git
    git pull
    cd - >/dev/null || exit
    echo "    Done"
fi

# ----------------------------------------------------------------------------
# Update alias definitions
if [[ -e ~/.bash_aliases ]] ; then
    echo "Updating possible alias definitions on ~/.bash_aliases"
    sed -i \
        -e "s/spectrecoin-sh-rpc-ui/alias-sh-rpc-ui/g" \
        -e "s/spectrecoin/aliaswallet/g" \
        ~/.bash_aliases
fi
if [[ -e ~/.zshrc ]] ; then
    echo "Updating possible alias definitions on ~/.zshrc"
    sed -i \
        -e "s/spectrecoin-sh-rpc-ui/alias-sh-rpc-ui/g" \
        -e "s/spectrecoin/aliaswallet/g" \
        ~/.zshrc
fi

# ----------------------------------------------------------------------------
# Use ca-certificates if available
if [[ -e /etc/ssl/certs/ca-certificates.crt ]] ; then
    cacertParam='--cacert /etc/ssl/certs/ca-certificates.crt'
fi

curl ${cacertParam} -L -s https://raw.githubusercontent.com/aliascash/installer/master/linux/updateAliaswallet.sh | sudo bash -s "${versionToInstall}"

echo
echo "The Alias wallet is not running. You can restart the Shell-UI now,"
echo "which also starts the wallet daemon."
echo

kill -INT $$
