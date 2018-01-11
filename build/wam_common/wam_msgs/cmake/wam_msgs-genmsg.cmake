# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "wam_msgs: 10 messages, 17 services")

set(MSG_I_FLAGS "-Iwam_msgs:/home/robot/rieman_ws/src/wam_common/wam_msgs/msg;-Igeometry_msgs:/opt/ros/hydro/share/geometry_msgs/cmake/../msg;-Isensor_msgs:/opt/ros/hydro/share/sensor_msgs/cmake/../msg;-Istd_msgs:/opt/ros/hydro/share/std_msgs/cmake/../msg;-Itrajectory_msgs:/opt/ros/hydro/share/trajectory_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(genlisp REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(wam_msgs_generate_messages ALL)

#
#  langs = gencpp;genlisp;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTOrtnVel.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_msg_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTOrtnPos.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_msg_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTJointVel.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_msg_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTJointTq.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_msg_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/EndpointState.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/hydro/share/geometry_msgs/cmake/../msg/Quaternion.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_msg_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTPose.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_msg_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTPosMode.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_msg_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTCartVel.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_msg_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTJointPos.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_msg_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTCartPos.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)

### Generating Services
_generate_srv_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/CartPosMove.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_srv_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/LASERControl.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/hydro/share/std_msgs/cmake/../msg/Bool.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_srv_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandGraspVel.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_srv_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/LEDControl.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/hydro/share/std_msgs/cmake/../msg/Bool.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_srv_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandSpreadPos.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_srv_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/JointTrajectoryVelocityMove.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/hydro/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/hydro/share/trajectory_msgs/cmake/../msg/JointTrajectory.msg;/opt/ros/hydro/share/trajectory_msgs/cmake/../msg/JointTrajectoryPoint.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_srv_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandGraspPos.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_srv_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/SpecialService.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_srv_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/LoggerInfo.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_srv_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandSpreadVel.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_srv_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandFingerPos.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_srv_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandFingerVel.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_srv_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/PoseMove.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/hydro/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/hydro/share/geometry_msgs/cmake/../msg/Pose.msg;/opt/ros/hydro/share/geometry_msgs/cmake/../msg/Quaternion.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_srv_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/GravityComp.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_srv_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/JointMove.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_srv_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/Hold.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)
_generate_srv_cpp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/OrtnMove.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
)

### Generating Module File
_generate_module_cpp(wam_msgs
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(wam_msgs_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(wam_msgs_generate_messages wam_msgs_generate_messages_cpp)

# target for backward compatibility
add_custom_target(wam_msgs_gencpp)
add_dependencies(wam_msgs_gencpp wam_msgs_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS wam_msgs_generate_messages_cpp)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTOrtnVel.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_msg_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTOrtnPos.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_msg_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTJointVel.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_msg_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTJointTq.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_msg_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/EndpointState.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/hydro/share/geometry_msgs/cmake/../msg/Quaternion.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_msg_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTPose.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_msg_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTPosMode.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_msg_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTCartVel.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_msg_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTJointPos.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_msg_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTCartPos.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)

### Generating Services
_generate_srv_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/CartPosMove.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_srv_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/LASERControl.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/hydro/share/std_msgs/cmake/../msg/Bool.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_srv_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandGraspVel.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_srv_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/LEDControl.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/hydro/share/std_msgs/cmake/../msg/Bool.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_srv_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandSpreadPos.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_srv_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/JointTrajectoryVelocityMove.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/hydro/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/hydro/share/trajectory_msgs/cmake/../msg/JointTrajectory.msg;/opt/ros/hydro/share/trajectory_msgs/cmake/../msg/JointTrajectoryPoint.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_srv_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandGraspPos.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_srv_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/SpecialService.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_srv_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/LoggerInfo.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_srv_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandSpreadVel.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_srv_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandFingerPos.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_srv_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandFingerVel.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_srv_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/PoseMove.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/hydro/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/hydro/share/geometry_msgs/cmake/../msg/Pose.msg;/opt/ros/hydro/share/geometry_msgs/cmake/../msg/Quaternion.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_srv_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/GravityComp.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_srv_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/JointMove.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_srv_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/Hold.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)
_generate_srv_lisp(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/OrtnMove.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
)

