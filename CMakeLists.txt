cmake_minimum_required(VERSION 3.8)
project(FooLib VERSION 5.3.7.2 LANGUAGES CXX)

#Make sure that custom modules like FindRapidJSON are found
list(INSERT CMAKE_MODULE_PATH 0 ${CMAKE_SOURCE_DIR}/cmake)

##############################################
# Declare dependencies
#find_package(Boost 1.55 REQUIRED COMPONENTS regex)
#find_package(RapidJSON 1.0 REQUIRED MODULE)

##############################################

add_library(FooLib 
  src/foo.cpp
#  ${CMAKE_CURRENT_BINARY_DIR}/version.cpp
)

#Add an alias so that library can be used inside the build tree, e.g. when testing
add_library(FooLib::FooLib ALIAS FooLib)

#set_source_files_properties(${CMAKE_CURRENT_BINARY_DIR}/version.cpp PROPERTIES GENERATED TRUE)

include(${CMAKE_SOURCE_DIR}/cmake/GetGitRevisionDescription.cmake)

get_git_head_revision(RS HSH)

message(STATUS "refspec: ${RS} Hash: ${HSH}")


git_describe(GIT_DES)
message(STATUS "git describe: ${GIT_DES}")



git_local_changes(LOCAL_CHANGES)
message(STATUS "git local changes: ${LOCAL_CHANGES}")

# #########################################
# # Get git version / commit information
# add_custom_target(version_cpp
#     COMMAND ${CMAKE_COMMAND} -DLIB_VERSION=${PROJECT_VERSION} -DLIB_PROJECT_SOURCE_DIR=${PROJECT_SOURCE_DIR} -P ${CMAKE_SOURCE_DIR}/cmake/git_info.cmake
# )

# # Force executable to be compiled after regeneration takes a place
# add_dependencies(FooLib version_cpp)
# #########################################

#Set target properties
target_include_directories(FooLib
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
#    PRIVATE
#        ${CMAKE_CURRENT_SOURCE_DIR}/src
)

target_compile_features(FooLib PRIVATE cxx_std_11 cxx_raw_string_literals)

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

install(TARGETS FooLib EXPORT FooLibTargets
 LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
 ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
 RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
 INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDESDIR}
 )

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


















#target_compile_features(Foo PRIVATE cxx_constexpr) # could be a specific feature

#target_compile_options(Foo PRIVATE $<$<CXX_COMPILER_ID:GNU>:-Wall -Wextra -Wpedantic>)
#target_compile_options(Foo PRIVATE $<$<CONFIG:DEBUG>:-Wall -Wextra -Wpedantic>)
#target_compile_options(Foo PRIVATE $<$<CONFIG:RELEASE>:-Wall -Wextra -Wpedantic -O3>)