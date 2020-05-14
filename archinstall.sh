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


# stop at any error to optimize debugging:

set -e


##############################################################################

                                ############
                                # Settings #
                                ############

# Modify each entry to your needs. Leave every unknown entry as it is.
# But make sure to EDIT 'path_to_disk'! Run "lsblk" if you are unsure, which
# is the right one for your machine.

export path_to_disk="/dev/null"  # where should Arch Linux be installed (e.g. "/dev/sda")
export hostname="archlinux"  # select the hostname for your installation
export pacman_mirror_region="DE"  # select "all" for all regions 
export luks_encryption="no"  # "yes" for full disk encryption, "no" for normal installation
export path_to_timezone="/usr/share/zoneinfo/Europe/Berlin"  # choose your timezone
export locales_to_generate="de_DE.UTF-8 UTF-8"  # currently just one option is allowed
export language="de_DE.UTF-8"
export keymap="de-latin1"  # the keyboard layout for the installation

##############################################################################


# constants

export BRANCH="master"  # possible alternatives: "devel" or "feature_<myfeature>"
export INTERNET_TEST_SERVER="archlinux.org"
export INTERNET_TEST_PING_TIMEOUT=1  # in seconds
export FIRST_STAGE_LINK="https://raw.githubusercontent.com/xengineering/archinstall/$BRANCH/stages/first_stage.sh"
export SECOND_STAGE_LINK="https://raw.githubusercontent.com/xengineering/archinstall/$BRANCH/stages/second_stage.sh"
export PACKAGE_LIST="base linux linux-firmware grub networkmanager nano git base-devel"
export DEFAULT_PASSWORD="archinstall"


# functions

function print_ok () {
    # ref. https://en.wikipedia.org/wiki/ANSI_escape_code
    printf "\033[m[ \033[32mOK\033[m ] $1\n"
}
export -f print_ok

function print_failed () {
    # ref. https://en.wikipedia.org/wiki/ANSI_escape_code
    printf "\033[m[ \033[31mFAILED\033[m ] $1\n"
    exit 1
}
export -f print_failed


# greetings

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


# check bootmode

print_ok "Checking bootmode ..."
if [ -d "/sys/firmware/efi/efivars" ]; then
    export boot_mode="uefi"
    print_ok "Booted with UEFI"
else
    export boot_mode="bios"
    print_ok "Booted with legacy boot / BIOS"
fi


# check internet connection

if ping -w $INTERNET_TEST_PING_TIMEOUT -c 1 $INTERNET_TEST_SERVER; then
    print_ok "Internet connection is ready"
else
    print_failed "Could not reach INTERNET_TEST_SERVER '$INTERNET_TEST_SERVER'"
fi


# update the system clock

timedatectl set-ntp true
print_ok "Updated system clock"


# download and run first stage

print_ok "Downloading and launching first_stage.sh ..."
curl $FIRST_STAGE_LINK > /root/first_stage.sh
bash /root/first_stage.sh
print_ok "first_stage.sh finished"


# download, run and delete second stage

print_ok "Downloading and launching second_stage.sh in chroot environment ..."
curl $SECOND_STAGE_LINK > /mnt/root/second_stage.sh
echo "bash /root/second_stage.sh" | arch-chroot /mnt
rm /mnt/root/second_stage.sh
print_ok "second_stage.sh finished and deleted"
