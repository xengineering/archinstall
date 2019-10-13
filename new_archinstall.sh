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


# Static config

TESTSERVER="8.8.8.8"  # hostnames will not work properly
LOG_FILE_PATH="/var/log/archinstall.log"
REPOSITORY_URL="https://github.com/xengineering/archinstall/"
REPOSITORY_PATH="/opt/archinstall.git"
BRANCH_OR_COMMIT="master"
SCRIPT_BASE_PATH=$REPOSITORY_PATH
SCRIPT_BASE_PATH+="/bin/"
CONFIG_FILE_PATH="/etc/archinstall/config.json"
DELAY=0.5


# Initial message

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


# Create log and provide output function ...

touch $LOG_FILE_PATH
echo "" > $LOG_FILE_PATH
output () {
    echo $1 | tee -a $LOG_FILE_PATH
    echo "" | tee -a $LOG_FILE_PATH
    sleep $DELAY
}
output "Log created - OK"


output "Checking if booted with UEFI ..."

if [ -d "/sys/firmware/efi/efivars" ]; then
    output "Booted with UEFI - OK"
else
    output "Not booted with UEFI. Please enable it in your mainboard settings. - FAILED"
    exit
fi


output "Check internet connection ..."

if ping -w 3 -c 1 $TESTSERVER > /dev/null; then
    output "Internet connection is ready - OK"
else
    output "Could not reach testserver '$TESTSERVER' - FAILED"
    exit
fi


output "Update system clock ..."

timedatectl set-ntp true
if [ $? -eq 0 ]; then
    output "Updated system clock - OK"
else
    output "Could not update system clock - FAILED"
    exit
fi


output "Cloning git repository ..."

pacman --noconfirm -Sy git | tee -a $LOG_FILE_PATH
mkdir $REPOSITORY_PATH
git clone $REPOSITORY_URL $REPOSITORY_PATH | tee -a $LOG_FILE_PATH
cd $REPOSITORY_PATH && git checkout $BRANCH_OR_COMMIT | tee -a $LOG_FILE_PATH
cd
output "Git repository cloned - OK"


output "Generating config ..."

script_path=$SCRIPT_BASE_PATH
script_path+="config_writer.py"
python $script_path $LOG_FILE_PATH


# Generate new system ...


# Copy everything to new system

# log
# repo
# config


# Unmount new system
