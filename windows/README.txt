The Aliaswallet installer will perform the following tasks:
Ask what to install:
- Aliaswallet
- Bootstrap blockchain

For Aliaswallet:
- Ask which Tor configuration should be activated (default/OBFS4/Meek)
- Ask for the installation directory
- Check if Aliaswallet is already running and shut it down
- Check if Aliaswallet is already installed
- Ask to uninstall or cancel installation
- Install Aliaswallet
- Create Uninstaller
- Create Start-Menu entries

For the bootstrap blockchain:
- Check if Aliaswallet is already running and shut it down
- If wallet.dat is existing, create a backup named wallet.dat.<timestamp>
- Check if bootstrap archive is existing
- Yes: Ask if it should be used again or download a new archive
- Remove folder %appdata%/Aliaswallet/txleveldb
- Remove file %appdata%/Aliaswallet/blk0001.dat
- Unzip bootstrap archive

Thx for using Aliaswallet!
The Alias Team
