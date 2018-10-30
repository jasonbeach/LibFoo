find_package(Git QUIET)

#Split the version string up
string(REPLACE "." ";" LIB_VERSION_LIST ${LIB_VERSION})
list(LENGTH LIB_VERSION_LIST len)

if (${len} GREATER 0)
  list(GET LIB_VERSION_LIST 0 LIB_VERSION_MAJOR)
endif()
if (${len} GREATER 1)
  list(GET LIB_VERSION_LIST 1 LIB_VERSION_MINOR)
endif()
if (${len} GREATER 2)
  list(GET LIB_VERSION_LIST 2 LIB_VERSION_PATCH)
endif()
if (${len} GREATER 3)
  list(GET LIB_VERSION_LIST 3 LIB_VERSION_TWEAK)
endif()

if (GIT_FOUND AND EXISTS "${LIB_PROJECT_SOURCE_DIR}/.git")
  # Working off a git repo, using git versioning

  # this unfortunately doesn't capture changes that have been committed
  # but not pushed 

  # Get hash from last commit
  execute_process (
      COMMAND             "${GIT_EXECUTABLE}" rev-parse HEAD #describe --always
      WORKING_DIRECTORY   "${LIB_PROJECT_SOURCE_DIR}"
      OUTPUT_VARIABLE     GitHash
      OUTPUT_STRIP_TRAILING_WHITESPACE)
  # If the sources have been changed locally, add -dirty to the version.
  execute_process (
      COMMAND             "${GIT_EXECUTABLE}" diff --quiet
      WORKING_DIRECTORY   "${LIB_PROJECT_SOURCE_DIR}"
      RESULT_VARIABLE     res)
  if (res EQUAL 1)
      set (GitHash "${GitHash}-dirty")
  endif()

endif()

configure_file(${LIB_PROJECT_SOURCE_DIR}/cmake/version.cpp.in 
  ${CMAKE_CURRENT_BINARY_DIR}/version.cpp @ONLY)
