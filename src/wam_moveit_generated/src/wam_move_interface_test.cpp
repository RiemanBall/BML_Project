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
#include <wam_msgs/BHandFingerPos.h>
#include <wam_msgs/BHandSpreadPos.h>
//ROS standard messages
#include "std_srvs/Empty.h"
#include "sensor_msgs/JointState.h"
#include "math.h"
#include "biomechHelper.h"
//JSON library to manipulate UDP packets
#include "rapidjson/document.h"     // rapidjson's DOM-style API
#include "rapidjson/prettywriter.h" // for stringify JSON
#include "rapidjson/filestream.h"   // wrapper of C stream for prettywriter as output
#include <boost/thread.hpp>
#include <boost/function.hpp>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>

#define BUFLEN 1500
#define controllerPORT 9330 //Port for iphone app
#define cameraPORT 9331 //Port to IOS device to recording

sensor_msgs::JointState currJointState;
void wamJointStateCallback(const sensor_msgs::JointState::ConstPtr& jointState)
{
  //ROS_INFO("IN wamJointStateCallback");
  //ROS_INFO("J[%4.2f, %4.2f, %4.2f, %4.2f, %4.2f, %4.2f, %4.2f]", jointState->position[0],jointState->position[1],jointState->position[2],jointState->position[3],jointState->position[4],jointState->position[5],jointState->position[6]);
  currJointState = *jointState;
}

void err(std::string str)
{
    perror(str.c_str());
    exit(1);
}

std::string actionSpace("na");
bool running = true;
void controllerServer()
{
   //Network controll either from matlab or iPhone
  char buf[BUFLEN];
  char sendbuf[BUFLEN];
  struct sockaddr_in my_addr, cli_addr;
  int sockfd;
  socklen_t slen=sizeof(cli_addr);
  
  if ((sockfd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP))==-1)
      err("socket");
  else
      printf("Server : Socket() successful\n");
  
  bzero(&my_addr, sizeof(my_addr));
  my_addr.sin_family = AF_INET;
  my_addr.sin_port = htons(controllerPORT);
  my_addr.sin_addr.s_addr = htonl(INADDR_ANY);
  
  if (bind(sockfd, (struct sockaddr* ) &my_addr, sizeof(my_addr))==-1)
      err("bind");
  else
      printf("Server : bind() successful\n");

  while(running)
  {
    //Receive network command from matlab or iPhone
    rapidjson::Document document;
    memset(buf, 0, BUFLEN);
    if (recvfrom(sockfd, buf, BUFLEN, 0, (struct sockaddr*)&cli_addr, &slen)==-1)
      err("recvfrom()");
        
    if(document.Parse(buf).HasParseError())
    {
      printf("\nParseError\n");
      printf("Original JSON:\n %s\n", buf);
    }

    if(document.IsObject())
    { //JSON success now handle what to do
      //Parse into Variables
      
      //wam0_state.moveToStart = document["wam0_moveToStart"].GetInt();
      actionSpace = document["actionSelection"].GetString();
    }
  }
  close(sockfd);

}

