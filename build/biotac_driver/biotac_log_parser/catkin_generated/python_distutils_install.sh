#!/bin/sh -x

if [ -n "$DESTDIR" ] ; then
    case $DESTDIR in
        /*) # ok
            ;;
        *)
            /bin/echo "DESTDIR argument must be absolute... "
            /bin/echo "otherwise python's distutils will bork things."
            exit 1
    esac
    DESTDIR_ARG="--root=$DESTDIR"
fi

cd "/home/robot/rieman_ws/src/biotac_driver/biotac_log_parser"

# Note that PYTHONPATH is pulled from the environment to support installing
# into one location when some dependencies were installed in another
# location, #123.
/usr/bin/env \
    PYTHONPATH="/home/robot/rieman_ws/install/lib/python2.7/dist-packages:/home/robot/rieman_ws/build/lib/python2.7/dist-packages:$PYTHONPATH" \
    CATKIN_BINARY_DIR="/home/robot/rieman_ws/build" \
    "/usr/bin/python" \
    "/home/robot/rieman_ws/src/biotac_driver/biotac_log_parser/setup.py" \
    build --build-base "/home/robot/rieman_ws/build/biotac_driver/biotac_log_parser" \
    install \
    $DESTDIR_ARG \
    --install-layout=deb --prefix="/home/robot/rieman_ws/install" --install-scripts="/home/robot/rieman_ws/install/bin"
