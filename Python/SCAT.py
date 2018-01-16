# The format of the data:
#   time index[1]/quaternion[4]/accelerometer[3]/gyro[3]/magnetometer[3]/joint states[7]
import numpy as np
import math
from pyquaternion import *
from numpy import cos, sin, matrix, array
from numpy.linalg import inv
from scipy.optimize import minimize
import myLibrary as lib

np.seterr(all='raise')


Data = open('/home/parallels/rieman_ws/data/Data2/synDataFile_forearm_arm.csv', 'r')
data = lib.dataProcessing(Data)
forearm = data.s4
arm = data.s5

# Constant setting
SENSOR_NUM = 2
SEGMENT_NUM = 1
CONST_VAR = SENSOR_NUM * 3
TV_VAR = SEGMENT_NUM * 1
VARS_NUM = CONST_VAR + TV_VAR
rLength = SEGMENT_NUM * 3

# Noise parameters
stdDev_init_config = math.radians(20)       # standard deviation of the initial robotic arm configuration
stdDev_init_IMU = math.radians(20)          # standard deviation of the sensor placement
stdDev_measure = math.radians(0.1)          # standard deviation of the measurement noiseT
stdDev_movement = math.radians(1)           # standard deviation of the process noise

k = forearm.num

#
# Optimization:
#
class Opt:
    def residual(self, IMU_readEst, measurement):
        """
        :param IMU_readEst: Quaternion
        :param measurement: Quaternion
        :return: numpy.array 3 x 1
        """
        z = IMU_readEst.inverse * measurement
        return array(2 * z.imaginary).reshape(3, 1)


    def jacob(self, x_est, measurement, tol = 1e-3):
        """
        :param x_est: numpy.matrix (VARS_NUM x 1)
        :param measurement: Quaternion
        :param tol: float
        :return: numpy.array
        """
        xp1 = x_est[:3]
        xp2 = x_est[3:CONST_VAR]
        xj1 = x_est[CONST_VAR:]
        J = np.zeros([rLength, VARS_NUM])
        dr_du_p1 = matrix(np.zeros([3, 4]))
        dr_du_p2 = matrix(np.zeros([3, 4]))
        dr_du_j1 = matrix(np.zeros([3, 4]))
        q_diag1 = [Quaternion(), Quaternion([0, 1, 0, 0]), Quaternion([0, 0, 1, 0]), Quaternion([0, 0, 0, 1])]
        q_diag2 = [Quaternion(), Quaternion([0, -1, 0, 0]), Quaternion([0, 0, -1, 0]), Quaternion([0, 0, 0, -1])]


        for k in xrange(4):
            # IMU placement1
            temp = self.IMUPlacement2_quat.inverse / self.movement_quat * q_diag1[k] * measurement
            dr_du_p1[:, k] = matrix(2 * temp.imaginary).reshape(3,1)

            # Segment Orientation
            temp = self.IMUPlacement2_quat.inverse * q_diag2[k] * self.IMUPlacement1_quat * measurement
            dr_du_j1[:, k] = matrix(2 * temp.imaginary).reshape(3, 1)

            # IMU placement2
            temp = q_diag2[k] / self.movement_quat * self.IMUPlacement1_quat * measurement
            dr_du_p1[:, k] = matrix(2 * temp.imaginary).reshape(3, 1)

        # IMU placement1
        alpha = self.IMUPlacement1_quat.angle + np.pi      # Within (0, 2 * pi)
        if abs(alpha) < tol:
            S = 1/2 - alpha**2 / 48
            C = -1/24 + alpha/960
        else:
            S = sin(alpha/2) / alpha
            C = (cos(alpha/2)/2 - S) / alpha**2

        du_dx = np.row_stack( ( -S/2 * xp1.T,
                                C * xp1 * xp1.T + S * np.eye(len(xp1)) ) )

        J[:, :3] = dr_du_p1 * matrix(du_dx)        # 3x4 * 4x3

        # IMU placement2
        alpha = self.IMUPlacement2_quat.angle + np.pi  # Within (0, 2 * pi)
        if abs(alpha) < tol:
            S = 1 / 2 - alpha ** 2 / 48
            C = -1 / 24 + alpha / 960
        else:
            S = sin(alpha / 2) / alpha
            C = (cos(alpha / 2) / 2 - S) / alpha ** 2

        du_dx = np.row_stack((-S / 2 * xp2.T,
                              C * xp2 * xp2.T + S * np.eye(len(xp2))))

        J[:, 3:CONST_VAR] = dr_du_p2 * matrix(du_dx)  # 3x4 * 4x3

        # Time-varying State: j1
        alpha = self.movement_quat.angle + np.pi      # Within (0, 2 * pi)
        if abs(alpha) < tol:
            S = 1/2 - alpha**2 / 48
            C = -1/24 + alpha/960
        else:
            S = sin(alpha/2) / alpha
            C = (cos(alpha/2)/2 - S) / alpha**2

        du_dx = np.row_stack((-S / 2 * xj1.T,
                              C * xj1 * xj1.T + S * np.eye(len(xj1))))

        J[:, CONST_VAR:] = dr_du_j1 * matrix(du_dx)         # 3x4 * 4x3
        return J


    def configUpdate(self, IMUPlacementEst, movement):
        self.IMUPlacement1_quat = lib.angvec2q(IMUPlacementEst[:3])
        self.IMUPlacement2_quat = lib.angvec2q(IMUPlacementEst[3:])
        self.movement_quat = lib.angvec2q(movement * np.array([-1,0,0]))

        # Update
        segOrient_new = self.IMUPlacement1_quat.inverse * self.movement_quat
        IMURead_new = segOrient_new * self.IMUPlacement2_quat

        return IMURead_new


    def costFun(self, x_est, x_pred, measurement, M, V):
        """
        :param x_est: numpy.matrix      VARS_NUM x 1
        :param x_pred: numpy.matrix     VARS_NUM x 1
        :param measurement: Quaternion
        :param M: numpy.matrix
        :param V: numpy.matrix
        :return: float
        """
        x_est = matrix(x_est).reshape(VARS_NUM, 1)
        self.IMU_readEst = self.configUpdate(x_est[:CONST_VAR], x_est[CONST_VAR:])
        self.r = self.residual(self.IMU_readEst, measurement)

        return 0.5 * (self.r.T * V.I * self.r + (x_est - x_pred).T * M.I * (x_est - x_pred) )


    def gradFun(self, x_est, x_pred, measurement, M, V):
        """
        :param x_est: numpy.matrix      VARS_NUM x 1
        :param x_pred: numpy.matrix     VARS_NUM x 1
        :param measurement: Quaternion
        :param M: numpy.matrix
        :param V: numpy.matrix
        :return: numpy.array
        """
        x_est = matrix(x_est).reshape(VARS_NUM, 1)
        self.J = self.jacob(x_est, measurement)    # 3x6 matrix
        return np.array((self.J.T * V.I * self.r + M.I * (x_est - x_pred)).reshape(1, len(x_pred)))[0]


    def hessianFun(self, x_est, x_pred, measurement, M, V):
        """
        :param x_est: numpy.matrix      VARS_NUM x 1
        :param x_pred: numpy.matrix     VARS_NUM x 1
        :param measurement: Quaternion
        :param M: numpy.matrix
        :param V: numpy.matrix
        :return: numpy.array
        """
        return np.array(self.J.T * V.I * self.J + M.I)


