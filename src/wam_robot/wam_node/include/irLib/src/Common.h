/*!
*	\file	Common.h
*	\date	2016.01.20
*	\author	Keunjun Choi(ckj.monikaru@gmail.com)
*	\brief	General mathematics functions
*/

#pragma once

#include <cmath>

#include "Constant.h"

namespace irLib
{
	namespace irMath
	{
		static VectorX grid(Real start, Real end, unsigned int N)
		{
			VectorX result(N);
			Real delta = (end - start) / (N - 1);
			for (unsigned int i = 0; i < N; i++)
			{
				result(i) = delta*i + start;
			}
			return result;
		}

		/// Calculate sine and cosine simultaneously
		static void fsincos(Real theta, ///< Angle in radians 
			Real& sine, ///< Variable for storing a sine value
			Real& cosine ///< Variable for storing a sine value
			)
		{
			theta -= (int)(theta*Inv_PI_DOUBLE)*PI_DOUBLE;
			if (theta < 0) theta += PI_DOUBLE;

			sine = std::sin(theta);
			if (theta < PI_HALF)
			{
				cosine = std::sqrt(1 - sine*sine);
				return;
			}
			else if (theta < PI + PI_HALF)
			{
				cosine = -std::sqrt(1 - sine*sine);
				return;
			}
			cosine = std::sqrt(1 - sine*sine);
		}

		/// Pseudo-inverse of the matrix
		static MatrixX pInv(const MatrixX& matrix ///< Matrix for inversion
			)
		{
			Eigen::JacobiSVD<MatrixX> svd(matrix, Eigen::ComputeFullU | Eigen::ComputeFullV);
			Real tolerance = RealEps;
			VectorX singular_values = svd.singularValues();
			MatrixX S(matrix.rows(), matrix.cols());
			S.setZero();
			for (int i = 0; i < singular_values.size(); i++)
			{
				if (singular_values(i) > tolerance)
				{
					S(i, i) = 1.0 / singular_values(i);
				}
				else
				{
					S(i, i) = 0;
				}
			}
			return svd.matrixV() * S.transpose() * svd.matrixU().transpose();
		}

		/*!
		*	\brief Absolute value conversion
		*	\return f(x)=\|x\|
		*/
		static Real Abs(const Real& op)
		{
			if (op < 0.0) return -op;
			return op;
		}

		/// Return min value
		static Real Min(const Real& op1, const Real& op2)
		{
			if (op1 < op2)
			{
				return op1;
			}
			return op2;
		}

		/// Return max value
		static Real Max(const Real& op1, const Real& op2)
		{
			if (op1 > op2)
			{
				return op1;
			}
			return op2;
		}

		static bool RealEqual(const Real& op1, const Real& op2)
		{
			if (std::abs(op1 - op2) < RealEps + RealEps*Abs(op1)) return true;
			return false;
		}

		template< typename T >
		static bool RealEqual(const Eigen::MatrixBase<T>& op1, const Real& op2)
		{
			int rows = op1.rows();
			int cols = op1.cols();

			for (int i = 0; i < rows; i++)
			{
				for (int j = 0; j < cols; j++)
				{
					if (!RealEqual(op1(i, j), op2))
					{
						return false;
					}
				}
			}
			return true;
		}

		template< typename T1, typename T2 >
		static bool RealEqual(const Eigen::MatrixBase<T1>& op1, const Eigen::MatrixBase<T2>& op2)
		{
			int rows1 = op1.rows();
			int cols1 = op1.cols();

			int rows2 = op2.rows();
			int cols2 = op2.cols();

			if (!(rows1 == rows2 && cols1 == cols2)) return false;

			for (int i = 0; i < rows1; i++)
			{
				for (int j = 0; j < cols1; j++)
				{
					if (!RealEqual(op1(i, j), op2(i, j)))
					{
						return false;
					}
				}
			}
			return true;
		}

		static bool RealLess(const Real& op1, const Real& op2)
		{
			if (op1 < op2 - RealEps - RealEps*Abs(op1)) return true;
			return false;
		}

		template< typename T >
		static bool RealLess(const Eigen::MatrixBase<T>& op1, const Real& op2)
		{
			int rows = op1.rows();
			int cols = op1.cols();

			for (int i = 0; i < rows; i++)
			{
				for (int j = 0; j < cols; j++)
				{
					if (!RealLess(op1(i, j), op2))
					{
						return false;
					}
				}
			}
			return true;
		}

		static bool RealLessEqual(const Real& op1, const Real& op2)
		{
			if (op1 < op2 + RealEps + RealEps*Abs(op1)) return true;
			return false;
		}

		template< typename T >
		static bool RealLessEqual(const Eigen::MatrixBase<T>& op1, const Real& op2)
		{
			int rows = op1.rows();
			int cols = op1.cols();

			for (int i = 0; i < rows; i++)
			{
				for (int j = 0; j < cols; j++)
				{
					if (!RealLessEqual(op1(i, j), op2))
					{
						return false;
					}
				}
			}
			return true;
		}

		static bool RealBigger(const Real& op1, const Real& op2)
		{
			if (op1 > op2 + RealEps + RealEps*Abs(op1)) return true;
			return false;
		}

		template< typename T >
		static bool RealBigger(const Eigen::MatrixBase<T>& op1, const Real& op2)
		{
			int rows = op1.rows();
			int cols = op1.cols();

			for (int i = 0; i < rows; i++)
			{
				for (int j = 0; j < cols; j++)
				{
					if (!RealBigger(op1(i, j), op2))
					{
						return false;
					}
				}
			}
			return true;
		}

		static bool RealBiggerEqual(const Real& op1, const Real& op2)
		{
			if (op1 > op2 - RealEps - RealEps*Abs(op1)) return true;
			return false;
		}

		template< typename T >
		static bool RealBiggerEqual(const Eigen::MatrixBase<T>& op1, const Real& op2)
		{
			int rows = op1.rows();
			int cols = op1.cols();

			for (int i = 0; i < rows; i++)
			{
				for (int j = 0; j < cols; j++)
				{
					if (!RealBiggerEqual(op1(i, j), op2))
					{
						return false;
					}
				}
			}
			return true;
		}
	}
}