# The format of the data:
#   time index[1]/quaternion[4]/accelerometer[3]/gyro[3]/magnetometer[3]/joint states[7]
import numpy as np
from numpy import cos, sin
from numpy import cross
from scipy.linalg import norm
from scipy.optimize import minimize, least_squares
import myLibrary as lib

np.seterr(all='raise')


def axisFunError(x, g1, g2, n):
    j1 = [cos(x[0]) * cos(x[2]), cos(x[0]) * sin(x[2]), sin(x[0])]
    j2 = [cos(x[1]) * cos(x[3]), cos(x[1]) * sin(x[3]), sin(x[1])]
    error = 0
    if n == 1:
        error = (norm(cross(g1, j1)) - norm(cross(g2, j2)))
    else:
        for i in xrange(n):
            error = error + (norm(cross(g1[i], j1)) - norm(cross(g2[i], j2))) ** 2

    return error


def de_dx(x, g1i, g2i):
    j1 = [cos(x[0]) * cos(x[2]), cos(x[0]) * sin(x[2]), sin(x[0])]
    j2 = [cos(x[1]) * cos(x[3]), cos(x[1]) * sin(x[3]), sin(x[1])]

    normCross1 = norm(cross(g1i, j1))
    normCross2 = norm(cross(g2i, j2))

    if not normCross1 or not normCross2:
        return 0

    df_dj1 = cross(cross(g1i, j1), g1i) / normCross1  # 1x3 array type
    df_dj2 = -cross(cross(g2i, j2), g2i) / normCross2  # 1x3 array type

    dj1_dx = [[-sin(x[0]) * cos(x[2]), 0, -cos(x[0]) * sin(x[2]), 0],
              [-sin(x[0]) * sin(x[2]), 0, cos(x[0]) * cos(x[2]), 0],
              [cos(x[0]), 0, 0, 0]]
    dj2_dx = [[0, -sin(x[1]) * cos(x[3]), 0, -cos(x[1]) * sin(x[3])],
              [0, -sin(x[1]) * sin(x[3]), 0, cos(x[1]) * cos(x[3])],
              [0, cos(x[1]), 0, 0]]

    df_dx = np.dot(df_dj1, dj1_dx) + np.dot(df_dj2, dj2_dx)

    return df_dx


def jacobian(x, g1, g2, n):
    jac = [0, 0, 0, 0]
    dei_dx = 0
    for i in xrange(n):
        if de_dx(x, g1[i], g2[i]) is not 0:     # If it's invalid, do nothing and use the last dei_dx
            dei_dx = de_dx(x, g1[i], g2[i])
        jac = jac + 2 * axisFunError(x, g1[i], g2[i], 1) * dei_dx

    return jac


#####################################################
# Identification of the joint axis of the WAM elbow #
#####################################################
Data_forearm_arm = open('/home/parallels/rieman_ws/data/Data2/synDataFile_forearm_arm.csv', 'r')
data_forearm_arm = lib.dataProcessing(Data_forearm_arm)
forearm = data_forearm_arm.s4
arm = data_forearm_arm.s5

# Optimization
x0_axis = np.array([0, 0, 0, 0])       # [phi1, phi2, theta1, theta2]
n = forearm.num

bnds = [(-np.pi, np.pi), (-np.pi, np.pi), (-np.pi, np.pi), (-np.pi, np.pi)]
opt_axis = {'disp': True, 'maxls': 40, 'gtol': 1e-08, 'eps': 1e-08, 'maxiter': 20000,
       'ftol': 1e-10, 'maxcor': 20, 'maxfun': 20000}

minRes_axis = minimize(axisFunError, x0_axis, args=(forearm.g, arm.g, n), method = 'L-BFGS-B', bounds=bnds,
                       jac = jacobian, options = opt_axis)
x_axis = minRes_axis.x
print "x_axis = ", x_axis

j1 = np.array([cos(x_axis[0]) * cos(x_axis[2]), cos(x_axis[0]) * sin(x_axis[2]), sin(x_axis[0])])
j2 = np.array([cos(x_axis[1]) * cos(x_axis[3]), cos(x_axis[1]) * sin(x_axis[3]), sin(x_axis[1])])

print j1, j2



########################################################
# Identification of the joint axis of the WAM shoulder #
########################################################
Data_arm_base = open('/home/parallels/rieman_ws/data/Data2/synDataFile_arm_base.csv', 'r')
data_arm_base = lib.dataProcessing(Data_arm_base)
base = data_arm_base.s4
arm2 = data_arm_base.s5

# Optimization
x0_axis = np.array([0, 0, 0, 0])       # [phi1, phi2, theta1, theta2]
n = base.num

bnds = [(-np.pi, np.pi), (-np.pi, np.pi), (-np.pi, np.pi), (-np.pi, np.pi)]
opt_axis = {'disp': True, 'maxls': 40, 'gtol': 1e-08, 'eps': 1e-08, 'maxiter': 20000,
       'ftol': 1e-10, 'maxcor': 20, 'maxfun': 20000}

