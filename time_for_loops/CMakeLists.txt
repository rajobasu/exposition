cmake_minimum_required(VERSION 3.10)
project(LoopBenchmarks)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add optimization flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3 -march=native")

message(STATUS "--- CMake Configuration Details ---")
message(STATUS "System: ${CMAKE_SYSTEM_NAME} ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS "Compiler: ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "CXX Standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "CXX Flags: ${CMAKE_CXX_FLAGS}")
message(STATUS "CXX Flags Debug: ${CMAKE_CXX_FLAGS_DEBUG}")
message(STATUS "CXX Flags Release: ${CMAKE_CXX_FLAGS_RELEASE}")
message(STATUS "----------------------------------")

find_package(benchmark REQUIRED)
find_package(GTest REQUIRED)

add_executable(loop_benchmarks loop_benchmarks.cpp)
target_link_libraries(loop_benchmarks benchmark::benchmark)

# If we had tests
# add_executable(tests tests.cpp)
# target_link_libraries(tests GTest::gtest_main)
