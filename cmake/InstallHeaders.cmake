foreach(variable SOURCE_DIR DESTINATION)
  if(NOT DEFINED ${variable} OR "${${variable}}" STREQUAL "")
    message(FATAL_ERROR "${variable} is required")
  endif()
endforeach()

file(
  INSTALL "${SOURCE_DIR}/"
  DESTINATION "${DESTINATION}"
  FILES_MATCHING
  PATTERN "*.h")
