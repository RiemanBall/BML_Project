#include <iostream>
#include <fstream>
#include <ostream>
#include "ros/ros.h"
#include <sstream>
#include "lib_serial_comm.h"
#include <math.h>
#include <sensor_msgs/JointState.h>
#include <std_msgs/String.h>
//#include "sensor_robot_common.h"
//#include "sensor_robot_list.h"
//#include "client_IMUGlove.h"

#define SIZE_SAVE_BUFFER 50000
#define SIZE_READ_BUFFER 512
#define QUAT_NUM 4
#define ACCEL_NUM 3
#define GYRO_NUM 3
#define MAG_NUM 3
#define DATA_NUM (QUAT_NUM + ACCEL_NUM + GYRO_NUM + MAG_NUM)
#define DATA_LEN 10
#define SYNCHRONIZATION_NUM 2
#define NUM_SENSORS 2
#define DOF 7
#define FILE_NAME "/home/robot/rieman_ws/data/synDataFile_arm_base.csv"
#define DEBUG_MODE true


class synchronizedData
{
public:
	// constructor
	synchronizedData(void);
	// callback function
	void synchronizedCallback(const sensor_msgs::JointState::ConstPtr& wam_joint_state_msg);
	// overload the ostream& operator<< to write the data into .csv file
	// friend std::ostream& operator<< (std::ostream& os, const synchronizedData& synData)
	// {
	// 	os << synData.timestamp;
	// 	std::vector<double>::const_iterator IMU_it = synData.IMU_packet.begin();
	// 	std::vector<double>::const_iterator jntPos_it = synData.jointState.begin();
	// 	for (; IMU_it != synData.IMU_packet.end(); IMU_it++) os << *IMU_it;
	// 	for (; jntPos_it != synData.jointState.end(); jntPos_it++) os << *jntPos_it;
	// 	os << '\n';
		
	// 	return os;
	// }

public:
	bool receive;

private:
	double processData(char *buf);
	std::ofstream dataFile;
	double wallTime[2];
	double timestamp;
	std::string flag;
	std::vector<double> IMU_packet;
	std::vector<double> jointState;
	char serial_buffer[SIZE_SAVE_BUFFER];
	int bufferCnt;
	int bufferCnt_lastRead;
	int packetLen;
	Cserial_comm serial_comm;
};


synchronizedData::synchronizedData(void)
{
	dataFile.open(FILE_NAME);
	dataFile << "arm: w:-3cm;l:31cm;base: w:-11.4cm;l:+0.8cm\n";
	receive = false;
	flag = "None";
	serial_comm.connect_serial();
	memset(serial_buffer, '0', sizeof(char) * SIZE_SAVE_BUFFER);
	bufferCnt = 0;
	bufferCnt_lastRead = 0;
	packetLen = DATA_LEN * NUM_SENSORS * DATA_NUM + SYNCHRONIZATION_NUM;		// SYNCHRONIZATION_NUM: starting and ending character
}

