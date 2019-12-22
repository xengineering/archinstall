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


efi_partition_path=$1  # e.g. /dev/sda1
boot_partition_path=$2  # e.g. /dev/sda2
root_partition_path=$3  # e.g. /dev/sda3 or /dev/SystemVolumeGroup/root


mkfs.fat -F32 $efi_partition_path
fatlabel $efi_partition_path "EFI"
mkfs.ext4 $boot_partition_path
e2label $boot_partition_path "BOOT"
mkfs.ext4 $root_partition_path
e2label $root_partition_path "MAIN"

echo "Created filesystems - OK"
