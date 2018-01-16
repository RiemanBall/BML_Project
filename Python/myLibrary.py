import numpy as np
from pyquaternion import *
from scipy.linalg import norm
from math import sin, cos

GRAVITY_CONST = 9.80665/1000
D2R = np.pi/180

class Segment:
    def __init__(self):
        self.t = []
        self.state = []
        self.q = []
        self.a = []
        self.g = []
        self.m = []
        self.jt = []
        self.num = 0
        self.Jac = None


class dataProcessing:
    def __init__(self, data):
        self.s4 = Segment()
        self.s5 = Segment()
        self.data = data  # file handle
        timeLength = 1
        stateLength = 1
        quatLength = 4
        accelLength = 3
        gyroLength = 3
        magLength = 3
        jntLength = 7
        self.dataLength = np.cumsum([timeLength, stateLength,
                                     quatLength, accelLength, gyroLength, magLength,
                                     quatLength, accelLength, gyroLength, magLength,
                                     jntLength])

        for line in data:
            words = line.split(';')
            try:  # When ROS started to receive the complete data
                float(words[10])
            except:
                continue

            for i in xrange(len(words)):
                try:
                    words[i] = float(words[i])  # convert str to float
                except:
                    continue

            self.s4.t.append(words[0])
            self.s5.t.append(words[0])
            self.s4.state.append(words[self.dataLength[0]])
            self.s5.state.append(words[self.dataLength[0]])

            self.s4.q.append(words[self.dataLength[1] : self.dataLength[2]])
            self.s4.a.append([GRAVITY_CONST * e for e in words[self.dataLength[2] : self.dataLength[3]]])
            self.s4.g.append([D2R * e for e in words[self.dataLength[3] : self.dataLength[4]]])
            self.s4.m.append(words[self.dataLength[4] : self.dataLength[5]])
            self.s5.q.append(words[self.dataLength[5] : self.dataLength[6]])
            self.s5.a.append([GRAVITY_CONST * e for e in words[self.dataLength[6] : self.dataLength[7]]])
            self.s5.g.append([D2R * e for e in words[self.dataLength[7] : self.dataLength[8]]])
            self.s5.m.append(words[self.dataLength[8] : self.dataLength[9]])

            self.s4.jt.append(words[self.dataLength[-2] : ])
            self.s5.jt.append(words[self.dataLength[-2] : ])
            self.s4.num += 1
            self.s5.num += 1


def angvec2q(x, tol = 1e-3):
    """
    :param x: numpy.matrix 3x1
    :param tol: float
    :return: Quaternion
    """
    x = np.array(x.reshape(1,3))[0]
    alpha = norm(x)

    S = 1/2 - alpha**2 / 48 if alpha < tol else sin(alpha/2) / alpha

    return Quaternion(np.append(np.array([cos(alpha/2)]), x * S))