void synchronizedData::synchronizedCallback(const sensor_msgs::JointState::ConstPtr& wam_joint_state_msg)
{
	/*
	 * Open the .csv file with appended function.
	 */
	dataFile.open(FILE_NAME, std::ios::app);

	/*
	 * Get the joint state
	 */
	jointState.clear();
	jointState = wam_joint_state_msg->position;
	// for (int i = 0; i < DOF; i++)
	// 	std::cout << jointState[i] << " ";
	// std::cout << std::endl;

	/*
	 * check status
	 */
	if (wam_joint_state_msg->name.size() == DOF+1)
		flag = wam_joint_state_msg->name[DOF];

	/*
	 *	Make time stamp
	 */
	if (wallTime[0] == 0)
		wallTime[0] = ros::Time::now().toSec();
	wallTime[1] = ros::Time::now().toSec();
	timestamp = wallTime[1] - wallTime[0];


	/*
	 * Get the IMU data
	 */
	// readBytes(char* buffer, int size_buffer) returns the index of the next starting element
	bufferCnt += serial_comm.readBytes(serial_buffer + bufferCnt, SIZE_READ_BUFFER);

	// process when only enough data read
	// should not update last read if there was no reading
	// skip data if too much data read

	bufferCnt_lastRead = std::max(bufferCnt - 2 * (packetLen), bufferCnt_lastRead); // -2*(): move back to last starting point

	// std::cout << "bufferCnt: " << bufferCnt << ", bufferCnt_lastRead: " << bufferCnt_lastRead << std::endl;

	for (int i = 0; i < 10; i++){
		std::cout << serial_buffer[i] << " ";
	}
	std::cout << std::endl;
	
	for ( ; bufferCnt_lastRead+packetLen < bufferCnt; bufferCnt_lastRead++){
		if (serial_buffer[bufferCnt_lastRead] == 'S'){
			if (serial_buffer[bufferCnt_lastRead + packetLen - 1] != '\n') {	// wrong packet: make sure the packet is completed
				std::cout << std::endl << "Incompleted packet" << std::endl;
				receive = false;
				break;
			}
			receive = true;
			IMU_packet.clear();
			for (int i  = 0; i < DATA_NUM * NUM_SENSORS; i++)
				// Transform the char-type quaternion data to float, and then store into IMU_packet.
				// Adding 1 to skip the starting character.
				IMU_packet.push_back(processData(serial_buffer + bufferCnt_lastRead + i * DATA_LEN + 1));
			bufferCnt_lastRead += packetLen - 1; // considering bufferCnt_lastRead++

			if (DEBUG_MODE){
				std::stringstream ss;
				ss <<"[" << timestamp << "]";
				for (int kk = 0; kk < IMU_packet.size(); kk++)
					ss << IMU_packet[kk]<< "/";
				ROS_INFO("[%s]", ss.str().c_str());
			}
		}
		else
			// std::cout << "Where is S?" << std::endl;
			receive = false;
	}

	if (SIZE_SAVE_BUFFER - bufferCnt < SIZE_READ_BUFFER){ // for reusing buffer when almost full
		memcpy(serial_buffer, serial_buffer + bufferCnt_lastRead, std::max(bufferCnt - bufferCnt_lastRead, 0));
		bufferCnt = std::max(bufferCnt - bufferCnt_lastRead, 0);
		bufferCnt_lastRead = 0 ;
	}

	
	std::cout << "IMU_packet.size(): " << IMU_packet.size() << ", Total DATA_NUM: " << DATA_NUM * NUM_SENSORS << ", receive: " << receive << std::endl;

	// Data sequence: time, flag1, q1, a1, g1, m1, q1, a2, g2, m2, joint states
	if (receive == true) {
		/*
		 *	Write the recorded data into the .csv file
		 */
		dataFile << timestamp << ';';
		dataFile << flag;
		// std::vector<double>::const_iterator IMU_it = IMU_packet.begin();
		// std::vector<double>::const_iterator jntPos_it = jointState.begin();
		for (int i = 0; i < IMU_packet.size(); i++) 
			dataFile << ';' << IMU_packet[i];
		for (int i = 0; i < DOF; i++)
			dataFile << ';' << jointState[i];
		dataFile << '\n';
	}
	else
		dataFile << timestamp << '\n';

		dataFile.close();
}


double synchronizedData::processData(char *buf){
	char temp = buf[DATA_LEN];
	buf[DATA_LEN] = 0;		// ending character
	double ret = atof(buf);
	buf[DATA_LEN] = temp;
	return ret;
}


int main(int argc, char **argv)
{
	ros::init(argc, argv, "sensor_IMUGlove");
	ros::NodeHandle n;
	synchronizedData data;
	ros::Subscriber joint_state_sub = n.subscribe("joint_states",1000, &synchronizedData::synchronizedCallback, &data);
	// ros::ServiceClient autoRun_client = n.serviceClient<std_msgs::String>("auto_run_repeat_traj_client");
	ros::Rate loop_rate(100);

	// bool alreadyRun = false;

	while (ros::ok())
	{
		ros::spinOnce();
		// if (data.receive && !alreadyRun)
		// {
		// 	alreadyRun = true;
		// 	if (repeatTraj_client.call(repeat_srv))
		// 	{
		// 		ROS_INFO("Finish repeating the recorded WAM movement.");
		// 	}
		// 	else
		// 	{
		// 		ROS_ERROR("Failed to call service joint_trajectory_velocity_move");
		// 		return 1;
		// 	}
		// }
		loop_rate.sleep();
	}

	return 0;
}
