cmake_minimum_required(VERSION 3.18)

file(GLOB_RECURSE headers ${CMAKE_CURRENT_LIST_DIR}/*.h ${CMAKE_CURRENT_LIST_DIR}/*.hpp)
file(GLOB_RECURSE sources ${CMAKE_CURRENT_LIST_DIR}/*.cpp)

add_executable(Playground
  ${sources}
  ${PLUGIN_OBJS}
  $<TARGET_OBJECTS:FFGL>
)

target_include_directories(Playground PUBLIC
  ${CMAKE_CURRENT_LIST_DIR}
  # include glfw directly because it is only needed for playgrounds
  ${GLFW_INCLUDE_DIRS}
  ${DEPS_INCLUDE_DIRS}
  ${LIB_INCLUDE_DIRS}
  ${SRC_DIR}
)

target_link_libraries(Playground
  # include glfw directly because it is only needed for playgrounds
  glfw
  # libraries in the /deps folder
  ${DEPS}
  # Local libraries in the /libs folder
  ${LIBS}
  # Other library/dependencies
  ${OPENGL}
)

# Compile options
target_compile_options(Playground PUBLIC ${GLOBAL_COMPILER_FLAGS})
