execute_process(COMMAND "/home/robot/rieman_ws/build/biotac_driver/biotac_log_parser/catkin_generated/python_distutils_install.sh" RESULT_VARIABLE res)

if(NOT res EQUAL 0)
  message(FATAL_ERROR "execute_process(/home/robot/rieman_ws/build/biotac_driver/biotac_log_parser/catkin_generated/python_distutils_install.sh) returned error code ")
endif()
