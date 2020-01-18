

# archinstall

This repository is intended to provide an installation script for Arch Linux so that it can be used during the installation process.

Note: There are many Arch Install scripts out there but I wanted to create my own for an educational purpose. So it's mainly a personal repository, but if you like the script or want to contribute, you're welcome to use it.


## Usage

1. Download the Arch Linux .iso file (maybe [here](http://ftp.halifax.rwth-aachen.de/archlinux/iso/latest/)) and verify it.
2. Write the .iso to an USB stick (maybe with this [tool](https://www.balena.io/etcher/)) and boot the machine from this USB stick.
3. Download the script with 'curl -L archinstall.xengineering.eu > archinstall.sh'.
4. Run the script with 'bash archinstall.sh' and follow the instructions.


### Hint for German Users

Execute 'loadkeys de-latin1' after booting to live environment, if you want to set a german keyboard layout. You have to type 'z' for 'y' in loadkeys and 'ß' for the '-' sign.


### Usage with VirtualBox

1. Create a VirtualBox virtual machine (VM) for 64-bit Arch Linux with the default or customized settings.
2. Start the VM and provide the .iso file if you are asked to.
3. You booted the Arch Linux live environment in VirtualBox. Proceed with the normal use of archinstall.


## Restrictions

- Just german localization of the installed system
- Just installation with cable network connection (no WiFi)


## To Do

(Highest priority first)

- [ ] Support BIOS systems
- [ ] Automatic abort in case of errors
- [ ] Optimize mirrorlist
- [ ] Support installation with WiFi (instead of cable connection)
- [ ] Provide recommended package lists
- [ ] Set a beautiful theme
- [ ] Support english localization
- [ ] Create swap partition
- [ ] Enable suspension to disk
- [ ] Use LVM
- [ ] Package for the AUR
- [ ] Provide a custom boot stick for archinstall
- [ ] Provide automated testing
- [ ] Provide automated system maintenance


## Done

(Last finished task first)

- [x] Provide full system encryption with LUKS
- [x] Create a main user with sudo permissions
- [x] Provide installation of a desktop environment
- [x] Provide reusable configuration file (json)
- [x] Provide error log
- [x] Automatic partitioning
- [x] Write first version of archinstall.sh
