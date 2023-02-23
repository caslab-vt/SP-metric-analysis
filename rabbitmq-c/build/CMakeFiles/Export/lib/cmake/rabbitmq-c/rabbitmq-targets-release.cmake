#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "rabbitmq::rabbitmq" for configuration "Release"
set_property(TARGET rabbitmq::rabbitmq APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(rabbitmq::rabbitmq PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/librabbitmq.so.0.12.0"
  IMPORTED_SONAME_RELEASE "librabbitmq.so.4"
  )

list(APPEND _IMPORT_CHECK_TARGETS rabbitmq::rabbitmq )
list(APPEND _IMPORT_CHECK_FILES_FOR_rabbitmq::rabbitmq "${_IMPORT_PREFIX}/lib/librabbitmq.so.0.12.0" )

# Import target "rabbitmq::rabbitmq-static" for configuration "Release"
set_property(TARGET rabbitmq::rabbitmq-static APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(rabbitmq::rabbitmq-static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/librabbitmq.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS rabbitmq::rabbitmq-static )
list(APPEND _IMPORT_CHECK_FILES_FOR_rabbitmq::rabbitmq-static "${_IMPORT_PREFIX}/lib/librabbitmq.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
