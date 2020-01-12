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


disk_path=$1  # e.g. /dev/sda
boot_mode=$2  # "UEFI" or "BIOS"


if [ "$boot_mode" == "UEFI" ]; then
    wipefs -a $disk_path  # make sure that fdisk does not ask for removing
                          # signatures which breaks the script
    fdisk $disk_path << EOF
g
n
1

+512M
n
2

+200M
n
3


p
w
EOF

    echo "Partitioned disk for UEFI/GPT- OK"
elif [ "$boot_mode" == "BIOS" ]; then
    wipefs -a $disk_path  # make sure that fdisk does not ask for removing
                          # signatures which breaks the script
    fdisk $disk_path << EOF
o
n
p
1


p
w
EOF

    echo "Partitioned disk for BIOS/MBR - OK"
else

fi
