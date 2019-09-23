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


#####################
#  localization.sh  #
#####################


# Set timezone

ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
echo "Timezone set - OK"
echo ""
sleep 1


# Localization - Greetings from Germany

echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
echo "de_DE ISO-8859-1" >> /etc/locale.gen
echo "de_DE@euro ISO-8859-15" >> /etc/locale.gen

locale-gen

touch /etc/locale.conf
echo "LANG=de_DE.UTF-8" > /etc/locale.conf

touch /etc/vconsole.conf
echo "KEYMAP=de-latin1" > /etc/vconsole.conf

# this just works after installing a desktop environment (e.g. xorg and xfce4 package)
# localectl --no-convert set-x11-keymap de pc105 nodeadkeys  # desktop keyboard layout

echo "German localization done - OK"
echo ""
sleep 1
