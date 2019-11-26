#!/bin/bash


#  archinstall - A minimal Installation Script for Arch Linux
#  Copyright (C) 2019  xengineering

#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.

#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.

#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.


########################
#  install_desktop.sh  #
########################


pacman --no-confirm -Syu
pacman --noconfirm -S xorg-server xorg-xinit xorg-utils xorg-server-utils xorg-drivers
pacman --noconfirm -S xfce4 lightdm lightdm-gtk-greeter
systemctl enable lightdm
localectl --no-convert set-x11-keymap de pc105 nodeadkeys  # does not work. Please fix!
