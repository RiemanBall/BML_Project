from scipy.optimize import minimize, rosen, rosen_der, rosen_hess, least_squares
import numpy as np
from pyquaternion import *
import myLibrary as lib
import math
from scipy import linalg

x0 = np.matrix([13, 7, 0.8, 1.9, 1.2])

def rosen_der2(x):
    xm = x[1:-1]
    xm_m1 = x[:-2]
    xm_p1 = x[2:]
    der = np.zeros_like(x)
    der[1:-1] = 200*(xm-xm_m1**2) - 400*(xm_p1 - xm**2)*xm - 2*(1-xm)
    der[0] = -400*x[0]*(x[1]-x[0]**2) - 2*(1-x[0])
    der[-1] = 200*(x[-1]-x[-2]**2)
    return der

def rosen_hess2(x):
    x = np.asarray(x)
    H = np.diag(-400*x[:-1],1) - np.diag(400*x[:-1],-1)
    diagonal = np.zeros_like(x)
    diagonal[0] = 1200*x[0]**2-400*x[1]+2
    diagonal[-1] = 200
    diagonal[1:-1] = 202 + 1200*x[1:-1]**2 - 400*x[2:]
    H = H + np.diag(diagonal)
    return H


# res = minimize(rosen, x0, method='trust-exact',
#                jac=rosen_der2, hess=rosen_hess2,
#                options={'gtol': 1e-8, 'disp': True})


x = np.array([-0.66713455, -0.30572948, 0.83774167, 0.21853993, 0.07874575, -0.33009986])
q_const = lib.angvec2q(x[:3])
q_TV = lib.angvec2q(x[3:])

print type(q_TV), type(x)

if type(x) is np.ndarray:
    print "Y"

if type(q_TV) == type(Quaternion()):
    print "Y"