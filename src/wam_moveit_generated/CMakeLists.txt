cmake_minimum_required(VERSION 2.8.3)
project(wam_moveit_generated)

find_package(catkin REQUIRED)

catkin_package()
install(DIRECTORY launch DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION})
install(DIRECTORY config DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION})


find_package(catkin REQUIRED COMPONENTS std_msgs std_srvs sensor_msgs geometry_msgs trajectory_msgs moveit_core roslib moveit_ros_planning moveit_ros_planning_interface pluginlib cmake_modules)

find_package(Boost REQUIRED system filesystem date_time thread)

catkin_package(
#  INCLUDE_DIRS include
#  LIBRARIES pr2_moveit_tutorials
  CATKIN_DEPENDS
    std_msgs 
    std_srvs 
    sensor_msgs
    geometry_msgs 
    trajectory_msgs 
    moveit_core
    moveit_ros_planning_interface
    interactive_markers
    wam_common
)
find_package(Eigen REQUIRED)

###########
## Build ##
###########


include_directories(SYSTEM ${Boost_INCLUDE_DIR} ${EIGEN_INCLUDE_DIRS})
include_directories(${catkin_INCLUDE_DIRS})
link_directories(${catkin_LIBRARY_DIRS})

### RH added
add_executable(wam_move_interface_test src/wam_move_interface_test.cpp)
target_link_libraries(wam_move_interface_test ${catkin_LIBRARIES} ${Boost_LIBRARIES})
install(TARGETS wam_move_interface_test DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION})

add_executable(wam_move_edge_trainer src/wam_move_edge_trainer.cpp)
target_link_libraries(wam_move_edge_trainer ${catkin_LIBRARIES} ${Boost_LIBRARIES})
install(TARGETS wam_move_edge_trainer DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION})

add_executable(wam_move_qlearner src/wam_move_qlearner.cpp)
target_link_libraries(wam_move_qlearner ${catkin_LIBRARIES} ${Boost_LIBRARIES})
install(TARGETS wam_move_qlearner DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION})

add_executable(wam_move_clup src/wam_move_clup.cpp)
target_link_libraries(wam_move_clup ${catkin_LIBRARIES} ${Boost_LIBRARIES})
install(TARGETS wam_move_clup DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION})

add_executable(wam_move_msgs_tester src/wam_move_msgs_tester.cpp)
target_link_libraries(wam_move_msgs_tester ${catkin_LIBRARIES} ${Boost_LIBRARIES})
install(TARGETS wam_move_msgs_tester DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION})



###
