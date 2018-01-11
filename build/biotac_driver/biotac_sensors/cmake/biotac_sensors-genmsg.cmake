# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "biotac_sensors: 3 messages, 0 services")

set(MSG_I_FLAGS "-Ibiotac_sensors:/home/robot/rieman_ws/src/biotac_driver/biotac_sensors/msg;-Istd_msgs:/opt/ros/hydro/share/std_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(genlisp REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(biotac_sensors_generate_messages ALL)

#
#  langs = gencpp;genlisp;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(biotac_sensors
  "/home/robot/rieman_ws/src/biotac_driver/biotac_sensors/msg/BioTacTime.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/biotac_sensors
)
_generate_msg_cpp(biotac_sensors
  "/home/robot/rieman_ws/src/biotac_driver/biotac_sensors/msg/BioTacHand.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/hydro/share/std_msgs/cmake/../msg/Header.msg;/home/robot/rieman_ws/src/biotac_driver/biotac_sensors/msg/BioTacTime.msg;/home/robot/rieman_ws/src/biotac_driver/biotac_sensors/msg/BioTacData.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/biotac_sensors
)
_generate_msg_cpp(biotac_sensors
  "/home/robot/rieman_ws/src/biotac_driver/biotac_sensors/msg/BioTacData.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/biotac_sensors
)

### Generating Services

### Generating Module File
_generate_module_cpp(biotac_sensors
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/biotac_sensors
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(biotac_sensors_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(biotac_sensors_generate_messages biotac_sensors_generate_messages_cpp)

# target for backward compatibility
add_custom_target(biotac_sensors_gencpp)
add_dependencies(biotac_sensors_gencpp biotac_sensors_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS biotac_sensors_generate_messages_cpp)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(biotac_sensors
  "/home/robot/rieman_ws/src/biotac_driver/biotac_sensors/msg/BioTacTime.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/biotac_sensors
)
_generate_msg_lisp(biotac_sensors
  "/home/robot/rieman_ws/src/biotac_driver/biotac_sensors/msg/BioTacHand.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/hydro/share/std_msgs/cmake/../msg/Header.msg;/home/robot/rieman_ws/src/biotac_driver/biotac_sensors/msg/BioTacTime.msg;/home/robot/rieman_ws/src/biotac_driver/biotac_sensors/msg/BioTacData.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/biotac_sensors
)
_generate_msg_lisp(biotac_sensors
  "/home/robot/rieman_ws/src/biotac_driver/biotac_sensors/msg/BioTacData.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/biotac_sensors
)

### Generating Services

### Generating Module File
_generate_module_lisp(biotac_sensors
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/biotac_sensors
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(biotac_sensors_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(biotac_sensors_generate_messages biotac_sensors_generate_messages_lisp)

# target for backward compatibility
add_custom_target(biotac_sensors_genlisp)
add_dependencies(biotac_sensors_genlisp biotac_sensors_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS biotac_sensors_generate_messages_lisp)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(biotac_sensors
  "/home/robot/rieman_ws/src/biotac_driver/biotac_sensors/msg/BioTacTime.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/biotac_sensors
)
_generate_msg_py(biotac_sensors
  "/home/robot/rieman_ws/src/biotac_driver/biotac_sensors/msg/BioTacHand.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/hydro/share/std_msgs/cmake/../msg/Header.msg;/home/robot/rieman_ws/src/biotac_driver/biotac_sensors/msg/BioTacTime.msg;/home/robot/rieman_ws/src/biotac_driver/biotac_sensors/msg/BioTacData.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/biotac_sensors
)
_generate_msg_py(biotac_sensors
  "/home/robot/rieman_ws/src/biotac_driver/biotac_sensors/msg/BioTacData.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/biotac_sensors
)

### Generating Services

### Generating Module File
_generate_module_py(biotac_sensors
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/biotac_sensors
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(biotac_sensors_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(biotac_sensors_generate_messages biotac_sensors_generate_messages_py)

# target for backward compatibility
add_custom_target(biotac_sensors_genpy)
add_dependencies(biotac_sensors_genpy biotac_sensors_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS biotac_sensors_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/biotac_sensors)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/biotac_sensors
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
add_dependencies(biotac_sensors_generate_messages_cpp std_msgs_generate_messages_cpp)

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/biotac_sensors)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/biotac_sensors
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
add_dependencies(biotac_sensors_generate_messages_lisp std_msgs_generate_messages_lisp)

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/biotac_sensors)
  install(CODE "execute_process(COMMAND \"/usr/bin/python\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/biotac_sensors\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/biotac_sensors
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
add_dependencies(biotac_sensors_generate_messages_py std_msgs_generate_messages_py)
