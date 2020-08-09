The Alias wallet installer will perform the following tasks:
Ask what to install:
- Alias wallet
- Bootstrap blockchain

For Alias wallet:
- Ask which Tor configuration should be activated (default/OBFS4/Meek)
- Ask for the installation directory
- Check if wallet is already running and shut it down
- Check if wallet is already installed
- Ask to uninstall or cancel installation
- Install Alias wallet
- Create Uninstaller
- Create Start menu entries

For the bootstrap blockchain:
- Check if wallet is already running and shut it down
- If wallet.dat is existing, create a backup named wallet.dat.<timestamp>
- Check if bootstrap archive is existing
- Yes: Ask if it should be used again or download a new archive
- Remove folder %appdata%/Aliaswallet/txleveldb
- Remove file %appdata%/Aliaswallet/blk0001.dat
- Unzip bootstrap archive

Thx for using Alias wallet!
The Alias Team