#
# Recursive Estimation: 'trust-exact'
#

#
# Fine Tuning
#

x_est = matrix(np.zeros([VARS_NUM, k + 1]))
# Roughly guess:
# placement1: rotate -25 degree w.r.t. the y-axis
# placement2: rotate -20 degree w.r.t. the z-axis
# angle0 = 0.2
placement1Init = Quaternion(axis=[0.0,1.0,0.0], degrees= -25)
placement2Init = Quaternion(axis=[0.0,0.0,1.0], degrees= -20)
x_est[:,0] = np.array([0.0, math.radians(-25), 0.0, 0.0, 0.0, math.radians(-20), 0.2]).reshape(VARS_NUM, 1)

# M
M_tune = [1, 1]
constM = np.ones(3) * stdDev_init_IMU ** 2
TVM = np.ones(3) * stdDev_init_config ** 2
M = matrix(np.diag(np.concatenate((constM * M_tune[0], TVM * M_tune[1]))))

# W
W_tune = [1e-1, 5e1]
W = matrix(np.diag(np.concatenate((np.ones(3) * W_tune[0], np.ones(3) * W_tune[1]))) * stdDev_movement ** 2)

# V
V = matrix(stdDev_measure ** 2 * np.eye(rLength))


# Test
# print type(jacob(matrix('1;2;3;4;5;6'), Quaternion.random(), Quaternion.random(), Quaternion.random()))
# print costFun(matrix('1;2;3;4;5;6'), matrix('0;1;2;3;4;5'), Quaternion.random(), M, V)
# print gradFun(matrix('1;2;3;4;5;6'), matrix('0;1;2;3;4;5'), Quaternion.random(), M, V)
# print hessianFun(matrix('1;2;3;4;5;6'), matrix('0;1;2;3;4;5'), Quaternion.random(), M, V)
# Test end
opt = Opt()
res = None

for i in xrange(k):
    x_est[:, i+1] = x_est[:, i]
    x_pred = x_est[:, i+1]
    measurement = Quaternion(arm.q[i]).inverse * Quaternion(forearm.q[i])    # Quaterion type

    res = minimize(opt.costFun, x_pred, args = (x_pred, measurement, M, V), method='trust-exact', jac = opt.gradFun,
                   hess = opt.hessianFun, options = {'gtol': 1e-8, 'disp': True})

    x_est[:, i + 1] = res.x.reshape(VARS_NUM, 1)
    M = inv(res.hess) + W

print x_est[:, -1]
print inv(res.hess)