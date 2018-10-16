cmake_minimum_required(VERSION 3.8)
project(foo VERSION 1.0.0 LANGUAGES CXX)

add_library(Foo src/foo.cpp)

message (STATUS "cmake current source dir: ${CMAKE_CURRENT_SOURCE_DIR}||")

target_include_directories(Foo
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
#    PRIVATE
#        ${CMAKE_CURRENT_SOURCE_DIR}/src
)

target_compile_features(Foo PRIVATE cxx_std_11)
#target_compile_features(Foo PRIVATE cxx_constexpr) # could be a specific feature

#target_compile_options(Foo PRIVATE $<$<CXX_COMPILER_ID:GNU>:-Wall -Wextra -Wpedantic>)
#target_compile_options(Foo PRIVATE $<$<CONFIG:DEBUG>:-Wall -Wextra -Wpedantic>)
#target_compile_options(Foo PRIVATE $<$<CONFIG:RELEASE>:-Wall -Wextra -Wpedantic -O3>)