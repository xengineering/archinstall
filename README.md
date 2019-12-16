

# archinstall

This repository is intended to provide an installation script for Arch Linux so that it can be used during the installation process.

Note: There are many Arch Install scripts out there but I wanted to create my own for an educational purpose. So it's mainly a personal repository, but if you like the script or want to contribute, you're welcome to use it.


## Usage

1. Download the Arch Linux .iso file (maybe [here](http://ftp.halifax.rwth-aachen.de/archlinux/iso/latest/)) and verify it.
2. Write the .iso to a USB stick and boot the machine from this USB stick in UEFI mode.
3. Download the script with 'curl -L archinstall.xengineering.eu > archinstall.sh'.
4. Run the script with 'bash archinstall.sh' and follow the instructions.


## Restrictions

- Just UEFI systems
- Just german localization of the installed system
- Just installation with cable network connection (no WiFi)


## Hint for German Users

Execute 'loadkeys de-latin1' after booting to live environment, if you want to set a german keyboard layout. You have to type 'z' for 'y' in loadkeys and 'ß' for the '-' sign.


## To Do

- [ ] Create a main user with sudo permissions
- [ ] Provide LUKS encryption
- [ ] Support installation with WiFi (instead of cable connection)
- [ ] Provide recommended package lists
- [ ] Modify mirrorlist
- [ ] Automatic abort in case of errors
- [ ] Support BIOS systems
- [ ] Support english localization
- [ ] Packaged for the AUR
- [x] Provide installation of a desktop environment
- [x] Provide reusable configuration file (json)
- [x] Provide error log
- [x] Automatic partitioning
- [x] Write first version of archinstall.sh
