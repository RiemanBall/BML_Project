; Auto-generated. Do not edit!


(cl:in-package wam_msgs-srv)


;//! \htmlinclude LoggerInfo-request.msg.html

(cl:defclass <LoggerInfo-request> (roslisp-msg-protocol:ros-message)
  ((filename
    :reader filename
    :initarg :filename
    :type cl:string
    :initform "")
   (record
    :reader record
    :initarg :record
    :type cl:integer
    :initform 0))
)

(cl:defclass LoggerInfo-request (<LoggerInfo-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <LoggerInfo-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'LoggerInfo-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name wam_msgs-srv:<LoggerInfo-request> is deprecated: use wam_msgs-srv:LoggerInfo-request instead.")))

(cl:ensure-generic-function 'filename-val :lambda-list '(m))
(cl:defmethod filename-val ((m <LoggerInfo-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader wam_msgs-srv:filename-val is deprecated.  Use wam_msgs-srv:filename instead.")
  (filename m))

(cl:ensure-generic-function 'record-val :lambda-list '(m))
(cl:defmethod record-val ((m <LoggerInfo-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader wam_msgs-srv:record-val is deprecated.  Use wam_msgs-srv:record instead.")
  (record m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <LoggerInfo-request>) ostream)
  "Serializes a message object of type '<LoggerInfo-request>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'filename))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'filename))
  (cl:let* ((signed (cl:slot-value msg 'record)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 18446744073709551616) signed)))
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
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <LoggerInfo-request>) istream)
  "Deserializes a message object of type '<LoggerInfo-request>"
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'filename) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'filename) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'record) (cl:if (cl:< unsigned 9223372036854775808) unsigned (cl:- unsigned 18446744073709551616))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<LoggerInfo-request>)))
  "Returns string type for a service object of type '<LoggerInfo-request>"
  "wam_msgs/LoggerInfoRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'LoggerInfo-request)))
  "Returns string type for a service object of type 'LoggerInfo-request"
  "wam_msgs/LoggerInfoRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<LoggerInfo-request>)))
  "Returns md5sum for a message object of type '<LoggerInfo-request>"
  "eb0a32cef2eda0200685d2350c3cd9c4")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'LoggerInfo-request)))
  "Returns md5sum for a message object of type 'LoggerInfo-request"
  "eb0a32cef2eda0200685d2350c3cd9c4")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<LoggerInfo-request>)))
  "Returns full string definition for message of type '<LoggerInfo-request>"
  (cl:format cl:nil "string filename~%int64 record~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'LoggerInfo-request)))
  "Returns full string definition for message of type 'LoggerInfo-request"
  (cl:format cl:nil "string filename~%int64 record~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <LoggerInfo-request>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'filename))
     8
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <LoggerInfo-request>))
  "Converts a ROS message object to a list"
  (cl:list 'LoggerInfo-request
    (cl:cons ':filename (filename msg))
    (cl:cons ':record (record msg))
))
;//! \htmlinclude LoggerInfo-response.msg.html

(cl:defclass <LoggerInfo-response> (roslisp-msg-protocol:ros-message)
  ((success
    :reader success
    :initarg :success
    :type cl:integer
    :initform 0)
   (filename
    :reader filename
    :initarg :filename
    :type cl:string
    :initform ""))
)

(cl:defclass LoggerInfo-response (<LoggerInfo-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <LoggerInfo-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'LoggerInfo-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name wam_msgs-srv:<LoggerInfo-response> is deprecated: use wam_msgs-srv:LoggerInfo-response instead.")))

(cl:ensure-generic-function 'success-val :lambda-list '(m))
(cl:defmethod success-val ((m <LoggerInfo-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader wam_msgs-srv:success-val is deprecated.  Use wam_msgs-srv:success instead.")
  (success m))

(cl:ensure-generic-function 'filename-val :lambda-list '(m))
(cl:defmethod filename-val ((m <LoggerInfo-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader wam_msgs-srv:filename-val is deprecated.  Use wam_msgs-srv:filename instead.")
  (filename m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <LoggerInfo-response>) ostream)
  "Serializes a message object of type '<LoggerInfo-response>"
  (cl:let* ((signed (cl:slot-value msg 'success)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 18446744073709551616) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) unsigned) ostream)
    )
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'filename))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'filename))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <LoggerInfo-response>) istream)
  "Deserializes a message object of type '<LoggerInfo-response>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'success) (cl:if (cl:< unsigned 9223372036854775808) unsigned (cl:- unsigned 18446744073709551616))))
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'filename) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'filename) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<LoggerInfo-response>)))
  "Returns string type for a service object of type '<LoggerInfo-response>"
  "wam_msgs/LoggerInfoResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'LoggerInfo-response)))
  "Returns string type for a service object of type 'LoggerInfo-response"
  "wam_msgs/LoggerInfoResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<LoggerInfo-response>)))
  "Returns md5sum for a message object of type '<LoggerInfo-response>"
  "eb0a32cef2eda0200685d2350c3cd9c4")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'LoggerInfo-response)))
  "Returns md5sum for a message object of type 'LoggerInfo-response"
  "eb0a32cef2eda0200685d2350c3cd9c4")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<LoggerInfo-response>)))
  "Returns full string definition for message of type '<LoggerInfo-response>"
  (cl:format cl:nil "int64 success~%string filename~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'LoggerInfo-response)))
  "Returns full string definition for message of type 'LoggerInfo-response"
  (cl:format cl:nil "int64 success~%string filename~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <LoggerInfo-response>))
  (cl:+ 0
     8
     4 (cl:length (cl:slot-value msg 'filename))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <LoggerInfo-response>))
  "Converts a ROS message object to a list"
  (cl:list 'LoggerInfo-response
    (cl:cons ':success (success msg))
    (cl:cons ':filename (filename msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'LoggerInfo)))
  'LoggerInfo-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'LoggerInfo)))
  'LoggerInfo-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'LoggerInfo)))
  "Returns string type for a service object of type '<LoggerInfo>"
  "wam_msgs/LoggerInfo")