minRes_axis = minimize(axisFunError, x0_axis, args=(base.g, arm2.g, n), method = 'L-BFGS-B', bounds=bnds,
                       jac = jacobian, options = opt_axis)
x_axis = minRes_axis.x
print "x_axis = ", x_axis

j_base = np.array([cos(x_axis[0]) * cos(x_axis[2]), cos(x_axis[0]) * sin(x_axis[2]), sin(x_axis[0])])
j_arm2 = np.array([cos(x_axis[1]) * cos(x_axis[3]), cos(x_axis[1]) * sin(x_axis[3]), sin(x_axis[1])])

print j_base, j_arm2




########################################
# Identification of the joint Position #
########################################
# spacing = 0.01 * np.ones_like(forearm.t)
# spacing[1:] = np.diff(forearm.t)

# -----------Cost Function for BFGS-----------------
def posFunError(x, a1, a2, g1, g2, g1dot, g2dot, n):
    o1 = x[:3]
    o2 = x[3:]
    error = 0
    for i in xrange(n):
            Gamma1 = cross(g1[i], cross(g1[i], o1)) + cross(g1dot[i], o1)
            Gamma2 = cross(g2[i], cross(g2[i], o2)) + cross(g2dot[i], o2)
            error = error + (norm(a1[i] - Gamma1) - norm(a2[i] - Gamma2)) ** 2
    return error

# Jacobain for BFGS
def Jacobian_pos_BFGS(x, a1, a2, g1, g2, g1dot, g2dot, n):
    pass


# -----------Cost Function for LSM-----------------
def posFunError_LSM(x, a1, a2, g1, g2, g1dot, g2dot, n):
    o1 = x[:3]
    o2 = x[3:]
    error = []
    for i in xrange(n):
        Gamma1 = cross(g1[i], cross(g1[i], o1)) + cross(g1dot[i], o1)
        Gamma2 = cross(g2[i], cross(g2[i], o2)) + cross(g2dot[i], o2)
        error.append((norm(a1[i] - Gamma1) - norm(a2[i] - Gamma2)))
    return error

# Jacobain for LSM
def Jacobian_pos_LSM(x, a1, a2, g1, g2, g1dot, g2dot, n):
    o1 = x[:3]
    o2 = x[3:]
    jac = []

    for i in xrange(n):
        Gamma1_T = cross(cross(o1, g1[i]), g1[i]) + cross(o1, g1dot[i])
        Gamma2_T = cross(cross(o2, g2[i]), g2[i]) + cross(o2, g2dot[i])
        Gamma1 = cross(g1[i], cross(g1[i], o1)) + cross(g1dot[i], o1)
        Gamma2 = cross(g2[i], cross(g2[i], o2)) + cross(g2dot[i], o2)

        if not all(a1[i] - Gamma1) or not all(a2[i] - Gamma2):
            jac.append(jac[-1])
            continue

        de_do1 = Gamma1_T * (a1[i] - Gamma1) / norm(a1[i] - Gamma1)
        de_do2 = Gamma2_T * (a2[i] - Gamma2) / norm(a2[i] - Gamma2)
        jac.append(np.append(de_do1, -de_do2))

    return jac


# Using 2nd order approximation:
g1_dot = np.gradient(np.array(forearm.g), 0.01, axis = 0)
g2_dot = np.gradient(np.array(arm.g), 0.01, axis = 0)

x0_pos = np.array([-0.01, -0.1, 0.01, -0.01, 0.1, 0.01])
# x0_pos = np.zeros(6)
# -------------------------------------------------
# Optimization - BFGS
# opt_pos = {'disp': True, 'gtol': 1e-08, 'eps': 1e-10, 'maxiter': 20000,}
# minRes_pos = minimize(posFunError, x0_pos, args=(forearm.a, arm.a, forearm.g, arm.g, g1_dot, g2_dot, n),
#                       method = 'BFGS', options = opt_pos)

# -------------------------------------------------
# Optimization - LSM
minRes_pos = least_squares(posFunError_LSM, x0_pos, #jac = "cs",
                           ftol=1e-10, xtol=1e-10, gtol=1e-10, args = (forearm.a, arm.a, forearm.g, arm.g, g1_dot, g2_dot, n), verbose = 1)
# Result:
# x_pos =  [-0.05874969 -0.1012458  -0.00422982 -0.03907207  0.05574666 -0.01437742]
# o1 = [-0.04632282 -0.10633709 -0.00833806], o2 = [-0.02472166  0.05367818 -0.02993681]


x_pos = minRes_pos.x
print "x_pos = ", x_pos

o1 = x_pos[:3]
o2 = x_pos[3:]

j1 = np.array([0.88487053, -0.36253149, -0.29253217])
j2 = np.array([0.67475704, -0.0972603, -0.73160329])

o1 = o1 - (np.dot(o1, j1))*j1
o2 = o2 - (np.dot(o2, j2))*j2
print o1, o2