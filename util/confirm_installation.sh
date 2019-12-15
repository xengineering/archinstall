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


disk=$1  # e.g. sda


echo "All data on disk '$disk' will be finally lost!"
echo "Are you SURE that you want to install Arch Linux to '$disk'?!"
echo "Type 'Yes' for installation and 'No' for abort."
read answer
if [ $answer == "Yes" ]; then
    echo ""
    echo "Confirmed installation - OK"
    echo ""
else
    echo ""
    echo "Abort of installation process!"
    exit
fi
