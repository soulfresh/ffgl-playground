cmake_minimum_required(VERSION 3.18)

include(../Projects.cmake)

file(GLOB_RECURSE headers ${CMAKE_CURRENT_LIST_DIR}/*.h ${CMAKE_CURRENT_LIST_DIR}/*.hpp)
file(GLOB_RECURSE sources ${CMAKE_CURRENT_LIST_DIR}/*.cpp)

set(playground "Playground")

add_playground(${playground} ${CMAKE_CURRENT_LIST_DIR} success)

target_sources(${playground} PUBLIC
  ${sources}
)

# Compile options
target_compile_options(${playground} PUBLIC ${GLOBAL_COMPILER_FLAGS})
