#!/usr/bin/env python
# creates a relay to a python script source file, acting as that file.
# The purpose is that of a symlink
with open("/home/robot/rieman_ws/src/biotac_driver/biotac_logger/scripts/biotac_json_logger.py", 'r') as fh:
    exec(fh.read())
