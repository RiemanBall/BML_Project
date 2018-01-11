; Auto-generated. Do not edit!


(cl:in-package biotac_sensors-msg)


;//! \htmlinclude BioTacHand.msg.html

(cl:defclass <BioTacHand> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (hand_id
    :reader hand_id
    :initarg :hand_id
    :type cl:string
    :initform "")
   (bt_data
    :reader bt_data
    :initarg :bt_data
    :type (cl:vector biotac_sensors-msg:BioTacData)
   :initform (cl:make-array 0 :element-type 'biotac_sensors-msg:BioTacData :initial-element (cl:make-instance 'biotac_sensors-msg:BioTacData)))
   (bt_time
    :reader bt_time
    :initarg :bt_time
    :type biotac_sensors-msg:BioTacTime
    :initform (cl:make-instance 'biotac_sensors-msg:BioTacTime)))
)

(cl:defclass BioTacHand (<BioTacHand>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <BioTacHand>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'BioTacHand)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name biotac_sensors-msg:<BioTacHand> is deprecated: use biotac_sensors-msg:BioTacHand instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <BioTacHand>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader biotac_sensors-msg:header-val is deprecated.  Use biotac_sensors-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'hand_id-val :lambda-list '(m))
(cl:defmethod hand_id-val ((m <BioTacHand>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader biotac_sensors-msg:hand_id-val is deprecated.  Use biotac_sensors-msg:hand_id instead.")
  (hand_id m))

(cl:ensure-generic-function 'bt_data-val :lambda-list '(m))
(cl:defmethod bt_data-val ((m <BioTacHand>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader biotac_sensors-msg:bt_data-val is deprecated.  Use biotac_sensors-msg:bt_data instead.")
  (bt_data m))

(cl:ensure-generic-function 'bt_time-val :lambda-list '(m))
(cl:defmethod bt_time-val ((m <BioTacHand>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader biotac_sensors-msg:bt_time-val is deprecated.  Use biotac_sensors-msg:bt_time instead.")
  (bt_time m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <BioTacHand>) ostream)
  "Serializes a message object of type '<BioTacHand>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'hand_id))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'hand_id))
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'bt_data))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'bt_data))
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'bt_time) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <BioTacHand>) istream)
  "Deserializes a message object of type '<BioTacHand>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'hand_id) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'hand_id) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'bt_data) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'bt_data)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'biotac_sensors-msg:BioTacData))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'bt_time) istream)
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<BioTacHand>)))
  "Returns string type for a message object of type '<BioTacHand>"
  "biotac_sensors/BioTacHand")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'BioTacHand)))
  "Returns string type for a message object of type 'BioTacHand"
  "biotac_sensors/BioTacHand")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<BioTacHand>)))
  "Returns md5sum for a message object of type '<BioTacHand>"
  "d96f900cbfb096d61de125081e11dcab")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'BioTacHand)))
  "Returns md5sum for a message object of type 'BioTacHand"
  "d96f900cbfb096d61de125081e11dcab")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<BioTacHand>)))
  "Returns full string definition for message of type '<BioTacHand>"
  (cl:format cl:nil "Header header~%string hand_id~%biotac_sensors/BioTacData[] bt_data~%biotac_sensors/BioTacTime bt_time~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: biotac_sensors/BioTacData~%string bt_serial~%uint16 bt_position~%uint16 tdc_data~%uint16 tac_data~%uint16 pdc_data~%uint16[22] pac_data~%uint16[19] electrode_data~%~%================================================================================~%MSG: biotac_sensors/BioTacTime~%time frame_start_time~%time frame_end_time~%uint32 tdc_ns_offset~%uint32 tac_ns_offset~%uint32 pdc_ns_offset~%uint32[22] pac_ns_offset~%uint32[19] electrode_ns_offset~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'BioTacHand)))
  "Returns full string definition for message of type 'BioTacHand"
  (cl:format cl:nil "Header header~%string hand_id~%biotac_sensors/BioTacData[] bt_data~%biotac_sensors/BioTacTime bt_time~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: biotac_sensors/BioTacData~%string bt_serial~%uint16 bt_position~%uint16 tdc_data~%uint16 tac_data~%uint16 pdc_data~%uint16[22] pac_data~%uint16[19] electrode_data~%~%================================================================================~%MSG: biotac_sensors/BioTacTime~%time frame_start_time~%time frame_end_time~%uint32 tdc_ns_offset~%uint32 tac_ns_offset~%uint32 pdc_ns_offset~%uint32[22] pac_ns_offset~%uint32[19] electrode_ns_offset~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <BioTacHand>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     4 (cl:length (cl:slot-value msg 'hand_id))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'bt_data) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'bt_time))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <BioTacHand>))
  "Converts a ROS message object to a list"
  (cl:list 'BioTacHand
    (cl:cons ':header (header msg))
    (cl:cons ':hand_id (hand_id msg))
    (cl:cons ':bt_data (bt_data msg))
    (cl:cons ':bt_time (bt_time msg))
))
