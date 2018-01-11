
#include <ros/ros.h>
#include <stdio.h>

#include <moveit/move_group_interface/move_group.h>
#include <moveit/planning_scene_interface/planning_scene_interface.h>
//Kinematic info
#include <moveit/robot_model_loader/robot_model_loader.h>
#include <moveit/robot_model/robot_model.h>
#include <moveit/robot_state/robot_state.h>

#include <moveit_msgs/DisplayRobotState.h>
#include <moveit_msgs/DisplayTrajectory.h>
#include <moveit_msgs/RobotState.h>
#include <moveit_msgs/RobotTrajectory.h>
#include <trajectory_msgs/JointTrajectory.h>


#include <moveit_msgs/AttachedCollisionObject.h>
#include <moveit_msgs/CollisionObject.h>

//Barrett_WAM msgs
#include "wam_msgs/RTJointPos.h"
//Barrett_WAM srvs
#include "wam_msgs/JointMove.h"
#include "wam_msgs/JointTrajectoryVelocityMove.h"
#include <wam_msgs/LoggerInfo.h>
  

//ROS standard messages
#include "std_srvs/Empty.h"
#include "sensor_msgs/JointState.h"
#include "math.h"
#include "biomechHelper.h"






int main(int argc, char **argv)
{

	ros::init(argc, argv, "wam_move_interface_tutorial_test");
  ros::NodeHandle nh("bhand"); 
  ros::NodeHandle nw("wam");  
  ros::AsyncSpinner spinner(1);
  spinner.start();

  ros::ServiceClient biotac_logger = nw.serviceClient<wam_msgs::LoggerInfo>("logger_controller");

  wam_msgs::LoggerInfo loggerController;
  
  loggerController.request.filename = "start";
  loggerController.request.record = 1;
  if(biotac_logger.call(loggerController))
    ROS_INFO("1s-biotac_logger success status = %ld",loggerController.response.success);
  else
    ROS_INFO("1s-biotac_logger failed");

  usleep(1000000);
  
  loggerController.request.record = 0;
  if(biotac_logger.call(loggerController))
    ROS_INFO("1e-biotac_logger success status = %ld",loggerController.response.success);
  else
   ROS_INFO("1e-biotac_logger failed");
  usleep(1000000);


  loggerController.request.filename = "recordSomething";
  loggerController.request.record = 1;
  if(biotac_logger.call(loggerController))
    ROS_INFO("1s-biotac_logger success status = %ld",loggerController.response.success);
  else
    ROS_INFO("1s-biotac_logger failed");

  usleep(10000000);
  
  loggerController.request.record = 0;
  if(biotac_logger.call(loggerController))
    ROS_INFO("1e-biotac_logger success status = %ld",loggerController.response.success);
  else
   ROS_INFO("1e-biotac_logger failed");


  ros::shutdown();  
  return 0;
}




  /*
  ROS_INFO("About to call CLOSE_GRASP");
  sleep(2);
  if(close_grasp.call(empty_srv_1))
  {
    ROS_INFO("CLOSE_GRASP success");
  }
  else
  {
    ROS_INFO("CLOSE_GRASP fail");
  }
  sleep(2);
  if(open_grasp.call(empty_srv_2))
  {
    ROS_INFO("OPEN_GRASP success");
  }
  else
  {
    ROS_INFO("OPEN_GRASP fail");
  }
  */