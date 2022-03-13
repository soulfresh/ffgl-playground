cmake_minimum_required(VERSION 3.18)

file(GLOB_RECURSE headers ${CMAKE_CURRENT_LIST_DIR}/*.h ${CMAKE_CURRENT_LIST_DIR}/*.hpp)
file(GLOB_RECURSE sources ${CMAKE_CURRENT_LIST_DIR}/*.cpp)

add_executable(Playground
  ${sources}
  # TODO Not sure if we need FFGL
  $<TARGET_OBJECTS:FFGL>
)

message("DEPS_INCLUDE_DIRS: ${DEPS_INCLUDE_DIRS}")
target_include_directories(Playground PUBLIC
  ${CMAKE_CURRENT_LIST_DIR}
  ${DEPS_INCLUDE_DIRS}
  ${LIB_INCLUDE_DIRS}
)

target_link_libraries(Playground
  # libraries in the /deps folder
  ${DEPS}
  # Local libraries in the /libs folder
  ${LIBS}
  # Other library/dependencies
  ${OPENGL}
)

# Compile options
target_compile_options(Playground PUBLIC ${GLOBAL_COMPILER_FLAGS})
