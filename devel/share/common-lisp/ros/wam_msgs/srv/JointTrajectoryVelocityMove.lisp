; Auto-generated. Do not edit!


(cl:in-package wam_msgs-srv)


;//! \htmlinclude JointTrajectoryVelocityMove-request.msg.html

(cl:defclass <JointTrajectoryVelocityMove-request> (roslisp-msg-protocol:ros-message)
  ((jointTrajectory
    :reader jointTrajectory
    :initarg :jointTrajectory
    :type trajectory_msgs-msg:JointTrajectory
    :initform (cl:make-instance 'trajectory_msgs-msg:JointTrajectory))
   (velocity
    :reader velocity
    :initarg :velocity
    :type cl:float
    :initform 0.0)
   (length
    :reader length
    :initarg :length
    :type cl:float
    :initform 0.0))
)

(cl:defclass JointTrajectoryVelocityMove-request (<JointTrajectoryVelocityMove-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <JointTrajectoryVelocityMove-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'JointTrajectoryVelocityMove-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name wam_msgs-srv:<JointTrajectoryVelocityMove-request> is deprecated: use wam_msgs-srv:JointTrajectoryVelocityMove-request instead.")))

(cl:ensure-generic-function 'jointTrajectory-val :lambda-list '(m))
(cl:defmethod jointTrajectory-val ((m <JointTrajectoryVelocityMove-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader wam_msgs-srv:jointTrajectory-val is deprecated.  Use wam_msgs-srv:jointTrajectory instead.")
  (jointTrajectory m))

(cl:ensure-generic-function 'velocity-val :lambda-list '(m))
(cl:defmethod velocity-val ((m <JointTrajectoryVelocityMove-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader wam_msgs-srv:velocity-val is deprecated.  Use wam_msgs-srv:velocity instead.")
  (velocity m))

(cl:ensure-generic-function 'length-val :lambda-list '(m))
(cl:defmethod length-val ((m <JointTrajectoryVelocityMove-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader wam_msgs-srv:length-val is deprecated.  Use wam_msgs-srv:length instead.")
  (length m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <JointTrajectoryVelocityMove-request>) ostream)
  "Serializes a message object of type '<JointTrajectoryVelocityMove-request>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'jointTrajectory) ostream)
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'velocity))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'length))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <JointTrajectoryVelocityMove-request>) istream)
  "Deserializes a message object of type '<JointTrajectoryVelocityMove-request>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'jointTrajectory) istream)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'velocity) (roslisp-utils:decode-double-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'length) (roslisp-utils:decode-double-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<JointTrajectoryVelocityMove-request>)))
  "Returns string type for a service object of type '<JointTrajectoryVelocityMove-request>"
  "wam_msgs/JointTrajectoryVelocityMoveRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'JointTrajectoryVelocityMove-request)))
  "Returns string type for a service object of type 'JointTrajectoryVelocityMove-request"
  "wam_msgs/JointTrajectoryVelocityMoveRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<JointTrajectoryVelocityMove-request>)))
  "Returns md5sum for a message object of type '<JointTrajectoryVelocityMove-request>"
  "0b0581f1d30ce47b62376b05a486cd9a")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'JointTrajectoryVelocityMove-request)))
  "Returns md5sum for a message object of type 'JointTrajectoryVelocityMove-request"
  "0b0581f1d30ce47b62376b05a486cd9a")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<JointTrajectoryVelocityMove-request>)))
  "Returns full string definition for message of type '<JointTrajectoryVelocityMove-request>"
  (cl:format cl:nil "trajectory_msgs/JointTrajectory jointTrajectory~%float64 velocity~%float64 length~%~%================================================================================~%MSG: trajectory_msgs/JointTrajectory~%Header header~%string[] joint_names~%JointTrajectoryPoint[] points~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: trajectory_msgs/JointTrajectoryPoint~%# Each trajectory point specifies either positions[, velocities[, accelerations]]~%# or positions[, effort] for the trajectory to be executed.~%# All specified values are in the same order as the joint names in JointTrajectory.msg~%~%float64[] positions~%float64[] velocities~%float64[] accelerations~%float64[] effort~%duration time_from_start~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'JointTrajectoryVelocityMove-request)))
  "Returns full string definition for message of type 'JointTrajectoryVelocityMove-request"
  (cl:format cl:nil "trajectory_msgs/JointTrajectory jointTrajectory~%float64 velocity~%float64 length~%~%================================================================================~%MSG: trajectory_msgs/JointTrajectory~%Header header~%string[] joint_names~%JointTrajectoryPoint[] points~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: trajectory_msgs/JointTrajectoryPoint~%# Each trajectory point specifies either positions[, velocities[, accelerations]]~%# or positions[, effort] for the trajectory to be executed.~%# All specified values are in the same order as the joint names in JointTrajectory.msg~%~%float64[] positions~%float64[] velocities~%float64[] accelerations~%float64[] effort~%duration time_from_start~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <JointTrajectoryVelocityMove-request>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'jointTrajectory))
     8
     8
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <JointTrajectoryVelocityMove-request>))
  "Converts a ROS message object to a list"
  (cl:list 'JointTrajectoryVelocityMove-request
    (cl:cons ':jointTrajectory (jointTrajectory msg))
    (cl:cons ':velocity (velocity msg))
    (cl:cons ':length (length msg))
))
;//! \htmlinclude JointTrajectoryVelocityMove-response.msg.html

(cl:defclass <JointTrajectoryVelocityMove-response> (roslisp-msg-protocol:ros-message)
  ((status
    :reader status
    :initarg :status
    :type cl:integer
    :initform 0))
)

(cl:defclass JointTrajectoryVelocityMove-response (<JointTrajectoryVelocityMove-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <JointTrajectoryVelocityMove-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'JointTrajectoryVelocityMove-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name wam_msgs-srv:<JointTrajectoryVelocityMove-response> is deprecated: use wam_msgs-srv:JointTrajectoryVelocityMove-response instead.")))

(cl:ensure-generic-function 'status-val :lambda-list '(m))
(cl:defmethod status-val ((m <JointTrajectoryVelocityMove-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader wam_msgs-srv:status-val is deprecated.  Use wam_msgs-srv:status instead.")
  (status m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <JointTrajectoryVelocityMove-response>) ostream)
  "Serializes a message object of type '<JointTrajectoryVelocityMove-response>"
  (cl:let* ((signed (cl:slot-value msg 'status)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 18446744073709551616) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <JointTrajectoryVelocityMove-response>) istream)
  "Deserializes a message object of type '<JointTrajectoryVelocityMove-response>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'status) (cl:if (cl:< unsigned 9223372036854775808) unsigned (cl:- unsigned 18446744073709551616))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<JointTrajectoryVelocityMove-response>)))
  "Returns string type for a service object of type '<JointTrajectoryVelocityMove-response>"
  "wam_msgs/JointTrajectoryVelocityMoveResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'JointTrajectoryVelocityMove-response)))
  "Returns string type for a service object of type 'JointTrajectoryVelocityMove-response"
  "wam_msgs/JointTrajectoryVelocityMoveResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<JointTrajectoryVelocityMove-response>)))
  "Returns md5sum for a message object of type '<JointTrajectoryVelocityMove-response>"
  "0b0581f1d30ce47b62376b05a486cd9a")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'JointTrajectoryVelocityMove-response)))
  "Returns md5sum for a message object of type 'JointTrajectoryVelocityMove-response"
  "0b0581f1d30ce47b62376b05a486cd9a")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<JointTrajectoryVelocityMove-response>)))
  "Returns full string definition for message of type '<JointTrajectoryVelocityMove-response>"
  (cl:format cl:nil "int64 status~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'JointTrajectoryVelocityMove-response)))
  "Returns full string definition for message of type 'JointTrajectoryVelocityMove-response"
  (cl:format cl:nil "int64 status~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <JointTrajectoryVelocityMove-response>))
  (cl:+ 0
     8
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <JointTrajectoryVelocityMove-response>))
  "Converts a ROS message object to a list"
  (cl:list 'JointTrajectoryVelocityMove-response
    (cl:cons ':status (status msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'JointTrajectoryVelocityMove)))
  'JointTrajectoryVelocityMove-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'JointTrajectoryVelocityMove)))
  'JointTrajectoryVelocityMove-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'JointTrajectoryVelocityMove)))
  "Returns string type for a service object of type '<JointTrajectoryVelocityMove>"
  "wam_msgs/JointTrajectoryVelocityMove")