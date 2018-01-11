
(cl:in-package :asdf)

(defsystem "biotac_sensors-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :std_msgs-msg
)
  :components ((:file "_package")
    (:file "BioTacHand" :depends-on ("_package_BioTacHand"))
    (:file "_package_BioTacHand" :depends-on ("_package"))
    (:file "BioTacData" :depends-on ("_package_BioTacData"))
    (:file "_package_BioTacData" :depends-on ("_package"))
    (:file "BioTacTime" :depends-on ("_package_BioTacTime"))
    (:file "_package_BioTacTime" :depends-on ("_package"))
  ))