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


#################################################################
#                  _                 _        _ _       _       #
#    __ _ _ __ ___| |__ (_)_ __  ___| |_ __ _| | |  ___| |__    #
#   / _` | '__/ __| '_ \| | '_ \/ __| __/ _` | | | / __| '_ \   #
#  | (_| | | | (__| | | | | | | \__ \ || (_| | | |_\__ \ | | |  #
#   \__,_|_|  \___|_| |_|_|_| |_|___/\__\__,_|_|_(_)___/_| |_|  #
#                                                               #
#################################################################


# Stop at any error to optimize debugging:

set -e


# Greetings

cat << EOF

#################################################################
#                                                               #
#                Arch Linux Installation Script                 #
#                                                               #
# archinstall  Copyright (C) 2019  xengineering                 #
# This program comes with ABSOLUTELY NO WARRANTY.               #
# This is free software, and you are welcome to redistribute it #
# under certain conditions. See                                 #
# <https://www.gnu.org/licenses/gpl-3.0.en.html> for details.   #
#                                                               #
#################################################################

EOF


# Constants

export BRANCH="master"  # possible alternatives: "devel" or "feature_<myfeature>"
export INTERNET_TEST_SERVER="archlinux.org"
export INTERNET_TEST_PING_TIMEOUT=1  # seconds
export FIRST_STAGE_LINK=""
export SECOND_STAGE_LINK=""
export PACKAGE_LIST="base linux linux-firmware nano networkmanager"
export DEFAULT_PASSWORD="archinstall"


# Variables

export boot_mode="unknown"  # alternatives: "bios" or "uefi"
export luks_encryption="unknown"  # alternatives: "yes" or "no"
export path_to_timezone="/usr/share/zoneinfo/Europe/Berlin"
export locales_to_generate="de_DE.UTF-8 UTF-8;de_DE ISO-8859-1;de_DE@euro ISO-8859-15"
export keymap="de-latin1"
export hostname="archlinux"  # will be set to a user-chosen hostname


# Download and run first stage

curl https://raw.githubusercontent.com/xengineering/archinstall/$BRANCH/stages/first_stage.sh > /root/first_stage.sh
bash /root/first_stage.sh
