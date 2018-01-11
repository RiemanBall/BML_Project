#define SERIAL_DEVICE_NAME "/dev/ttyACM0"
#define SERIAL_BOUD_RATE "115200"

#include <termios.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/signal.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <errno.h>

typedef struct {char *name; int flag; } speed_spec;

class Cserial_comm{

public:
	Cserial_comm(){
		m_comfd = 0;
	};
	~Cserial_comm(){
		close_serial();
	};

	int readBytes(char* buffer, int size_buffer);
	void print_status(int fd);
	int connect_serial();
	void close_serial();

	int get_comfd()	{return m_comfd;};

private:
	int m_comfd;
};
