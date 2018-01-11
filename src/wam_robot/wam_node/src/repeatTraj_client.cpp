#include <ros/ros.h>
#include <wam_msgs/JointTrajectoryVelocityMove.h>
#include <sensor_msgs/JointState.h>
#include <fstream>
#include <string>
#include <vector>
#include <iostream>

#define DOF 7


// class autoRun
// {
// public:
// 	autoRun(void);
// 	autoRunCallback()

// private:
// 	wam_msgs::JointTrajectoryVelocityMove repeat_srv;
// };


// autoRun::autoRun(void)
// {
// 	ros::ServiceClient repeatTraj_client = nh.serviceClient<wam_msgs::JointTrajectoryVelocityMove>("joint_trajectory_velocity_move");
// }



int main(int argc, char**argv)
{
	ros::init(argc, argv, "repeatTraj_client");
	ros::NodeHandle nh;
	//TODO: Make the repeatTraj_client executed automatically 
	// ros::ServiceServer autoRun_server = nh.serviceServer("")
	ros::ServiceClient repeatTraj_client = nh.serviceClient<wam_msgs::JointTrajectoryVelocityMove>("joint_trajectory_velocity_move");

	wam_msgs::JointTrajectoryVelocityMove repeat_srv;
	// request:
	//	trajectory_msgs/JointTrajectory jointTrajectory:
	//		string[] joint_names
	//		JointTrajectoryPoint[] points:
	//			float64[] positions
	//			float64[] velocities
	//			float64[] accelerations
	//			float64[] effort
	//			duration time_from_start
	//	float64 velocity
	//	float64 length
	// response:
	//	int64 status

	std::cout << std::endl << "Process: Read the recorded joint data." << std::endl;
	std::ifstream csvFile("/home/robot/rieman_ws/data/JointVals_rieman.csv");
	std::string line, token;
	std::stringstream sst;
	std::vector<double> recordedData;
	trajectory_msgs::JointTrajectoryPoint JointTrajectoryPoint;

	std::cout << std::endl << "Process: Sparse the recorded joint data." << std::endl;
	while (std::getline(csvFile, line))
	{
		sst << line;
		while(getline(sst, token, ','))
		{
			double dtoken = std::atof(token.c_str());
			recordedData.push_back(dtoken);
		}

		ros::Duration t(recordedData[0]);
		std::vector<double> jointPos(recordedData.begin()+1,recordedData.end());
		JointTrajectoryPoint.time_from_start = t;
		JointTrajectoryPoint.positions = jointPos;

		repeat_srv.request.jointTrajectory.points.push_back(JointTrajectoryPoint);
		
		sst.clear();
		recordedData.clear();
	}

	std::cout << std::endl << "Process: Finish sparsing the recorded joint data." << std::endl;

	repeat_srv.request.velocity = 1;
	repeat_srv.request.length = repeat_srv.request.jointTrajectory.points.rbegin()->time_from_start.toSec() - repeat_srv.request.jointTrajectory.points[0].time_from_start.toSec();	// Type: duration[]. Not finished.

	std::cout << std::endl << "Process: The movement time: " << repeat_srv.request.length << std::endl;

	if (repeatTraj_client.call(repeat_srv))
	{
		ROS_INFO("Finish repeating the recorded WAM movement.");
	}
	else
	{
		ROS_ERROR("Failed to call service joint_trajectory_velocity_move");
		return 1;
	}

	return 0;

}
