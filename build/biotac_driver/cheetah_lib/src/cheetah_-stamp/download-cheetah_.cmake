message(STATUS "downloading...
     src='http://csc.kth.se/~fevb/downloads/cheetah-library-v3.05.zip'
     dst='/home/robot/rieman_ws/build/biotac_driver/cheetah_lib/download/cheetah-library-v3.05.zip'
     timeout='none'")

file(DOWNLOAD
  "http://csc.kth.se/~fevb/downloads/cheetah-library-v3.05.zip"
  "/home/robot/rieman_ws/build/biotac_driver/cheetah_lib/download/cheetah-library-v3.05.zip"
  SHOW_PROGRESS
  # no EXPECTED_MD5
  # no TIMEOUT
  STATUS status
  LOG log)

list(GET status 0 status_code)
list(GET status 1 status_string)

if(NOT status_code EQUAL 0)
  message(FATAL_ERROR "error: downloading 'http://csc.kth.se/~fevb/downloads/cheetah-library-v3.05.zip' failed
  status_code: ${status_code}
  status_string: ${status_string}
  log: ${log}
")
endif()

message(STATUS "downloading... done")
