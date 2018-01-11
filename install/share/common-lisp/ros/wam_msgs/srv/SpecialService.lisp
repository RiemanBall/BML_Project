; Auto-generated. Do not edit!


(cl:in-package wam_msgs-srv)


;//! \htmlinclude SpecialService-request.msg.html

(cl:defclass <SpecialService-request> (roslisp-msg-protocol:ros-message)
  ((action
    :reader action
    :initarg :action
    :type cl:string
    :initform "")
   (command
    :reader command
    :initarg :command
    :type cl:integer
    :initform 0)
   (value1
    :reader value1
    :initarg :value1
    :type cl:float
    :initform 0.0)
   (value2
    :reader value2
    :initarg :value2
    :type cl:float
    :initform 0.0))
)

(cl:defclass SpecialService-request (<SpecialService-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SpecialService-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SpecialService-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name wam_msgs-srv:<SpecialService-request> is deprecated: use wam_msgs-srv:SpecialService-request instead.")))

(cl:ensure-generic-function 'action-val :lambda-list '(m))
(cl:defmethod action-val ((m <SpecialService-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader wam_msgs-srv:action-val is deprecated.  Use wam_msgs-srv:action instead.")
  (action m))

(cl:ensure-generic-function 'command-val :lambda-list '(m))
(cl:defmethod command-val ((m <SpecialService-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader wam_msgs-srv:command-val is deprecated.  Use wam_msgs-srv:command instead.")
  (command m))

(cl:ensure-generic-function 'value1-val :lambda-list '(m))
(cl:defmethod value1-val ((m <SpecialService-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader wam_msgs-srv:value1-val is deprecated.  Use wam_msgs-srv:value1 instead.")
  (value1 m))

(cl:ensure-generic-function 'value2-val :lambda-list '(m))
(cl:defmethod value2-val ((m <SpecialService-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader wam_msgs-srv:value2-val is deprecated.  Use wam_msgs-srv:value2 instead.")
  (value2 m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SpecialService-request>) ostream)
  "Serializes a message object of type '<SpecialService-request>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'action))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'action))
  (cl:let* ((signed (cl:slot-value msg 'command)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'value1))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'value2))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SpecialService-request>) istream)
  "Deserializes a message object of type '<SpecialService-request>"
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'action) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'action) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'command) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'value1) (roslisp-utils:decode-double-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'value2) (roslisp-utils:decode-double-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SpecialService-request>)))
  "Returns string type for a service object of type '<SpecialService-request>"
  "wam_msgs/SpecialServiceRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SpecialService-request)))
  "Returns string type for a service object of type 'SpecialService-request"
  "wam_msgs/SpecialServiceRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SpecialService-request>)))
  "Returns md5sum for a message object of type '<SpecialService-request>"
  "966c6ddf09ea79b559b5427d5af8024f")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SpecialService-request)))
  "Returns md5sum for a message object of type 'SpecialService-request"
  "966c6ddf09ea79b559b5427d5af8024f")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SpecialService-request>)))
  "Returns full string definition for message of type '<SpecialService-request>"
  (cl:format cl:nil "string action~%int32 command~%float64 value1~%float64 value2~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SpecialService-request)))
  "Returns full string definition for message of type 'SpecialService-request"
  (cl:format cl:nil "string action~%int32 command~%float64 value1~%float64 value2~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SpecialService-request>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'action))
     4
     8
     8
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SpecialService-request>))
  "Converts a ROS message object to a list"
  (cl:list 'SpecialService-request
    (cl:cons ':action (action msg))
    (cl:cons ':command (command msg))
    (cl:cons ':value1 (value1 msg))
    (cl:cons ':value2 (value2 msg))
))
;//! \htmlinclude SpecialService-response.msg.html

(cl:defclass <SpecialService-response> (roslisp-msg-protocol:ros-message)
  ((success
    :reader success
    :initarg :success
    :type cl:integer
    :initform 0)
   (response
    :reader response
    :initarg :response
    :type cl:float
    :initform 0.0)
   (status
    :reader status
    :initarg :status
    :type cl:string
    :initform "")
   (bt
    :reader bt
    :initarg :bt
    :type (cl:vector cl:integer)
   :initform (cl:make-array 0 :element-type 'cl:integer :initial-element 0)))
)

(cl:defclass SpecialService-response (<SpecialService-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SpecialService-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SpecialService-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name wam_msgs-srv:<SpecialService-response> is deprecated: use wam_msgs-srv:SpecialService-response instead.")))

(cl:ensure-generic-function 'success-val :lambda-list '(m))
(cl:defmethod success-val ((m <SpecialService-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader wam_msgs-srv:success-val is deprecated.  Use wam_msgs-srv:success instead.")
  (success m))

(cl:ensure-generic-function 'response-val :lambda-list '(m))
(cl:defmethod response-val ((m <SpecialService-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader wam_msgs-srv:response-val is deprecated.  Use wam_msgs-srv:response instead.")
  (response m))

(cl:ensure-generic-function 'status-val :lambda-list '(m))
(cl:defmethod status-val ((m <SpecialService-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader wam_msgs-srv:status-val is deprecated.  Use wam_msgs-srv:status instead.")
  (status m))

(cl:ensure-generic-function 'bt-val :lambda-list '(m))
(cl:defmethod bt-val ((m <SpecialService-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader wam_msgs-srv:bt-val is deprecated.  Use wam_msgs-srv:bt instead.")
  (bt m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SpecialService-response>) ostream)
  "Serializes a message object of type '<SpecialService-response>"
  (cl:let* ((signed (cl:slot-value msg 'success)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'response))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'status))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'status))
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'bt))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let* ((signed ele) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    ))
   (cl:slot-value msg 'bt))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SpecialService-response>) istream)
  "Deserializes a message object of type '<SpecialService-response>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'success) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'response) (roslisp-utils:decode-double-float-bits bits)))
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'status) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'status) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'bt) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'bt)))
    (cl:dotimes (i __ros_arr_len)
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:aref vals i) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296)))))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SpecialService-response>)))
  "Returns string type for a service object of type '<SpecialService-response>"
  "wam_msgs/SpecialServiceResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SpecialService-response)))
  "Returns string type for a service object of type 'SpecialService-response"
  "wam_msgs/SpecialServiceResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SpecialService-response>)))
  "Returns md5sum for a message object of type '<SpecialService-response>"
  "966c6ddf09ea79b559b5427d5af8024f")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SpecialService-response)))
  "Returns md5sum for a message object of type 'SpecialService-response"
  "966c6ddf09ea79b559b5427d5af8024f")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SpecialService-response>)))
  "Returns full string definition for message of type '<SpecialService-response>"
  (cl:format cl:nil "int32 success~%float64 response~%string status~%int32[] bt~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SpecialService-response)))
  "Returns full string definition for message of type 'SpecialService-response"
  (cl:format cl:nil "int32 success~%float64 response~%string status~%int32[] bt~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SpecialService-response>))
  (cl:+ 0
     4
     8
     4 (cl:length (cl:slot-value msg 'status))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'bt) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 4)))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SpecialService-response>))
  "Converts a ROS message object to a list"
  (cl:list 'SpecialService-response
    (cl:cons ':success (success msg))
    (cl:cons ':response (response msg))
    (cl:cons ':status (status msg))
    (cl:cons ':bt (bt msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'SpecialService)))
  'SpecialService-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'SpecialService)))
  'SpecialService-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SpecialService)))
  "Returns string type for a service object of type '<SpecialService>"
  "wam_msgs/SpecialService")