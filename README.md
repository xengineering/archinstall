
# archinstall

This repository is intended to provide an installation script for Arch Linux so that it can be used during the installation process.

Note: There are many Arch Install scripts out there but I wanted to create my own for an educational purpose. So it's mainly a personal repository, but if you like the script or want to contribute, you're welcome to use it.

## Usage

Advice 1: The archinstall.sh script supports currently just UEFI systems, german localization and installation via cable connection instead of WiFi.

Advice 2: Execute 'loadkeys de-latin1' after booting to live environment, if you want to set a german keyboard layout. You have to type 'z' for 'y' in loadkeys and 'ß' for the '-' sign.

1. Download the Arch Linux .iso file and verify it.
2. Write the .iso to a USB stick and boot the machine from this USB stick in UEFI mode.
3. Download the script with 'curl https://raw.githubusercontent.com/xengineering/archinstall/master/archinstall.sh > archinstall.sh'.
4. Run the script with 'bash archinstall.sh' and follow the instructions.


## To Do

- [ ] Provide LUKS encryption
- [ ] Provide post-installation script for common settings (DHCP, users, etc.)
- [ ] Support installation with WiFi (instead of cable connection)
- [ ] Modify mirrorlist
- [ ] Support english localization
- [ ] Add also localization for desktop systems
- [ ] Check the result of every command for better security
- [ ] Provide error log
- [x] Automatic partitioning
- [x] Write first version of archinstall.sh

