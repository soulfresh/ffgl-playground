cmake_minimum_required(VERSION 3.10)

# Create a compile_commands.json for VIM/ccls
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# TODO Create a symlink to compile_commands.json in the root

set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake
    CACHE STRING "Vcpkg toolchain file")

# set the project name
project(lolpxl VERSION 0.0.1)

# specify the C++ standard
# TODO We should specify 17 for more than just apple
# set(CMAKE_CXX_STANDARD 17)
# set(CMAKE_CXX_STANDARD_REQUIRED True)
IF( APPLE )
  SET( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -stdlib=libc++" )
  SET( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -stdlib=libc++" )
  SET( CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -stdlib=libc++" )
  SET( CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -stdlib=libc++" )
ENDIF( APPLE )

# provide preprocessor environment variables
configure_file(config.h.in config.h)

# add_subdirectory(src)
# add_subdirectory(lib)
add_executable(lolpxl src/main.cpp)

# list(APPEND CMAKE_PREFIX_PATH glm)
set(glm_DIR ${CMAKE_CURRENT_LIST_DIR}/vcpkg/packages/glm_x64-osx/share/glm)
# message("Prefix path: ${CMAKE_PREFIX_PATH}")

# TODO Does vcpkg export a variable for its root directory?
# find_path(GLM_INCLUDE glm.hpp
#   HINTS ${CMAKE_CURRENT_LIST_DIR}/vckpkg/packages/share/glm)
find_package(glm CONFIG REQUIRED)
#
# target_include_directories(lolpxl
#   PRIVATE ${CMAKE_CURRENT_LIST_DIR}/vckpkg/packages/glm_x64-osx/include
# )
target_link_libraries(lolpxl
  PRIVATE glm::glm
)

target_include_directories(lolpxl SYSTEM PRIVATE $ENV{INCLUDE})

# If we run into language server issues with clangd,
# use the following to generate a compile_commands.json file.
# file(INSTALL ${PROJECT_BINARY_DIR}/compile_commands.json DESTINATION ${CMAKE_CURRENT_LIST_DIR})