### Generating Module File
_generate_module_lisp(wam_msgs
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(wam_msgs_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(wam_msgs_generate_messages wam_msgs_generate_messages_lisp)

# target for backward compatibility
add_custom_target(wam_msgs_genlisp)
add_dependencies(wam_msgs_genlisp wam_msgs_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS wam_msgs_generate_messages_lisp)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTOrtnVel.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_msg_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTOrtnPos.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_msg_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTJointVel.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_msg_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTJointTq.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_msg_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/EndpointState.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/hydro/share/geometry_msgs/cmake/../msg/Quaternion.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_msg_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTPose.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_msg_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTPosMode.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_msg_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTCartVel.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_msg_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTJointPos.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_msg_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTCartPos.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)

### Generating Services
_generate_srv_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/CartPosMove.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_srv_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/LASERControl.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/hydro/share/std_msgs/cmake/../msg/Bool.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_srv_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandGraspVel.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_srv_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/LEDControl.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/hydro/share/std_msgs/cmake/../msg/Bool.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_srv_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandSpreadPos.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_srv_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/JointTrajectoryVelocityMove.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/hydro/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/hydro/share/trajectory_msgs/cmake/../msg/JointTrajectory.msg;/opt/ros/hydro/share/trajectory_msgs/cmake/../msg/JointTrajectoryPoint.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_srv_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandGraspPos.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_srv_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/SpecialService.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_srv_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/LoggerInfo.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_srv_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandSpreadVel.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_srv_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandFingerPos.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_srv_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandFingerVel.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_srv_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/PoseMove.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/hydro/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/hydro/share/geometry_msgs/cmake/../msg/Pose.msg;/opt/ros/hydro/share/geometry_msgs/cmake/../msg/Quaternion.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_srv_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/GravityComp.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_srv_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/JointMove.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_srv_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/Hold.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)
_generate_srv_py(wam_msgs
  "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/OrtnMove.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
)

### Generating Module File
_generate_module_py(wam_msgs
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(wam_msgs_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(wam_msgs_generate_messages wam_msgs_generate_messages_py)

# target for backward compatibility
add_custom_target(wam_msgs_genpy)
add_dependencies(wam_msgs_genpy wam_msgs_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS wam_msgs_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/wam_msgs
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
add_dependencies(wam_msgs_generate_messages_cpp geometry_msgs_generate_messages_cpp)
add_dependencies(wam_msgs_generate_messages_cpp sensor_msgs_generate_messages_cpp)
add_dependencies(wam_msgs_generate_messages_cpp std_msgs_generate_messages_cpp)
add_dependencies(wam_msgs_generate_messages_cpp trajectory_msgs_generate_messages_cpp)

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/wam_msgs
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
add_dependencies(wam_msgs_generate_messages_lisp geometry_msgs_generate_messages_lisp)
add_dependencies(wam_msgs_generate_messages_lisp sensor_msgs_generate_messages_lisp)
add_dependencies(wam_msgs_generate_messages_lisp std_msgs_generate_messages_lisp)
add_dependencies(wam_msgs_generate_messages_lisp trajectory_msgs_generate_messages_lisp)

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs)
  install(CODE "execute_process(COMMAND \"/usr/bin/python\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/wam_msgs
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
add_dependencies(wam_msgs_generate_messages_py geometry_msgs_generate_messages_py)
add_dependencies(wam_msgs_generate_messages_py sensor_msgs_generate_messages_py)
add_dependencies(wam_msgs_generate_messages_py std_msgs_generate_messages_py)
add_dependencies(wam_msgs_generate_messages_py trajectory_msgs_generate_messages_py)
