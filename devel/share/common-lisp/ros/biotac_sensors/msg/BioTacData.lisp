; Auto-generated. Do not edit!


(cl:in-package biotac_sensors-msg)


;//! \htmlinclude BioTacData.msg.html

(cl:defclass <BioTacData> (roslisp-msg-protocol:ros-message)
  ((bt_serial
    :reader bt_serial
    :initarg :bt_serial
    :type cl:string
    :initform "")
   (bt_position
    :reader bt_position
    :initarg :bt_position
    :type cl:fixnum
    :initform 0)
   (tdc_data
    :reader tdc_data
    :initarg :tdc_data
    :type cl:fixnum
    :initform 0)
   (tac_data
    :reader tac_data
    :initarg :tac_data
    :type cl:fixnum
    :initform 0)
   (pdc_data
    :reader pdc_data
    :initarg :pdc_data
    :type cl:fixnum
    :initform 0)
   (pac_data
    :reader pac_data
    :initarg :pac_data
    :type (cl:vector cl:fixnum)
   :initform (cl:make-array 22 :element-type 'cl:fixnum :initial-element 0))
   (electrode_data
    :reader electrode_data
    :initarg :electrode_data
    :type (cl:vector cl:fixnum)
   :initform (cl:make-array 19 :element-type 'cl:fixnum :initial-element 0)))
)

(cl:defclass BioTacData (<BioTacData>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <BioTacData>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'BioTacData)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name biotac_sensors-msg:<BioTacData> is deprecated: use biotac_sensors-msg:BioTacData instead.")))

(cl:ensure-generic-function 'bt_serial-val :lambda-list '(m))
(cl:defmethod bt_serial-val ((m <BioTacData>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader biotac_sensors-msg:bt_serial-val is deprecated.  Use biotac_sensors-msg:bt_serial instead.")
  (bt_serial m))

(cl:ensure-generic-function 'bt_position-val :lambda-list '(m))
(cl:defmethod bt_position-val ((m <BioTacData>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader biotac_sensors-msg:bt_position-val is deprecated.  Use biotac_sensors-msg:bt_position instead.")
  (bt_position m))

(cl:ensure-generic-function 'tdc_data-val :lambda-list '(m))
(cl:defmethod tdc_data-val ((m <BioTacData>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader biotac_sensors-msg:tdc_data-val is deprecated.  Use biotac_sensors-msg:tdc_data instead.")
  (tdc_data m))

(cl:ensure-generic-function 'tac_data-val :lambda-list '(m))
(cl:defmethod tac_data-val ((m <BioTacData>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader biotac_sensors-msg:tac_data-val is deprecated.  Use biotac_sensors-msg:tac_data instead.")
  (tac_data m))

(cl:ensure-generic-function 'pdc_data-val :lambda-list '(m))
(cl:defmethod pdc_data-val ((m <BioTacData>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader biotac_sensors-msg:pdc_data-val is deprecated.  Use biotac_sensors-msg:pdc_data instead.")
  (pdc_data m))

(cl:ensure-generic-function 'pac_data-val :lambda-list '(m))
(cl:defmethod pac_data-val ((m <BioTacData>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader biotac_sensors-msg:pac_data-val is deprecated.  Use biotac_sensors-msg:pac_data instead.")
  (pac_data m))

(cl:ensure-generic-function 'electrode_data-val :lambda-list '(m))
(cl:defmethod electrode_data-val ((m <BioTacData>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader biotac_sensors-msg:electrode_data-val is deprecated.  Use biotac_sensors-msg:electrode_data instead.")
  (electrode_data m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <BioTacData>) ostream)
  "Serializes a message object of type '<BioTacData>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'bt_serial))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'bt_serial))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'bt_position)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'bt_position)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'tdc_data)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'tdc_data)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'tac_data)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'tac_data)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'pdc_data)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'pdc_data)) ostream)
  (cl:map cl:nil #'(cl:lambda (ele) (cl:write-byte (cl:ldb (cl:byte 8 0) ele) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) ele) ostream))
   (cl:slot-value msg 'pac_data))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:write-byte (cl:ldb (cl:byte 8 0) ele) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) ele) ostream))
   (cl:slot-value msg 'electrode_data))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <BioTacData>) istream)
  "Deserializes a message object of type '<BioTacData>"
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'bt_serial) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'bt_serial) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'bt_position)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'bt_position)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'tdc_data)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'tdc_data)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'tac_data)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'tac_data)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'pdc_data)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'pdc_data)) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'pac_data) (cl:make-array 22))
  (cl:let ((vals (cl:slot-value msg 'pac_data)))
    (cl:dotimes (i 22)
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:aref vals i)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:aref vals i)) (cl:read-byte istream))))
  (cl:setf (cl:slot-value msg 'electrode_data) (cl:make-array 19))
  (cl:let ((vals (cl:slot-value msg 'electrode_data)))
    (cl:dotimes (i 19)
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:aref vals i)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:aref vals i)) (cl:read-byte istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<BioTacData>)))
  "Returns string type for a message object of type '<BioTacData>"
  "biotac_sensors/BioTacData")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'BioTacData)))
  "Returns string type for a message object of type 'BioTacData"
  "biotac_sensors/BioTacData")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<BioTacData>)))
  "Returns md5sum for a message object of type '<BioTacData>"
  "23cbcbcbf4470cc3c87ecb98037f4bb0")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'BioTacData)))
  "Returns md5sum for a message object of type 'BioTacData"
  "23cbcbcbf4470cc3c87ecb98037f4bb0")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<BioTacData>)))
  "Returns full string definition for message of type '<BioTacData>"
  (cl:format cl:nil "string bt_serial~%uint16 bt_position~%uint16 tdc_data~%uint16 tac_data~%uint16 pdc_data~%uint16[22] pac_data~%uint16[19] electrode_data~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'BioTacData)))
  "Returns full string definition for message of type 'BioTacData"
  (cl:format cl:nil "string bt_serial~%uint16 bt_position~%uint16 tdc_data~%uint16 tac_data~%uint16 pdc_data~%uint16[22] pac_data~%uint16[19] electrode_data~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <BioTacData>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'bt_serial))
     2
     2
     2
     2
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'pac_data) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 2)))
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'electrode_data) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 2)))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <BioTacData>))
  "Converts a ROS message object to a list"
  (cl:list 'BioTacData
    (cl:cons ':bt_serial (bt_serial msg))
    (cl:cons ':bt_position (bt_position msg))
    (cl:cons ':tdc_data (tdc_data msg))
    (cl:cons ':tac_data (tac_data msg))
    (cl:cons ':pdc_data (pdc_data msg))
    (cl:cons ':pac_data (pac_data msg))
    (cl:cons ':electrode_data (electrode_data msg))
))
