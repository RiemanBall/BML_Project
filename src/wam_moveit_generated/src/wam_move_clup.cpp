#include <ros/ros.h>
#include <ros/package.h>
#include <stdio.h>
#include <stdlib.h>
#include <error.h>
#include <unistd.h>
#include <string.h>
#include <iostream>
#include <sstream>
#include <fstream>

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
#include <wam_msgs/SpecialService.h>
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
#include <signal.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <netdb.h>

#define BUFLEN 4096
#define controllerPORT 9330 //Port for iphone app
#define cameraPORT     9331 //Port to IOS device to recording
//Matlab
#define serverPORT "55000" // the port client will be connecting to
#define MAXDATASIZE 200 // max number of bytes we can get at once
#define BACKLOG 10   // how many pending connections queue will hold


bool currLearning = true;
bool currEpisode  = true;

sensor_msgs::JointState currJointState;
void wamJointStateCallback(const sensor_msgs::JointState::ConstPtr& jointState)
{
  //ROS_INFO("IN wamJointStateCallback");
  //ROS_INFO("J[%4.2f, %4.2f, %4.2f, %4.2f, %4.2f, %4.2f, %4.2f]", jointState->position[0],jointState->position[1],
  // jointState->position[2],jointState->position[3],jointState->position[4],jointState->position[5],jointState->position[6]);
  currJointState = *jointState;
}

std::vector<std::string> f_posOffsetVec;
std::vector<double> f_pdcVec;
std::vector<std::string> f_trialVec;
void loadTrialInfo()
{
  std::string temp_pos_offset;
  std::string temp_pdc;
  std::string temp_trial;

  std::string path = ros::package::getPath("wam_moveit_generated");
  path.append("/src/FileInfo.txt");
  std::fstream myfile(path.c_str());

  if(myfile.is_open())
  {
    while( myfile.good())
    {
      myfile >> temp_pos_offset >> temp_pdc >> temp_trial;

      f_posOffsetVec.push_back(temp_pos_offset);
      f_pdcVec.push_back(atof(temp_pdc.c_str()));
      f_trialVec.push_back(temp_trial);
    }
    myfile.close();
  }
  else
  {
    ROS_ERROR("FILE NOT OPENED ----ERROR----");
  }
} 


void err(std::string str)
{
    perror(str.c_str());
    exit(1);
}

std::string actionSpace("na");
std::string saveFilename("na");
std::string episode("na");
double incrementalTravelLength(0.005);
double graspPressure(0);
bool running = true;



int unwrapMssg(std::string mssg)
{

    rapidjson::Document document;
    if(document.Parse(mssg.c_str()).HasParseError())
    {
      printf("\nParseError\n");
      printf("test");
      printf("Original JSON:\n %s\n", mssg.c_str());
      return 0;
    }

    if(document.IsObject())
    { //JSON success now handle what to do
      //Parse into Variables
      
      //wam0_state.moveToStart = document["wam0_moveToStart"].GetInt();
      actionSpace  = document["actionSelection"].GetString();
      incrementalTravelLength = document["incrementalTravelLength"].GetDouble();
      graspPressure = document["graspPressure"].GetDouble();
      saveFilename = document["saveFilename"].GetString();
      episode      = document["episode"].GetString();

    }
  return 1;
}


std::string cameraStatus("recording"), cameraAction("stop"), cameraFilename("defaultRecord.mov");
bool shouldSendToCamera = true;
void cameraServer()
{
   //Network control either from matlab or iPhone
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
      cameraAction = "stop";
      shouldSendToCamera = true;
      }
    ROS_INFO("GOING TO TRY AND RECORd #########################");
    cameraAction = "start";
    filename.append(".mov");
    cameraFilename = filename;
    shouldSendToCamera = true;
  }
}


// tcp/ip helper funcitons
void sigchld_handler(int s)
{
  // waitpid() might overwrite errno, so we save and restore it:
  int saved_errno = errno;
  
  while(waitpid(-1, NULL, WNOHANG) > 0);
  
  errno = saved_errno;
}

// get sockaddr, IPv4 or IPv6:
void *get_in_addr(struct sockaddr *sa)
{
  if (sa->sa_family == AF_INET) {
    return &(((struct sockaddr_in*)sa)->sin_addr);
  }
  
  return &(((struct sockaddr_in6*)sa)->sin6_addr);
}

