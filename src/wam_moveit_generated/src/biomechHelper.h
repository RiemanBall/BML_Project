 /*
 File: biomechHelper.h
 Date: 21 July, 2015
 Author: Randy Hellman
 */
#ifndef BIOMECHHELPER_
#define BIOMECHHELPER_

#include <moveit/robot_state/robot_state.h>
#include <moveit_msgs/RobotState.h>
#include <stdlib.h>



double calcDistnaceBetween2translations(Eigen::Affine3d& translation0, Eigen::Affine3d& translation1)
{
  return sqrt( pow(translation0(0,3)-translation1(0,3), 2) + pow(translation0(1,3)-translation1(1,3), 2) + pow(translation0(2,3)-translation1(2,3), 2) );
}


robot_state::RobotState setRobotStateToSetStartState(robot_state::RobotState kinematic_state, std::vector<double> variable_values)
{
  std::vector<double> currJointPositions(20,0);
  currJointPositions[0]= 1.57075; //This is important!! Need to set the first two joints.
  currJointPositions[1]= 1.57075; //[0-1] are dummy joint to orient the wam to the dual wam setup

  for(int i=0; i<variable_values.size(); i++)
  { // [i+2] is used because to get the WAM in the right orientation had to add to static joints.
    currJointPositions[i+2] = variable_values[i];
  }

  //const robot_model::RobotModelConstPtr kinematic_model = group.getCurrentState()->getRobotModel();
  //robot_state::RobotState kinematic_state(kinematic_model);
  kinematic_state.setVariablePositions(currJointPositions);

  return kinematic_state;

}

void setGeometryPoseFromInitialKinematicState(geometry_msgs::Pose& pose, robot_state::RobotState &kinematic_state)
{
  Eigen::Affine3d end_effector_state;
  end_effector_state = kinematic_state.getGlobalLinkTransform("j7");

  pose.position.x = end_effector_state(0,3);
  pose.position.y = end_effector_state(1,3);
  pose.position.z = end_effector_state(2,3);
}

double getEndEffectorTravel( moveit::planning_interface::MoveGroup& group, trajectory_msgs::JointTrajectory& jointTrajectory)
{
  double travelLength(0);
  Eigen::Affine3d end_effector_state0, end_effector_state1;
  std::vector<double> start_point;

  ROS_INFO("jointTrajectory.points[0].positions.size()= %lu",  jointTrajectory.points[0].positions.size());

  static const robot_model::RobotModelConstPtr kinematic_model = group.getCurrentState()->getRobotModel();
  static robot_state::RobotState kinematic_state(kinematic_model);
  static const robot_state::JointModelGroup* joint_model_group = kinematic_model->getJointModelGroup("arm");
  
  start_point = jointTrajectory.points[0].positions;
  kinematic_state.setJointGroupPositions(joint_model_group, start_point);
  end_effector_state0 = kinematic_state.getGlobalLinkTransform("j7");
  //ROS_INFO("translation - [x - %6.4f, y - %6.4f, z - %6.4f]", end_effector_state0(0,3), end_effector_state0(1,3), end_effector_state0(2,3));

  for(int i=1; i < jointTrajectory.points.size(); i++)
  {
    start_point = jointTrajectory.points[i].positions;
    kinematic_state.setJointGroupPositions(joint_model_group, start_point);
    end_effector_state1 = kinematic_state.getGlobalLinkTransform("j7");
    travelLength += calcDistnaceBetween2translations(end_effector_state0, end_effector_state1);
    end_effector_state0 = end_effector_state1;
  }
  
  return travelLength;
}

bool checkJointTravelLimitOk( trajectory_msgs::JointTrajectory& jointTrajectory, double limitForJoints=0.12)
{
  bool limitFlag = true;
  int endIt = jointTrajectory.points.size();
  double jointTotalDelta = 0;
  for(int i=0; i< jointTrajectory.points[0].positions.size(); i++)
  {
    jointTotalDelta = abs(jointTrajectory.points[0].positions[i] - jointTrajectory.points[endIt-1].positions[i]);
    if(jointTotalDelta > limitForJoints)
    {
      limitFlag = false;
      ROS_ERROR("JOINT LIMIT EXCEDEED, joint[%d] deltaTheta: %4.2f rad", i, jointTotalDelta);
      ROS_ERROR("##########################################################");
    }
  }
  return limitFlag;
}



#endif