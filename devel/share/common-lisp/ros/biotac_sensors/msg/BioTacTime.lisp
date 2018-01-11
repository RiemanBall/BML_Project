; Auto-generated. Do not edit!


(cl:in-package biotac_sensors-msg)


;//! \htmlinclude BioTacTime.msg.html

(cl:defclass <BioTacTime> (roslisp-msg-protocol:ros-message)
  ((frame_start_time
    :reader frame_start_time
    :initarg :frame_start_time
    :type cl:real
    :initform 0)
   (frame_end_time
    :reader frame_end_time
    :initarg :frame_end_time
    :type cl:real
    :initform 0)
   (tdc_ns_offset
    :reader tdc_ns_offset
    :initarg :tdc_ns_offset
    :type cl:integer
    :initform 0)
   (tac_ns_offset
    :reader tac_ns_offset
    :initarg :tac_ns_offset
    :type cl:integer
    :initform 0)
   (pdc_ns_offset
    :reader pdc_ns_offset
    :initarg :pdc_ns_offset
    :type cl:integer
    :initform 0)
   (pac_ns_offset
    :reader pac_ns_offset
    :initarg :pac_ns_offset
    :type (cl:vector cl:integer)
   :initform (cl:make-array 22 :element-type 'cl:integer :initial-element 0))
   (electrode_ns_offset
    :reader electrode_ns_offset
    :initarg :electrode_ns_offset
    :type (cl:vector cl:integer)
   :initform (cl:make-array 19 :element-type 'cl:integer :initial-element 0)))
)

(cl:defclass BioTacTime (<BioTacTime>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <BioTacTime>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'BioTacTime)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name biotac_sensors-msg:<BioTacTime> is deprecated: use biotac_sensors-msg:BioTacTime instead.")))

(cl:ensure-generic-function 'frame_start_time-val :lambda-list '(m))
(cl:defmethod frame_start_time-val ((m <BioTacTime>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader biotac_sensors-msg:frame_start_time-val is deprecated.  Use biotac_sensors-msg:frame_start_time instead.")
  (frame_start_time m))

(cl:ensure-generic-function 'frame_end_time-val :lambda-list '(m))
(cl:defmethod frame_end_time-val ((m <BioTacTime>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader biotac_sensors-msg:frame_end_time-val is deprecated.  Use biotac_sensors-msg:frame_end_time instead.")
  (frame_end_time m))

(cl:ensure-generic-function 'tdc_ns_offset-val :lambda-list '(m))
(cl:defmethod tdc_ns_offset-val ((m <BioTacTime>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader biotac_sensors-msg:tdc_ns_offset-val is deprecated.  Use biotac_sensors-msg:tdc_ns_offset instead.")
  (tdc_ns_offset m))

(cl:ensure-generic-function 'tac_ns_offset-val :lambda-list '(m))
(cl:defmethod tac_ns_offset-val ((m <BioTacTime>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader biotac_sensors-msg:tac_ns_offset-val is deprecated.  Use biotac_sensors-msg:tac_ns_offset instead.")
  (tac_ns_offset m))

(cl:ensure-generic-function 'pdc_ns_offset-val :lambda-list '(m))
(cl:defmethod pdc_ns_offset-val ((m <BioTacTime>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader biotac_sensors-msg:pdc_ns_offset-val is deprecated.  Use biotac_sensors-msg:pdc_ns_offset instead.")
  (pdc_ns_offset m))

(cl:ensure-generic-function 'pac_ns_offset-val :lambda-list '(m))
(cl:defmethod pac_ns_offset-val ((m <BioTacTime>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader biotac_sensors-msg:pac_ns_offset-val is deprecated.  Use biotac_sensors-msg:pac_ns_offset instead.")
  (pac_ns_offset m))

(cl:ensure-generic-function 'electrode_ns_offset-val :lambda-list '(m))
(cl:defmethod electrode_ns_offset-val ((m <BioTacTime>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader biotac_sensors-msg:electrode_ns_offset-val is deprecated.  Use biotac_sensors-msg:electrode_ns_offset instead.")
  (electrode_ns_offset m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <BioTacTime>) ostream)
  "Serializes a message object of type '<BioTacTime>"
  (cl:let ((__sec (cl:floor (cl:slot-value msg 'frame_start_time)))
        (__nsec (cl:round (cl:* 1e9 (cl:- (cl:slot-value msg 'frame_start_time) (cl:floor (cl:slot-value msg 'frame_start_time)))))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 0) __nsec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __nsec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __nsec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __nsec) ostream))
  (cl:let ((__sec (cl:floor (cl:slot-value msg 'frame_end_time)))
        (__nsec (cl:round (cl:* 1e9 (cl:- (cl:slot-value msg 'frame_end_time) (cl:floor (cl:slot-value msg 'frame_end_time)))))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 0) __nsec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __nsec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __nsec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __nsec) ostream))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'tdc_ns_offset)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'tdc_ns_offset)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'tdc_ns_offset)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'tdc_ns_offset)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'tac_ns_offset)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'tac_ns_offset)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'tac_ns_offset)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'tac_ns_offset)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'pdc_ns_offset)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'pdc_ns_offset)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'pdc_ns_offset)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'pdc_ns_offset)) ostream)
  (cl:map cl:nil #'(cl:lambda (ele) (cl:write-byte (cl:ldb (cl:byte 8 0) ele) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) ele) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) ele) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) ele) ostream))
   (cl:slot-value msg 'pac_ns_offset))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:write-byte (cl:ldb (cl:byte 8 0) ele) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) ele) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) ele) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) ele) ostream))
   (cl:slot-value msg 'electrode_ns_offset))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <BioTacTime>) istream)
  "Deserializes a message object of type '<BioTacTime>"
    (cl:let ((__sec 0) (__nsec 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 0) __nsec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __nsec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __nsec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __nsec) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'frame_start_time) (cl:+ (cl:coerce __sec 'cl:double-float) (cl:/ __nsec 1e9))))
    (cl:let ((__sec 0) (__nsec 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 0) __nsec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __nsec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __nsec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __nsec) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'frame_end_time) (cl:+ (cl:coerce __sec 'cl:double-float) (cl:/ __nsec 1e9))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'tdc_ns_offset)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'tdc_ns_offset)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'tdc_ns_offset)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'tdc_ns_offset)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'tac_ns_offset)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'tac_ns_offset)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'tac_ns_offset)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'tac_ns_offset)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'pdc_ns_offset)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'pdc_ns_offset)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'pdc_ns_offset)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'pdc_ns_offset)) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'pac_ns_offset) (cl:make-array 22))
  (cl:let ((vals (cl:slot-value msg 'pac_ns_offset)))
    (cl:dotimes (i 22)
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:aref vals i)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:aref vals i)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:aref vals i)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:aref vals i)) (cl:read-byte istream))))
  (cl:setf (cl:slot-value msg 'electrode_ns_offset) (cl:make-array 19))
  (cl:let ((vals (cl:slot-value msg 'electrode_ns_offset)))
    (cl:dotimes (i 19)
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:aref vals i)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:aref vals i)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:aref vals i)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:aref vals i)) (cl:read-byte istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<BioTacTime>)))
  "Returns string type for a message object of type '<BioTacTime>"
  "biotac_sensors/BioTacTime")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'BioTacTime)))
  "Returns string type for a message object of type 'BioTacTime"
  "biotac_sensors/BioTacTime")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<BioTacTime>)))
  "Returns md5sum for a message object of type '<BioTacTime>"
  "f8d8b5e140ed0958883d472dc8acc1dc")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'BioTacTime)))
  "Returns md5sum for a message object of type 'BioTacTime"
  "f8d8b5e140ed0958883d472dc8acc1dc")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<BioTacTime>)))
  "Returns full string definition for message of type '<BioTacTime>"
  (cl:format cl:nil "time frame_start_time~%time frame_end_time~%uint32 tdc_ns_offset~%uint32 tac_ns_offset~%uint32 pdc_ns_offset~%uint32[22] pac_ns_offset~%uint32[19] electrode_ns_offset~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'BioTacTime)))
  "Returns full string definition for message of type 'BioTacTime"
  (cl:format cl:nil "time frame_start_time~%time frame_end_time~%uint32 tdc_ns_offset~%uint32 tac_ns_offset~%uint32 pdc_ns_offset~%uint32[22] pac_ns_offset~%uint32[19] electrode_ns_offset~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <BioTacTime>))
  (cl:+ 0
     8
     8
     4
     4
     4
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'pac_ns_offset) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 4)))
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'electrode_ns_offset) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 4)))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <BioTacTime>))
  "Converts a ROS message object to a list"
  (cl:list 'BioTacTime
    (cl:cons ':frame_start_time (frame_start_time msg))
    (cl:cons ':frame_end_time (frame_end_time msg))
    (cl:cons ':tdc_ns_offset (tdc_ns_offset msg))
    (cl:cons ':tac_ns_offset (tac_ns_offset msg))
    (cl:cons ':pdc_ns_offset (pdc_ns_offset msg))
    (cl:cons ':pac_ns_offset (pac_ns_offset msg))
    (cl:cons ':electrode_ns_offset (electrode_ns_offset msg))
))
