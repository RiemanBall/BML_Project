/*
 * Eunsuk Chong 2017.09.18
 */
#include "ros/ros.h"

#include "lib_serial_comm.h"
using namespace std;
void Cserial_comm::print_status(int fd) {
	int status;
	unsigned int arg;
	status = ioctl(fd, TIOCMGET, &arg);
	// The standard error stream is the default destination for error messages and other diagnostic warnings.
	fprintf(stderr, "[STATUS]: ");
	if(arg & TIOCM_RTS) fprintf(stderr, "RTS ");
	if(arg & TIOCM_CTS) fprintf(stderr, "CTS ");
	if(arg & TIOCM_DSR) fprintf(stderr, "DSR ");
	if(arg & TIOCM_CAR) fprintf(stderr, "DCD ");
	if(arg & TIOCM_DTR) fprintf(stderr, "DTR ");
	if(arg & TIOCM_RNG) fprintf(stderr, "RI ");
	fprintf(stderr, "\r\n");
}

int Cserial_comm::connect_serial(){
	struct termios oldtio, newtio;       //place for old and new port settings for serial port
	// TODO: make it automatically detect the name (or make list of devices)
	string devicename_str = SERIAL_DEVICE_NAME;
	char *devicename = &devicename_str[0];
	int need_exit = 0;
	speed_spec speeds[] =
	{
		{"1200", B1200},
		{"2400", B2400},
		{"4800", B4800},
		{"9600", B9600},
		{"19200", B19200},
		{"38400", B38400},
		{"57600", B57600},
		{"115200", B115200},
		{NULL, 0}
	};
	int speed = B115200;

	//m_comfd = open(devicename, O_RDWR(read/write) | O_NOCTTY | O_NONBLOCK);
	m_comfd = open(devicename, O_RDWR | O_NOCTTY);
	if (m_comfd < 0)
	{
		perror(devicename);
		exit(-1);
	}

	//TODO make it selectable
	speed_spec *s;
	for(s = speeds; s->name; s++) {
		if(strcmp(s->name, SERIAL_BOUD_RATE) == 0) {
			speed = s->flag;
			fprintf(stderr, "setting speed %s\n", s->name);
			break;
		}
	}

	fprintf(stderr, "Serial connection succeed..\n");

	tcgetattr(m_comfd, &oldtio); // save current port settings
	newtio.c_cflag = speed | CS8 | CLOCAL | CREAD;
	newtio.c_iflag = IGNPAR;
	newtio.c_oflag = 0;
	newtio.c_lflag = 0;
	newtio.c_cc[VMIN]=1;
	newtio.c_cc[VTIME]=0;
	tcflush(m_comfd, TCIFLUSH);
	tcsetattr(m_comfd, TCSANOW, &newtio);
	print_status(m_comfd);
	tcsetattr(m_comfd, TCSANOW, &oldtio);
	return 1;
}

int Cserial_comm::readBytes(char* buffer, int size_buffer){
	int ret;
	ret = read(m_comfd, buffer, size_buffer);
	//write(STDOUT_FILENO, buffer, ret); // for debug

	return ret;
}

void Cserial_comm::close_serial(){
	close(m_comfd);
}
