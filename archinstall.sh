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


# Settings

TESTSERVER="8.8.8.8"  # hostnames will not work properly
NETWORK_DEADLINE=1  # in seconds
REPOSITORY_URL="https://github.com/xengineering/archinstall/"
REPOSITORY_PATH="/opt/archinstall"
BRANCH_OR_COMMIT="master"  # select another branch name or commit hash if needed
LOG_FILE_PATH="/var/log/archinstall.log"
CONFIG_FILE_PATH="/etc/archinstall/config.json"
DELAY=0.5  # delay for reading messages in seconds


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


# Check internet connection

if ping -w $NETWORK_DEADLINE -c 1 $TESTSERVER; then
    echo "Internet connection is ready - OK"
    echo ""
    sleep $DELAY
else
    echo "Could not reach testserver '$TESTSERVER' - FAILED"
    exit
fi


# Update the system clock

timedatectl set-ntp true
if [ $? -eq 0 ]; then
    echo "Updated system clock - OK"
    echo ""
    sleep $DELAY
else
    echo "Could not update system clock - FAILED"
    exit
fi


# Cloning Git repository

echo "Cloning git repository ..."
echo ""
sleep $DELAY

pacman --noconfirm -Sy git
mkdir $REPOSITORY_PATH
git clone $REPOSITORY_URL $REPOSITORY_PATH
cd $REPOSITORY_PATH
git checkout $BRANCH_OR_COMMIT
cd

echo "Git repository cloned - OK"
echo ""
sleep $DELAY


# Launching first stage

bash $REPOSITORY_PATH/stages/first_stage.sh \
$DELAY $REPOSITORY_PATH $LOG_FILE_PATH $CONFIG_FILE_PATH | tee -a $LOG_FILE_PATH
