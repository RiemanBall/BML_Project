#!/usr/bin/env python
# creates a relay to a python script source file, acting as that file.
# The purpose is that of a symlink
with open("/home/robot/rieman_ws/src/biotac_driver/biotac_log_parser/scripts/parse_log_json.py", 'r') as fh:
    exec(fh.read())
