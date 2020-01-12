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


config_file_path = sys.argv[1]  # e.g. "/etc/archinstall/config.json"


def print_separator():
    print()
    print("#################################################################")
    print()


config = {}


# Disk selection

print_separator()
print("Please type in the 'NAME' of the hard disk on which you want to \ninstall Arch Linux:")
print()
subprocess.run("lsblk -o NAME,SIZE,TYPE | grep -v part", shell=True)
print()
config["disk"] = input(">>> ")


# Select hostname

print_separator()
print("Please type in the hostname of your new machine:")
print()
config["hostname"] = input(">>> ")


# Desktop or no desktop

print_separator()
print("Do you want to install a desktop? [Y/n]:")
print()
answer = input(">>> ")
if answer in ["", "Y", "y", "Yes", "yes"]:
    config["desktop"] = "yes"
else:
    config["desktop"] = "no"


# Admin account

print_separator()
print("Please select your username (like 'paul' or 'alice'):")
print()
config["admin_username"] = input(">>> ")


# System encryption

print_separator()
print("System encryption protects all your data if your device is stolen.")
print("A second password will be required at startup to decrypt the system.")
print("Do you want to encrypt your system? [Y/n]")
print()
answer = input(">>> ")
if answer in ["", "Y", "y", "Yes", "yes"]:
    config["system_encryption"] = "yes"
else:
    config["system_encryption"] = "no"


# Write config to json file

config_json = json.dumps(config, indent=4)
with open(config_file_path, 'w') as f:
    f.write(config_json)


# Output json config for logging purpose

print_separator()
print("Config for this installation:")
print()
print(config_json)
print_separator()

print("Wrote config - OK")
