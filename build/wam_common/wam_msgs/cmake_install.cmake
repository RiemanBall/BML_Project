# Install script for directory: /home/robot/rieman_ws/src/wam_common/wam_msgs

# Set the install prefix
IF(NOT DEFINED CMAKE_INSTALL_PREFIX)
  SET(CMAKE_INSTALL_PREFIX "/home/robot/rieman_ws/install")
ENDIF(NOT DEFINED CMAKE_INSTALL_PREFIX)
STRING(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
IF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  IF(BUILD_TYPE)
    STRING(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  ELSE(BUILD_TYPE)
    SET(CMAKE_INSTALL_CONFIG_NAME "")
  ENDIF(BUILD_TYPE)
  MESSAGE(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
ENDIF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)

# Set the component getting installed.
IF(NOT CMAKE_INSTALL_COMPONENT)
  IF(COMPONENT)
    MESSAGE(STATUS "Install component: \"${COMPONENT}\"")
    SET(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  ELSE(COMPONENT)
    SET(CMAKE_INSTALL_COMPONENT)
  ENDIF(COMPONENT)
ENDIF(NOT CMAKE_INSTALL_COMPONENT)

# Install shared libraries without execute permission?
IF(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  SET(CMAKE_INSTALL_SO_NO_EXE "1")
ENDIF(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/wam_msgs/msg" TYPE FILE FILES
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTCartPos.msg"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTCartVel.msg"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTJointPos.msg"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTJointVel.msg"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTJointTq.msg"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTOrtnPos.msg"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTOrtnVel.msg"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTPose.msg"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/RTPosMode.msg"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/msg/EndpointState.msg"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/wam_msgs/srv" TYPE FILE FILES
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandFingerPos.srv"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandFingerVel.srv"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandGraspPos.srv"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandGraspVel.srv"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandSpreadPos.srv"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/BHandSpreadVel.srv"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/CartPosMove.srv"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/GravityComp.srv"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/Hold.srv"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/JointMove.srv"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/OrtnMove.srv"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/PoseMove.srv"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/LASERControl.srv"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/LEDControl.srv"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/JointTrajectoryVelocityMove.srv"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/LoggerInfo.srv"
    "/home/robot/rieman_ws/src/wam_common/wam_msgs/srv/SpecialService.srv"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/wam_msgs/cmake" TYPE FILE FILES "/home/robot/rieman_ws/build/wam_common/wam_msgs/catkin_generated/installspace/wam_msgs-msg-paths.cmake")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE DIRECTORY FILES "/home/robot/rieman_ws/devel/include/wam_msgs")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/common-lisp/ros" TYPE DIRECTORY FILES "/home/robot/rieman_ws/devel/share/common-lisp/ros/wam_msgs")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  execute_process(COMMAND "/usr/bin/python" -m compileall "/home/robot/rieman_ws/devel/lib/python2.7/dist-packages/wam_msgs")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/python2.7/dist-packages" TYPE DIRECTORY FILES "/home/robot/rieman_ws/devel/lib/python2.7/dist-packages/wam_msgs")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/robot/rieman_ws/build/wam_common/wam_msgs/catkin_generated/installspace/wam_msgs.pc")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/wam_msgs/cmake" TYPE FILE FILES "/home/robot/rieman_ws/build/wam_common/wam_msgs/catkin_generated/installspace/wam_msgs-msg-extras.cmake")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/wam_msgs/cmake" TYPE FILE FILES
    "/home/robot/rieman_ws/build/wam_common/wam_msgs/catkin_generated/installspace/wam_msgsConfig.cmake"
    "/home/robot/rieman_ws/build/wam_common/wam_msgs/catkin_generated/installspace/wam_msgsConfig-version.cmake"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/wam_msgs" TYPE FILE FILES "/home/robot/rieman_ws/src/wam_common/wam_msgs/package.xml")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

