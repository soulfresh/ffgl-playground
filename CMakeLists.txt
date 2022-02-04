cmake_minimum_required(VERSION 3.18)

# Create a compile_commands.json for VIM/ccls
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake
#     CACHE STRING "Vcpkg toolchain file")

# set the project name
project(lolpxl VERSION 0.0.1)

set(DEPS_DIR ${CMAKE_CURRENT_LIST_DIR}/deps)
set(LIBS_DIR ${CMAKE_CURRENT_LIST_DIR}/libs)
set(SRC_DIR ${CMAKE_CURRENT_LIST_DIR}/src)

# specify the C++ standard
# TODO We should specify 17 for more than just apple
# set(CMAKE_CXX_STANDARD 17)
# set(CMAKE_CXX_STANDARD_REQUIRED True)
IF( APPLE )
  list(APPEND CMAKE_CXX_FLAGS "-std=c++17 -stdlib=libc++" )
  list(APPEND CMAKE_EXE_LINKER_FLAGS "-stdlib=libc++" )
  list(APPEND CMAKE_SHARED_LINKER_FLAGS "-stdlib=libc++" )
  list(APPEND CMAKE_MODULE_LINKER_FLAGS "-stdlib=libc++" )
ENDIF( APPLE )

# provide preprocessor environment variables
configure_file(config.h.in config.h)

add_subdirectory(src)
add_subdirectory(lib)
add_subdirectory(deps)

# OpenGL
find_package(OpenGL REQUIRED)

# GLM
# find_package(GLM REQUIRED)
# message(STATUS "GLM included at ${GLM_INCLUDE_DIR}")

message('GLM_INCLUDE_DIR? ${GLM_INCLUDE_DIR}')
# TODO Should this be in src/CMakeLists or should the add_executable command be here?
target_include_directories(lolpxl PUBLIC ${FFGL_INCLUDE_DIR} ${GLM_INCLUDE_DIR})
target_link_libraries(lolpxl PRIVATE ffgl)

####### VCPKG #########

# set(glm_DIR ${CMAKE_CURRENT_LIST_DIR}/vcpkg/packages/glm_x64-osx/share/glm)
# find_package(glm CONFIG REQUIRED)
# target_include_directories(lolpxl SYSTEM PRIVATE $ENV{INCLUDE})
# target_link_libraries(lolpxl PRIVATE glm::glm)


# TODO this fails on a fresh build
# If we run into language server issues with clangd,
# use the following to generate a compile_commands.json file.
file(INSTALL ${PROJECT_BINARY_DIR}/compile_commands.json DESTINATION ${CMAKE_CURRENT_LIST_DIR})