//Matlab Server
int startServer(int &sockfd, int &new_fd)
{
  struct addrinfo hints, *servinfo, *p;
  struct sockaddr_storage their_addr; // connector's address information
  socklen_t sin_size;
  struct sigaction sa;
  int yes=1;
  char s[INET6_ADDRSTRLEN];
  int rv;
  
  memset(&hints, 0, sizeof hints);
  hints.ai_family = AF_UNSPEC;
  hints.ai_socktype = SOCK_STREAM;
  hints.ai_flags = AI_PASSIVE; // use my IP
  
  if ((rv = getaddrinfo(NULL, serverPORT, &hints, &servinfo)) != 0) {
    fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(rv));
    return 1;
  }
  
  // loop through all the results and bind to the first we can
  for(p = servinfo; p != NULL; p = p->ai_next) {
    if ((sockfd = socket(p->ai_family, p->ai_socktype,
                         p->ai_protocol)) == -1) {
      perror("server: socket");
      continue;
    }
    
    if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &yes,
                   sizeof(int)) == -1) {
      perror("setsockopt");
      exit(1);
    }
    
    if (bind(sockfd, p->ai_addr, p->ai_addrlen) == -1) {
      close(sockfd);
      perror("server: bind");
      continue;
    }
    
    break;
  }
  
  freeaddrinfo(servinfo); // all done with this structure
  
  if (p == NULL)  {
    fprintf(stderr, "server: failed to bind\n");
    exit(1);
  }
  
  if (listen(sockfd, BACKLOG) == -1) {
    perror("listen");
    exit(1);
  }
  
  sa.sa_handler = sigchld_handler; // reap all dead processes
  sigemptyset(&sa.sa_mask);
  sa.sa_flags = SA_RESTART;
  if (sigaction(SIGCHLD, &sa, NULL) == -1) {
    perror("sigaction");
    exit(1);
  }
  
  printf("server: waiting for connections...\n");
  
  sin_size = sizeof their_addr;
  new_fd = accept(sockfd, (struct sockaddr *)&their_addr, &sin_size);
  if (new_fd == -1) {
    perror("accept");
  }
  
  inet_ntop(their_addr.ss_family,
            get_in_addr((struct sockaddr *)&their_addr),
            s, sizeof s);
  printf("server: got connection from %s\n", s);
  close(sockfd); //Now we are connected and don't need listner
  usleep(10000);
  return 1;
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

  //Start udp message reciever 
  //boost::thread networkingThread(controllerServer); old code not replaced with tcp/ip 

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
  ros::ServiceClient special_service = nw.serviceClient<wam_msgs::SpecialService>("special_service");

  std_srvs::Empty empty_srv_1, empty_srv_2;
  wam_msgs::JointTrajectoryVelocityMove jointTrajectoryMove;
  wam_msgs::LoggerInfo loggerController;
  wam_msgs::SpecialService specialService;
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
  float pos0[] = {0.965, -1.610, -0.057,  0.490,  0.173,  0.460, -0.166 };
  moveToStartingPoint[0].request.joints.assign(pos0, pos0+7);
  float pos1[] ={0.252, -1.608, -0.044,  1.070, -0.003,  0.876, -0.108 };
  moveToStartingPoint[1].request.joints.assign(pos1, pos1+7);
  float pos2[] ={-1.541, -1.278,  0.005,  1.629, -0.047,  1.073,  0.039 };
  moveToStartingPoint[2].request.joints.assign(pos2, pos2+7);
  float pos3[] ={-1.611, -0.779,  0.011,  1.970,  0.020,  0.403, -0.003};
  moveToStartingPoint[3].request.joints.assign(pos3, pos3+7);
  
  wam_msgs::BHandSpreadPos spreadPos;
  wam_msgs::BHandFingerPos fingerPos;
  fingerPos.request.radians[0] = 0; fingerPos.request.radians[1] = 0; fingerPos.request.radians[2] = 0;
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
  fingerPos.request.radians[0] = 1.88; fingerPos.request.radians[1] = 1.88; fingerPos.request.radians[2] = 0;
  finger_pos.call(fingerPos);




  //Group specific 
  group.setPlannerId("RRTstarkConfigDefault");

  std::vector<double> start_variable_values;
  group.getCurrentState()->copyJointGroupPositions(group.getCurrentState()->getRobotModel()->getJointModelGroup(group.getName()), start_variable_values);
  //Starting joint space for the planner. It's important to provide joint space since infinte solutions to cartesian position
  double startPoint[] = {-1.611, -0.779,  0.011,  1.970,  0.020,  0.403, -0.003};
  start_variable_values.assign(startPoint, startPoint+7);

  kinematic_state->setJointGroupPositions(joint_model_group, start_variable_values);
  group.setStartState(*kinematic_state);

  geometry_msgs::Pose start_pose;
  setGeometryPoseFromInitialKinematicState( start_pose, *kinematic_state);
  start_pose.position.x   -= 0.01;
  start_pose.position.z   -= 0.02;
  start_pose.orientation.w = 0;
  start_pose.orientation.x = 0;
  start_pose.orientation.y = 1;
  start_pose.orientation.z = 0;

  moveit::planning_interface::MoveGroup::Plan my_plan;
  group.setPoseTarget(start_pose); //Cartesian position and orientation goal
  //group.setJointValueTarget(start_varuable_values); //Joint space goal

  group.setPlanningTime(3);
  bool success = group.plan(my_plan); //Start planner

  moveit_msgs::RobotTrajectory current_Traj = my_plan.trajectory_;
  trajectory_msgs::JointTrajectory jointTrajectory = current_Traj.joint_trajectory;

  double travelLength(0);
  travelLength = getEndEffectorTravel( group, jointTrajectory); 

  jointTrajectoryMove.request.jointTrajectory = jointTrajectory;
  ROS_INFO("travelLength of orientation move - %6.4f", travelLength);
  jointTrajectoryMove.request.length = 0.15; //travel length of end effector
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

  group.setPlanningTime(3);


  //set orientation constraints
  moveit_msgs::OrientationConstraint ocm;
  ocm.link_name = "j7";
  ocm.header.frame_id = "base_link";
  ocm.orientation = start_pose.orientation;
  ocm.absolute_x_axis_tolerance = 0.1;
  ocm.absolute_y_axis_tolerance = 0.1;
  ocm.absolute_z_axis_tolerance = 0.1;
  ocm.weight = 1;

  moveit_msgs::Constraints test_constraints;
  test_constraints.orientation_constraints.push_back(ocm);
  group.setPathConstraints(test_constraints);

  geometry_msgs::Pose curr_pose;
  //Iterator for each Episode 
  double totalTravelLengthPerEpisode = 0;
  int numOfFailures = 0;


  specialService.request.action = "resetPinch";
  if(!special_service.call(specialService))
    ROS_ERROR("resetPinch failed");
  usleep(1000000);

    //Warmup biotac
  loggerController.request.filename = "startUp";
  loggerController.request.record = 1;
  if(biotac_logger.call(loggerController))
    ROS_INFO("1s-biotac_logger success status = %ld",loggerController.response.success);
  else
    ROS_INFO("1s-biotac_logger failed");
  usleep(1000000);
  loggerController.request.filename = "startUp";
  loggerController.request.record = 0;
  if(biotac_logger.call(loggerController))
    ROS_INFO("1s-biotac_logger success status = %ld",loggerController.response.success);
  else
    ROS_INFO("1s-biotac_logger failed");
  usleep(1000000);

  //Start matlab server 
  int sockfd = 0, new_fd = 0;
  long int numbytes;  // listen on sock_fd, new connection on new_fd
  char bufrecv[MAXDATASIZE];
  char bufsend[MAXDATASIZE];

  startServer(sockfd, new_fd);
  //SEND initial hand shake to MATLAB to make sure we're talking to the right person
  memset(bufsend, 0, MAXDATASIZE);
  sprintf(bufsend,"HELLO_MATLAB");
  if (send(new_fd, bufsend, MAXDATASIZE, 0) == -1)
    perror("send");
  ROS_INFO("sent: HELLO_MATLAB");
  //RECV initialize communication
  memset(bufrecv, 0, MAXDATASIZE);
  if ((numbytes = recv(new_fd, bufrecv, MAXDATASIZE, 0)) == -1) {
    perror("recv");
  }
  bufrecv[numbytes] = '\0'; 
  unwrapMssg( std::string(bufrecv));
  printf("receivedAck: '%s'\n", bufrecv);

  int currEpisodeActionCounter = 0;
  curr_pose = start_pose;
  while(currLearning) //currEpisode
  {
    bool planAndMove = false;
    memset(bufsend, 0, MAXDATASIZE);
    // [ state, scpReady, scpFilename]
    sprintf(bufsend,"%d %d %s", 1, currEpisodeActionCounter++, "na");
    if (send(new_fd, bufsend, MAXDATASIZE, 0) == -1)
    perror("send");

    //RECV comand
    memset(bufrecv, 0, MAXDATASIZE);
    if ((numbytes = recv(new_fd, bufrecv, MAXDATASIZE, 0)) == -1) {
      perror("recv");
    }
    bufrecv[numbytes] = '\0';
    unwrapMssg( std::string(bufrecv));
    ROS_ERROR("received: '%s'\n", bufrecv);

    currEpisode = true;
    jointTrajectoryMove.request.velocity = 0.005; // 0.02 m/s or 2 cm/s
    //move to test position
    if(actionSpace.compare("getBaseLineAndSetPdc") == 0)
    {
      //start biotac baseline
      std::string episodeFilename;
      episodeFilename = saveFilename;
      episodeFilename.append("_episodeBaseLine");
      loggerController.request.filename = episodeFilename;
      loggerController.request.record = 1;
      cameraActionSender(1,loggerController.request.filename); //Start record
      if(biotac_logger.call(loggerController))
        ROS_INFO("1s-biotac_logger success status = %ld",loggerController.response.success);
      else
        ROS_INFO("1s-biotac_logger failed");
      usleep(250000);

      //set biotacs to desired pdc
      specialService.request.action = "setPdc";
      specialService.request.value1 = 250; //changed to 150 pinch was sticky
      specialService.request.value2 = 0.005; //radians per increment
      if(!special_service.call(specialService))
        ROS_ERROR("setPdc failed");
      else
      ROS_INFO("specialService status - %s", specialService.response.status.c_str());

      //Save baseline biotac
      ROS_WARN("SAVING BASELINE: %s", episodeFilename.c_str());
      loggerController.request.record = 0;
      cameraActionSender(0,loggerController.request.filename); //Stop record
      if(biotac_logger.call(loggerController))
        ROS_INFO("baseline filename = %s",loggerController.response.filename.c_str());
      else
        ROS_INFO("1s-biotac_logger failed");

      //SEND file location to matlab to upload
      memset(bufsend, 0, MAXDATASIZE);
      // [ state, scpReady, scpFilename]
      sprintf(bufsend,"%s", loggerController.response.filename.c_str() );
      if (send(new_fd, bufsend, MAXDATASIZE, 0) == -1)
      perror("send");

    }
    else if(actionSpace.compare("setPdc") == 0)
    { 
      //set biotacs to desired pdc
      specialService.request.action = "setPdc";
      specialService.request.value1 = graspPressure; //changed to 150 pinch was sticky
      specialService.request.value2 = 0.0025; //radians per increment
      if(!special_service.call(specialService))
        ROS_ERROR("setPdc failed");
      else
      ROS_INFO("specialService status - %s", specialService.response.status.c_str());

      //SEND file location to matlab to upload
      memset(bufsend, 0, MAXDATASIZE);
      // [ state, scpReady, scpFilename]
      sprintf(bufsend,"%s", loggerController.response.filename.c_str() );
      if (send(new_fd, bufsend, MAXDATASIZE, 0) == -1)
      perror("send");

    }
    else if(actionSpace.compare("1") == 0)
    { 
      curr_pose.position.x -=  0.7071 * incrementalTravelLength;
      curr_pose.position.z +=  0.7071 * incrementalTravelLength;
      planAndMove = true;
    }
    else if(actionSpace.compare("2") == 0)
    {
      curr_pose.position.x -=  0.9063 * incrementalTravelLength;
      curr_pose.position.z +=  0.4226 * incrementalTravelLength;
      planAndMove = true;
    }
    else if(actionSpace.compare("3") == 0)
    {
      curr_pose.position.x -=  1 * incrementalTravelLength;
      curr_pose.position.z +=  0 * incrementalTravelLength;
      planAndMove = true;
    }
    else if(actionSpace.compare("4") == 0)
    {
      curr_pose.position.x -=  0.7071 * incrementalTravelLength;
      curr_pose.position.z += -0.7071 * incrementalTravelLength; 
      planAndMove = true;        
    }
    else if(actionSpace.compare("5") == 0)
    {
      curr_pose.position.x -=  0.0  * incrementalTravelLength;
      curr_pose.position.z += -1.0 * incrementalTravelLength; 
      planAndMove = true;
    }
    else if(actionSpace.compare("endOfEpisode") == 0)
    {
      curr_pose = start_pose;
      currEpisode = false;
      specialService.request.action = "resetPinch";
      if(!special_service.call(specialService))
        ROS_ERROR("resetPinch failed");
      usleep(1000000);
      planAndMove = true;
      jointTrajectoryMove.request.velocity = 0.015; // 0.02 m/s or 2 cm/s
    }
    else if(actionSpace.compare("endOfLearning") == 0)
    {
      currEpisode  = false;
      currLearning = false;
      break;
    }

    if(planAndMove)
    {
      trajectroyStartPoint.clear();
      trajectroyStartPoint = jointTrajectory.points[jointTrajectory.points.size()-1].positions;
      kinematic_state->setJointGroupPositions(joint_model_group, trajectroyStartPoint);
      group.setStartState(*kinematic_state);
      group.setPoseTarget(curr_pose); //Cartesian position and orientation goal
      
      success = false;
      double planningTimeAdj = 1.0;

      while(!success)
      {
        success = group.plan(my_plan1); //Start planner
        if(!checkJointTravelLimitOk(my_plan1.trajectory_.joint_trajectory))
          success = false; 
      
        if(success)
        {
          current_Traj = my_plan1.trajectory_;
          jointTrajectory = current_Traj.joint_trajectory;

          travelLength = 0;
          travelLength = getEndEffectorTravel( group, jointTrajectory); 

          //Remove tension from bag to help model fit
          /*
          unsigned lengthOfTraj = jointTrajectory.points.size();
          ROS_WARN("size of JointTrajectroy int %u", lengthOfTraj);
          for (int k=0; k< 5; k++)
          {
            jointTrajectory.points.push_back(jointTrajectory.points[(lengthOfTraj-1)-k]);
          }
          lengthOfTraj = jointTrajectory.points.size();
          ROS_WARN("size of JointTrajectroy new %u", lengthOfTraj);
          */

          //Building Joint Trajectory move to be sent to wam_node
          jointTrajectoryMove.request.jointTrajectory = jointTrajectory;

          jointTrajectoryMove.request.length = travelLength; //travel length of end effector
          ROS_INFO("travelLength = %6.4f",travelLength);
                          
   
          //Call to wam_node to run trajectory

          loggerController.request.filename = saveFilename;
          loggerController.request.record = 1;
          if(biotac_logger.call(loggerController))
            ROS_INFO("1s-biotac_logger success status = %ld",loggerController.response.success);
          else
            ROS_INFO("1s-biotac_logger failed");
          cameraActionSender(1, saveFilename); //Start record

          if(joint_trajectory_velocity_move.call(jointTrajectoryMove))
            ROS_INFO("JointTrajectoryVelocityMove success status = %lu",jointTrajectoryMove.response.status);
          else
            ROS_WARN("JointTrajectoryVelocityMove fail");

          loggerController.request.filename = saveFilename;
          loggerController.request.record = 0;
          if(biotac_logger.call(loggerController))
            ROS_INFO("1s-biotac_logger success status = %ld",loggerController.response.success);
          else
            ROS_INFO("1s-biotac_logger failed");
          cameraActionSender(0, saveFilename); //stop record

          //SEND file location to matlab to upload
          memset(bufsend, 0, MAXDATASIZE);
          // [ state, scpReady, scpFilename]
          sprintf(bufsend,"%s", loggerController.response.filename.c_str() );
          if (send(new_fd, bufsend, MAXDATASIZE, 0) == -1)
          perror("send");
        }
        else
        {
          planningTimeAdj++;
          group.setPlanningTime(planningTimeAdj);
          numOfFailures++;

          ROS_WARN("TRAJECTORY PLANNER FAILED: %d, total planning time: %4.2f",numOfFailures, planningTimeAdj);
        }
      }
    }
  }

  cameraActionSender(0,"loggerController.request.filename"); //Stop record just incase stop any camera recording
  loggerController.request.record = -1;
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

  //running = false;

  cameraRequestRecorderThread.interrupt();
  ros::shutdown();  
  return 0;
}