std::string cameraStatus("recording"), cameraAction("stop"), cameraFilename("defaultRecord.mov");
bool shouldSendToCamera = true;
void cameraServer()
{
   //Network controll either from matlab or iPhone
  char buf[BUFLEN];
  char sendbuf[BUFLEN];
  struct sockaddr_in my_addr, cli_addr;
  int sockfd, sendLen;
  socklen_t slen=sizeof(cli_addr);
  
  if ((sockfd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP))==-1)
      err("socket");
  else
      printf("Server : Socket() successful\n");
  
  bzero(&my_addr, sizeof(my_addr));
  my_addr.sin_family = AF_INET;
  my_addr.sin_port = htons(cameraPORT);
  my_addr.sin_addr.s_addr = htonl(INADDR_ANY);
  
  if (bind(sockfd, (struct sockaddr* ) &my_addr, sizeof(my_addr))==-1)
      err("bind");
  else
      printf("Server : bind() successful\n");

  while(1)
  {
    //Receive network command from matlab or iPhone
    rapidjson::Document document;
    memset(buf, 0, BUFLEN);
    if (recvfrom(sockfd, buf, BUFLEN, 0, (struct sockaddr*)&cli_addr, &slen)==-1)
      err("recvfrom()");
    if(document.Parse(buf).HasParseError())
    {
      printf("\nParseError\n");
      printf("Original JSON:\n %s\n", buf);
    }
    if(document.IsObject())
    { //JSON success now handle what to do. Parse into Variables
      //wam0_state.moveToStart = document["wam0_moveToStart"].GetInt();
      cameraStatus = document["cameraStatus"].GetString();
      //ROS_INFO("cameraStatus: %s",cameraStatus.c_str());
    }

    if(shouldSendToCamera)
    {
      memset(sendbuf, 0, BUFLEN);
      ROS_INFO("Sending to camera - {\"action\":%s,\"filename\":%s}", cameraAction.c_str(), cameraFilename.c_str());
      sendLen = sprintf(sendbuf,"{\"action\":\"%s\",\"filename\":\"%s\"}", cameraAction.c_str(), cameraFilename.c_str());
      sendto(sockfd, sendbuf, sendLen, 0, (struct sockaddr*)&cli_addr, slen);
      shouldSendToCamera = false;
    }
  }
  close(sockfd);
}
//cameraAction is blocking and will wait until camera is ready`
void cameraActionSender(int shouldRecord, std::string filename)
{
  if(shouldRecord == 0)
  {
    if(cameraStatus.compare("ready") == 0)
    {
      ROS_ERROR("Requesting stop camera: Camera is already stoped ");
    }
    else
    {
      while(cameraStatus.compare("ready") != 0)
      {
        cameraAction = "stop";
        shouldSendToCamera = true;
        usleep(100000);
        //ROS_INFO("trying to stop record");
      }
    }
  }
  else if(shouldRecord == 1)
  {
    while(cameraStatus.compare("ready") != 0)
    {
      usleep(200000);
      ROS_WARN("cameraStatus: isRecording waiting for cameraReady");
    }
    ROS_INFO("GOING TO TRY AND RECORd #########################");
    cameraAction = "start";
    filename.append(".mov");
    cameraFilename = filename;
    shouldSendToCamera = true;
  }
}


