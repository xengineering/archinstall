#!/usr/bin/env python


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


import sys
import json
import subprocess


config_file_path = sys.argv[1]


config = {}


# Disk selection

print("Please type in the 'NAME' of the hard disk on which you want to install Arch Linux:")
subprocess.run("lsblk -o NAME,SIZE,TYPE | grep -v part", shell=True)
config["disk"] = input()


# Select hostname

print("Please type in the hostname of your new machine:")
config["hostname"] = input()


# Desktop or no Desktop

print("Do you want to install a desktop? [Y/n]:")
answer = input()
if answer in ["", "Y", "y", "Yes", "yes"]:
    config["desktop"] = "yes"
else:
    config["desktop"] = "no"


# Write config to json file

config_json = json.dumps(config, indent=4)
with open(config_file_path, 'w') as f:
    f.write(config_json)


# Output json config for logging purpose

print("Config for this installation:")
print(config_json)
