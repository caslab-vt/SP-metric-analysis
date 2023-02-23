# Authors: Giulio Romualdi
# CopyPolicy: Released under the terms of the LGPLv2.1 or later

cmake_minimum_required(VERSION 3.19)

set (CMAKE_CXX_STANDARD 17)

project(OsqpEigen-Example)
include_directories('/usr/local/include/')

find_package(OsqpEigen)
find_package(Eigen3)
find_library(libSimpleAmqpClient REQUIRED)
include_directories(${libSimpleAmqpClient++_INCLUDE_DIRS})
set(LIBS ${LIBS} ${libSimpleAmqpClient++_LIBRARIES})

include_directories(SYSTEM ${EIGEN3_INCLUDE_DIR})
## Add SimpleAMQP library headers ##
#include_directories(/usr/local/include/SimpleAmqpClient)

## Add RabbitMQ library headers ##
#include_directories(/usr/local/include/rabbitmq-c)

target_link_libraries(${PROJECT_NAME}
${EIGEN3_LIBS}
/usr/local/lib/librabbitmq.so
/usr/local/lib/librabbitmq.so.4
/usr/local/lib/librabbitmq.so.0.12.0
/usr/local/lib/libSimpleAmqpClient.so.7
/usr/local/lib/libSimpleAmqpClient.so.7.0.1
${LIBS}
SimpleAmqpClient.7
${Boost_LIBRARIES}
)

#MPCExample
add_executable(OsqpEigen-Example src/MPCExample.cpp)
target_link_libraries(OsqpEigen-Example ${PROJECT_NAME})
#target_link_libraries(OsqpEigen-Example ${LIBS} OsqpEigen::OsqpEigen)
#target_link_libraries(OsqpEigen-Example ${LIBS})

#target_link_libraries(OsqpEigen-Example /usr/local/lib/librabbitmq.so)
#target_link_libraries(OsqpEigen-Example /usr/local/lib/librabbitmq.so.4)
#target_link_libraries(OsqpEigen-Example /usr/local/lib/librabbitmq.so.0.12.0)
#target_link_libraries(OsqpEigen-Example /usr/local/lib/libSimpleAmqpClient.so.7)
#target_link_libraries(OsqpEigen-Example /usr/local/lib/libSimpleAmqpClient.so.7.0.1)
