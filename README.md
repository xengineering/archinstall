

# archinstall

This repository is intended to provide an installation script for Arch Linux so that it can be used during the installation process.

Note: There are many Arch Install scripts out there but I wanted to create my own for an educational purpose. So it's mainly a personal repository, but if you like the script or want to contribute, you're welcome to use it.


## Usage

1. Download the Arch Linux .iso file (maybe [here](http://ftp.halifax.rwth-aachen.de/archlinux/iso/latest/)) and verify it.
2. Write the .iso to an USB stick (maybe with this [tool](https://www.balena.io/etcher/)) and boot the machine from this USB stick.
3. Download the script with 'curl -L archinstall.xengineering.eu > archinstall.sh'.
4. Edit the 'settings' section with 'nano archinstall.sh' and leave the nano editor.
5. Run the script with 'bash archinstall.sh'.


### Hint for German Users

Execute 'loadkeys de-latin1' after booting to live environment, if you want to set a german keyboard layout. You have to type 'z' for 'y' in loadkeys and 'ß' for the '-' sign.


### Usage with VirtualBox

1. Create a VirtualBox virtual machine (VM) for 64-bit Arch Linux with the default or customized settings.
2. Start the VM and provide the .iso file if you are asked to.
3. You booted the Arch Linux live environment in VirtualBox. Proceed with the normal use of archinstall.


## To Do

(Highest priority first)

- [ ] Optimize mirrorlist
- [ ] Launch archconfig project for post-installation tasks like desktop, user setup, etc.
- [ ] Support installation with WiFi (instead of cable connection)
- [ ] Automate testing
- [ ] Implement 'guided_archinstall.py' for better usability


## Done

(Last finished task first)

- [x] Support coloured output
- [x] Support UEFI and BIOS systems
- [x] Automatic abort in case of errors
- [x] Provide full system encryption with LUKS
- [x] Automatic partitioning
- [x] Write first version of archinstall.sh
