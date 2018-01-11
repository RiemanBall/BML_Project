/* Software License Agreement (BSD License)
 *
 * Copyright (c) 2011, Willow Garage, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above
 *    copyright notice, this list of conditions and the following
 *    disclaimer in the documentation and/or other materials provided
 *    with the distribution.
 *  * Neither the name of Willow Garage, Inc. nor the names of its
 *    contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * Auto-generated by gensrv_cpp from file /home/robot/catkin_ws/src/wam_common/wam_msgs/srv/Hold.srv
 *
 */


#ifndef WAM_MSGS_MESSAGE_HOLD_H
#define WAM_MSGS_MESSAGE_HOLD_H

#include <ros/service_traits.h>


#include <wam_msgs/HoldRequest.h>
#include <wam_msgs/HoldResponse.h>


namespace wam_msgs
{

struct Hold
{

typedef HoldRequest Request;
typedef HoldResponse Response;
Request request;
Response response;

typedef Request RequestType;
typedef Response ResponseType;

}; // struct Hold
} // namespace wam_msgs


namespace ros
{
namespace service_traits
{


template<>
struct MD5Sum< ::wam_msgs::Hold > {
  static const char* value()
  {
    return "797a139a4299aebd587b00a7001c67f7";
  }

  static const char* value(const ::wam_msgs::Hold&) { return value(); }
};

template<>
struct DataType< ::wam_msgs::Hold > {
  static const char* value()
  {
    return "wam_msgs/Hold";
  }

  static const char* value(const ::wam_msgs::Hold&) { return value(); }
};


// service_traits::MD5Sum< ::wam_msgs::HoldRequest> should match 
// service_traits::MD5Sum< ::wam_msgs::Hold > 
template<>
struct MD5Sum< ::wam_msgs::HoldRequest>
{
  static const char* value()
  {
    return MD5Sum< ::wam_msgs::Hold >::value();
  }
  static const char* value(const ::wam_msgs::HoldRequest&)
  {
    return value();
  }
};

// service_traits::DataType< ::wam_msgs::HoldRequest> should match 
// service_traits::DataType< ::wam_msgs::Hold > 
template<>
struct DataType< ::wam_msgs::HoldRequest>
{
  static const char* value()
  {
    return DataType< ::wam_msgs::Hold >::value();
  }
  static const char* value(const ::wam_msgs::HoldRequest&)
  {
    return value();
  }
};

// service_traits::MD5Sum< ::wam_msgs::HoldResponse> should match 
// service_traits::MD5Sum< ::wam_msgs::Hold > 
template<>
struct MD5Sum< ::wam_msgs::HoldResponse>
{
  static const char* value()
  {
    return MD5Sum< ::wam_msgs::Hold >::value();
  }
  static const char* value(const ::wam_msgs::HoldResponse&)
  {
    return value();
  }
};

// service_traits::DataType< ::wam_msgs::HoldResponse> should match 
// service_traits::DataType< ::wam_msgs::Hold > 
template<>
struct DataType< ::wam_msgs::HoldResponse>
{
  static const char* value()
  {
    return DataType< ::wam_msgs::Hold >::value();
  }
  static const char* value(const ::wam_msgs::HoldResponse&)
  {
    return value();
  }
};

} // namespace service_traits
} // namespace ros

#endif // WAM_MSGS_MESSAGE_HOLD_H