int main(int argc, char **argv)
{

	ros::init(argc, argv, "wam_move_interface_tutorial_test");
  	ros::NodeHandle nh("bhand"); 
    ros::NodeHandle nw("wam");  
  	ros::AsyncSpinner spinner(1);
  	spinner.start();

  sleep(10.0);
  // BEGIN_TUTORIAL
  // 
  // Setup
  // ^^^^^
  // 
  // The :move_group_interface:`MoveGroup` class can be easily 
  // setup using just the name
  // of the group you would like to control and plan for.
  moveit::planning_interface::MoveGroup group("arm");
  const robot_model::RobotModelConstPtr kinematic_model = group.getCurrentState()->getRobotModel();
  robot_state::RobotStatePtr kinematic_state(new robot_state::RobotState(kinematic_model));


  const robot_state::JointModelGroup* joint_model_group = kinematic_model->getJointModelGroup("arm");

  kinematic_state->setToDefaultValues(joint_model_group, "home");
  const std::vector<std::string> &joint_names = joint_model_group->getJointModelNames();

  std::vector<double> joint_values;
  kinematic_state->copyJointGroupPositions(joint_model_group, joint_values);
  for(std::size_t i = 0; i < joint_names.size(); ++i)
  {
    ROS_INFO("Joint %s: %f", joint_names[i].c_str(), joint_values[i]);
  }

 

  



  // We will use the :planning_scene_interface:`PlanningSceneInterface`
  // class to deal directly with the world.
  moveit::planning_interface::PlanningSceneInterface planning_scene_interface;  

  // (Optional) Create a publisher for visualizing plans in Rviz.
  ros::Publisher display_publisher = nw.advertise<moveit_msgs::DisplayTrajectory>("/move_group/display_planned_path", 1, true);
  moveit_msgs::DisplayTrajectory display_trajectory;

  //Barrett_WAM interface
  //Subscribers
  ros::Subscriber wam_joint_state_sub = nw.subscribe("joint_states",1000, wamJointStateCallback);

  //Services see wam_node for additional msgs and srv
  //bhand
  ros::ServiceClient close_grasp  = nh.serviceClient<std_srvs::Empty>("close_grasp");
  ros::ServiceClient open_grasp   = nh.serviceClient<std_srvs::Empty>("open_grasp");
  ros::ServiceClient close_spread = nh.serviceClient<std_srvs::Empty>("close_spread");
  ros::ServiceClient open_spread = nh.serviceClient<std_srvs::Empty>("open_spread");
  ros::ServiceClient finger_pos   = nh.serviceClient<wam_msgs::BHandFingerPos>("finger_pos");
  ros::ServiceClient spread_pos   = nh.serviceClient<wam_msgs::BHandSpreadPos>("spread_pos");

  //wam
  ros::ServiceClient joint_move  = nw.serviceClient<wam_msgs::JointMove>("joint_move");
  ros::ServiceClient go_home  = nw.serviceClient<std_srvs::Empty>("go_home");
  ros::ServiceClient joint_trajectory_velocity_move  = nw.serviceClient<wam_msgs::JointTrajectoryVelocityMove>("joint_trajectory_velocity_move");
  ros::ServiceClient biotac_logger = nw.serviceClient<wam_msgs::LoggerInfo>("logger_controller");

  std_srvs::Empty empty_srv_1, empty_srv_2;
  wam_msgs::JointTrajectoryVelocityMove jointTrajectoryMove;
  wam_msgs::LoggerInfo loggerController;
  //startState.joint_state = startJointState;

  //Start cameraNetworkThread
  boost::thread cameraRequestRecorderThread(cameraServer);

  //Place hand in safe grasp position
  close_spread.call(empty_srv_1);
  if(open_grasp.call(empty_srv_1))
    ROS_INFO("CLOSE_GRASP success");
  else
    ROS_WARN("CLOSE_GRASP fail");
  sleep(2.0);

  std::vector<wam_msgs::JointMove> moveToStartingPoint;
  wam_msgs::JointMove jointMovePos;
  for (int i=0; i<4; i++)
    moveToStartingPoint.push_back(jointMovePos);
  //Move to new starting point
  float pos0[] = {0.967759,-1.63302, 0.023809, 0.13686, 0.079941, 0.106509,-0.1037720 };
  moveToStartingPoint[0].request.joints.assign(pos0, pos0+7);
  float pos1[] ={0.285759,-1.51123, 0.175698, 2.14220, 0.062703, 0.284261,-0.0925731 };
  moveToStartingPoint[1].request.joints.assign(pos1, pos1+7);
  float pos2[] ={-1.58373,-1.25276,-0.027823, 2.50712,-0.083499, 0.276433, 0.0452077 };
  moveToStartingPoint[2].request.joints.assign(pos2, pos2+7);
  float pos3[] ={-1.559620, -0.902361, -0.021346, 2.397953, -0.009726, 0.075039, 0.00};
  moveToStartingPoint[3].request.joints.assign(pos3, pos3+7);
  
  loggerController.request.filename = "moveToStart";
  loggerController.request.record = 1;
  cameraActionSender(1,loggerController.request.filename); //Start record
  if(biotac_logger.call(loggerController))
    ROS_INFO("1s-biotac_logger success status = %ld",loggerController.response.success);
  else
    ROS_INFO("1s-biotac_logger failed");

  wam_msgs::BHandSpreadPos spreadPos;
  wam_msgs::BHandFingerPos fingerPos;
  fingerPos.request.radians[0] = 0; fingerPos.request.radians[1] = 0; fingerPos.request.radians[2] = 2.45;
  finger_pos.call(fingerPos);
  //Move to starting point
  for(int i=0; i<moveToStartingPoint.size(); i++)
  {
    if(joint_move.call(moveToStartingPoint[i]))
      ROS_INFO("joint_move.call SUCCESS***************");
    else
      ROS_WARN("joint_move.call FAIL***************");
  }


  spreadPos.request.radians = 1.57079;
  spread_pos.call(spreadPos);
  usleep(1000000);
  fingerPos.request.radians[0] = 1.88; fingerPos.request.radians[1] = 1.88; fingerPos.request.radians[2] = 2.45;
  finger_pos.call(fingerPos);

  loggerController.request.filename = "moveToStart";
  loggerController.request.record = 0;
  cameraActionSender(0,loggerController.request.filename); //Start record
  if(biotac_logger.call(loggerController))
    ROS_INFO("1s-biotac_logger success status = %ld",loggerController.response.success);
  else
    ROS_INFO("1s-biotac_logger failed");

  //Group specific 
  group.setPlannerId("RRTstarkConfigDefault");

  std::vector<double> start_variable_values;
  group.getCurrentState()->copyJointGroupPositions(group.getCurrentState()->getRobotModel()->getJointModelGroup(group.getName()), start_variable_values);
  //Starting joint space for the planner. It's important to provide joint space since infinte solutions to cartesian position
  double startPoint[] = {-1.559620, -0.902361, -0.021346, 2.397953, -0.009726, 0.075039, 0.00};
  start_variable_values.assign(startPoint, startPoint+7);

  kinematic_state->setJointGroupPositions(joint_model_group, start_variable_values);
  group.setStartState(*kinematic_state);

  geometry_msgs::Pose start_pose;
  setGeometryPoseFromInitialKinematicState( start_pose, *kinematic_state);
  start_pose.orientation.w = 0;
  start_pose.orientation.x = 0;
  start_pose.orientation.y = 1;
  start_pose.orientation.z = 0;

  moveit::planning_interface::MoveGroup::Plan my_plan;
  group.setPoseTarget(start_pose); //Cartesian position and orientation goal
  //group.setJointValueTarget(start_varuable_values); //Joint space goal

  group.setPlanningTime(0.75);
  bool success = group.plan(my_plan); //Start planner

  moveit_msgs::RobotTrajectory current_Traj = my_plan.trajectory_;
  trajectory_msgs::JointTrajectory jointTrajectory = current_Traj.joint_trajectory;

  double travelLength(0);
  travelLength = getEndEffectorTravel( group, jointTrajectory); 

  jointTrajectoryMove.request.jointTrajectory = jointTrajectory;
  ROS_INFO("travelLength of orientation move - %6.4f", travelLength);
  jointTrajectoryMove.request.length = .15; //travel length of end effector
  jointTrajectoryMove.request.velocity = 0.05; // 0.02 m/s or 2 cm/s
  
  if(joint_trajectory_velocity_move.call(jointTrajectoryMove))
    ROS_INFO("JointTrajectoryVelocityMove success status = %lu",jointTrajectoryMove.response.status);
  else
    ROS_WARN("JointTrajectoryVelocityMove FAIL ######");

  //Set incremental moves
  std::vector<double> trajectroyStartPoint;
  
  int itToLastPoint = jointTrajectory.points.size()-1;
  trajectroyStartPoint = jointTrajectory.points[itToLastPoint].positions;
  moveit::planning_interface::MoveGroup::Plan my_plan1;
/*
  kinematic_state->setJointGroupPositions(joint_model_group, trajectroyStartPoint);
  group.setStartState(*kinematic_state);
  setGeometryPoseFromInitialKinematicState( start_pose, *kinematic_state);
  start_pose.position.x -= 0.02;

  
  group.setPoseTarget(start_pose); //Cartesian position and orientation goal

  group.setPlanningTime(0.75);
  success = group.plan(my_plan1); //Start planner

  current_Traj = my_plan1.trajectory_;
  jointTrajectory = current_Traj.joint_trajectory;

  travelLength = 0;
  travelLength = getEndEffectorTravel( group, jointTrajectory); 
  //Building Joint Trajectory move to be sent to wam_node
  jointTrajectoryMove.request.jointTrajectory = jointTrajectory;
  jointTrajectoryMove.request.length = travelLength; //travel length of end effector
  ROS_INFO("x - travelLength = %6.4f",travelLength);
  jointTrajectoryMove.request.velocity = 0.01; // 0.02 m/s or 2 cm/s
  //Call to wam_node to run trajectory
  if(joint_trajectory_velocity_move.call(jointTrajectoryMove))
    ROS_INFO("JointTrajectoryVelocityMove success status = %lu",jointTrajectoryMove.response.status);
  else
    ROS_WARN("JointTrajectoryVelocityMove fail");
*/
  
  loggerController.request.filename = "incrementalMove";
  loggerController.request.record = 1;
  cameraActionSender(1,loggerController.request.filename); //Start record
  if(biotac_logger.call(loggerController))
    ROS_INFO("1s-biotac_logger success status = %ld",loggerController.response.success);
  else
    ROS_INFO("1s-biotac_logger failed");

  group.setPlanningTime(0.25);
  //Start udp message reciever
  boost::thread networkingThread(controllerServer);

  while(running)
  {
    if(actionSpace.compare("na") != 0)
    {
      trajectroyStartPoint.clear();
      trajectroyStartPoint = jointTrajectory.points[jointTrajectory.points.size()-1].positions;

      kinematic_state->setJointGroupPositions(joint_model_group, trajectroyStartPoint);
      group.setStartState(*kinematic_state);
      setGeometryPoseFromInitialKinematicState( start_pose, *kinematic_state);
      
      if(actionSpace.compare("+x") == 0)
      {
        start_pose.position.x += 0.005;
      }
      else if(actionSpace.compare("-x") == 0)
      {
        start_pose.position.x -= 0.005;
      }
      else if(actionSpace.compare("+z") == 0)
      {
        start_pose.position.z += 0.005;
      }
      else if(actionSpace.compare("-z") == 0)
      {
        start_pose.position.z -= 0.005;
      }
      else if(actionSpace.compare("q") == 0)
      {
        running = false;
      }
      else if(actionSpace.compare("d") == 0)
      {
        ROS_INFO("ActionSpace - d");
        ROS_INFO("J[%8.6f, %8.6f, %8.6f, %8.6f, %8.6f, %8.6f, %8.6f]", currJointState.position[0],currJointState.position[1],currJointState.position[2],currJointState.position[3],currJointState.position[4],currJointState.position[5],currJointState.position[6]);
      }
      
      group.setPoseTarget(start_pose); //Cartesian position and orientation goal
      success = group.plan(my_plan1); //Start planner

      if(success && running)
      {
        current_Traj = my_plan1.trajectory_;
        jointTrajectory = current_Traj.joint_trajectory;

        travelLength = 0;
        travelLength = getEndEffectorTravel( group, jointTrajectory); 
        //Building Joint Trajectory move to be sent to wam_node
        jointTrajectoryMove.request.jointTrajectory = jointTrajectory;
        jointTrajectoryMove.request.length = travelLength; //travel length of end effector
        ROS_INFO("z - travelLength = %6.4f",travelLength);

        jointTrajectoryMove.request.velocity = 0.01; // 0.02 m/s or 2 cm/s
        //Call to wam_node to run trajectory
        if(joint_trajectory_velocity_move.call(jointTrajectoryMove))
          ROS_INFO("JointTrajectoryVelocityMove success status = %lu",jointTrajectoryMove.response.status);
        else
          ROS_WARN("JointTrajectoryVelocityMove fail");
      }
      else
      {
        ROS_WARN("TRAJECTORY PLANNER FAILED! NOT GOOD or quiting so it is ok!");
      }
    }
    else
    {
      usleep(100000);
    }
  }
  loggerController.request.filename = "incrementalMove";
  loggerController.request.record = -1;
  cameraActionSender(0,loggerController.request.filename); //Start record
  if(biotac_logger.call(loggerController))
    ROS_INFO("1s-biotac_logger success status = %ld",loggerController.response.success);
  else
    ROS_INFO("1s-biotac_logger failed");

  // Prepare hand to return to home. Should have if/else for failed ROS srv calls
  fingerPos.request.radians[0] = 0; fingerPos.request.radians[1] = 0;
  finger_pos.call(fingerPos);
  usleep(1000000);
  close_spread.call(empty_srv_1);
  
  //Reverse to from starting point vector
  for(int i= moveToStartingPoint.size()-2; i>=0; i--)
  {
    joint_move.call(moveToStartingPoint[i]);
  }
  go_home.call(empty_srv_1);
  fingerPos.request.radians[2] = 0;
  finger_pos.call(fingerPos);

  networkingThread.join();
  cameraRequestRecorderThread.interrupt();
  ros::shutdown();  
  return 0;
}

