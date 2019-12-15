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


admin_username=$1
default_password=$2


echo "root:$default_password" | chpasswd

useradd -m $admin_username
usermod -aG wheel $admin_username
echo "$admin_username:$default_password" | chpasswd

# passwd -l root  # lock the root account if changing /etc/sudoers is implemented

echo "Configured users - OK"
