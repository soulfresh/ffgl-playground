cmake_minimum_required(VERSION 3.10)

# Create a compile_commands.json for VIM/ccls
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# TODO Create a symlink to compile_commands.json in the root

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

add_subdirectory(src)
add_subdirectory(lib)

# add the executable
# add_executable(lolpxl src/main.cpp)
