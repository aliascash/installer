The Spectrecoin installer will perform the following tasks:
Ask what to install:
- Spectrecoin
- Bootstrap blockchain

For Spectrecoin:
- Ask which Tor configuration should be activated (default/OBFS4/Meek)
- Ask for the installation directory
- Check if Spectrecoin is already running and shut it down
- Check if Spectrecoin is already installed
- Ask to uninstall or cancel installation
- Install Spectrecoin
- Create Uninstaller
- Create Start-Menu entries

For the bootstrap blockchain:
- Check if Spectrecoin is already running and shut it down
- If wallet.dat is existing, create a backup named wallet.dat.<timestamp>
- Check if bootstrap archive is existing
- Yes: Ask if it should be used again or download a new archive
- Remove folder %appdata%/Spectrecoin/txleveldb
- Remove file %appdata%/Spectrecoin/blk0001.dat
- Unzip bootstrap archive

Thx for using Spectrecoin!
The Spectrecoin Team
