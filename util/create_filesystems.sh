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
main_partition_path=$2  # e.g. /dev/sda2


mkfs.fat -F32 $efi_partition_path
fatlabel $efi_partition_path "EFI"
mkfs.ext4 $main_partition_path
e2label $main_partition_path "ROOT"

echo "Created filesystems - OK"
