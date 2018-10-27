cmake_minimum_required(VERSION 3.8)
project(foo VERSION 1.0.0 LANGUAGES CXX)

#Make sure that custom modules like FindRapidJSON are found
list(INSERT CMAKE_MODULE_PATH 0 ${CMAKE_SOURCE_DIR}/cmake)

##############################################
# Declare dependencies
#find_package(Boost 1.55 REQUIRED COMPONENTS regex)
#find_package(RapidJSON 1.0 REQUIRED MODULE)

##############################################

add_library(foolib 
  src/foo.cpp
)

#Add an alias so that library can be used inside the build tree, e.g. when testing
add_library(FooLib::FooLib ALIAS foolib)

#Set target properties
target_include_directories(foolib
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
#    PRIVATE
#        ${CMAKE_CURRENT_SOURCE_DIR}/src
)

target_compile_features(foolib PRIVATE cxx_std_11)

# link dependencies
#target_link_libraries(foolib
#    PUBLIC
#        Boost::boost RapidJSON::RapidJSON
#    PRIVATE
#        Boost::regex
#)

##############################################
# Installation instructions
include(GNUInstallDirs)
set(INSTALL_CONFIGDIR ${CMAKE_INSTALL_LIBDIR}/cmake/foolib)

install(TARGETS foolib EXPORT FooLibTargets
 LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
 ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
 RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
 INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDESDIR}
 )

#This is required so that the exported target has the name FooLib and not FooLib
set_target_properties(foolib PROPERTIES EXPORT_NAME FooLib)

install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

install(EXPORT FooLibTargets
  FILE FooLibTargets.cmake
  NAMESPACE FooLib:: 
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/foolib
   
  )

#Create a ConfigVersion.cmake file
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/FooLibConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
)

configure_package_config_file(${CMAKE_CURRENT_LIST_DIR}/cmake/FooLibConfig.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/FooLibConfig.cmake
    INSTALL_DESTINATION ${INSTALL_CONFIGDIR}
)

#Install the config, configversion and custom find modules
install(FILES
#    ${CMAKE_CURRENT_LIST_DIR}/cmake/FindRapidJSON.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/FooLibConfig.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/FooLibConfigVersion.cmake
    DESTINATION ${INSTALL_CONFIGDIR}
)

##############################################
## Exporting from the build tree
#configure_file(${CMAKE_CURRENT_LIST_DIR}/cmake/FindRapidJSON.cmake
#    ${CMAKE_CURRENT_BINARY_DIR}/FindRapidJSON.cmake
#    COPYONLY)

#export(EXPORT jsonutils-targets 
#  FILE ${CMAKE_CURRENT_BINARY_DIR}/JSONUtilsTargets.cmake 
#  NAMESPACE JSONUtils::)

##Register package in user's package registry
#export(PACKAGE JSONUtils)








# find_package(Git QUIET)

# if (GIT_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.git")
#   # Working off a git repo, using git versioning

#   # Get version from last tag
#   execute_process (
#       COMMAND             "${GIT_EXECUTABLE}" describe --always# | sed -e "s:v::"
#       WORKING_DIRECTORY   "${PROJECT_SOURCE_DIR}"
#       OUTPUT_VARIABLE     NNG_PACKAGE_VERSION
#       OUTPUT_STRIP_TRAILING_WHITESPACE)

#   # If the sources have been changed locally, add -dirty to the version.
#   execute_process (
#       COMMAND             "${GIT_EXECUTABLE}" diff --quiet
#       WORKING_DIRECTORY   "${PROJECT_SOURCE_DIR}"
#       OUTPUT_FILE <diff file>
#       RESULT_VARIABLE     res)
#   if (res EQUAL 1)
#       set (NNG_PACKAGE_VERSION "${NNG_PACKAGE_VERSION}-dirty")
#   endif()

# endif()







#target_compile_features(Foo PRIVATE cxx_constexpr) # could be a specific feature

#target_compile_options(Foo PRIVATE $<$<CXX_COMPILER_ID:GNU>:-Wall -Wextra -Wpedantic>)
#target_compile_options(Foo PRIVATE $<$<CONFIG:DEBUG>:-Wall -Wextra -Wpedantic>)
#target_compile_options(Foo PRIVATE $<$<CONFIG:RELEASE>:-Wall -Wextra -Wpedantic -O3>)