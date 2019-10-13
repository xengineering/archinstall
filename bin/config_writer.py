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


######################
#  config_writer.py  #
######################


import sys
import json


log_file_path = sys.argv[1]
config_file_path = sys.argv[2]


def output(text):
    print(text)
    with open(log_file_path, 'a') as f:
        f.write(text)
        f.write("")


config = {}


config["test"] = "testing"
config["test2"] = 2

config_json = json.dumps(config)
output(config_json)
