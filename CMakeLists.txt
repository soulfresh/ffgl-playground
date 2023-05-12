cmake_minimum_required(VERSION 3.18)

include(cmake/utils.cmake)

# Create a compile_commands.json for VIM/ccls
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# This needs to be configured before the first `project()` call.
# set(CMAKE_OSX_ARCHITECTURES arm64 x86_64) # Generate a multi-arch build
# Temporarily turn off multi-arch builds because they are not supported by Juicebar.
set(CMAKE_OSX_ARCHITECTURES x86_64)
set(CMAKE_OSX_DEPLOYMENT_TARGET "11.6" CACHE STRING "Minimum OS X deployment version" FORCE)

# set the project name
project(lolpxl)

# Compiler flags used for all targets
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

if (CMAKE_BUILD_TYPE MATCHES Debug)
  message("---------------------------")
  message("!!      DEBUG build      !!")
  message("===========================")
  add_definitions(-DDEBUG)
  set(DEBUG true)
  set(RELEASE false)
else()
  message("---------------------------")
  message("!!     RELEASE build     !!")
  message("===========================")
  add_definitions(-DRELEASE)
  set(DEBUG false)
  set(RELEASE true)
endif()

if (RELEASE)
  # Default to using juicebar for release builds
  set(juicebar_default ON)
else()
  # Turn off juicebar by default for debug builds
  set(juicebar_default OFF)
endif()

OPTION(
  PUBLISH_TO_JUICEBAR
  "Whether or not the current build is intended for publishing to Juicebar"
  ${juicebar_default}
)

if(PUBLISH_TO_JUICEBAR)
  message("-- Publishing > Juicebar --")
  message("---------------------------")
  add_definitions(-DPUBLISH_TO_JUICEBAR)
endif()

# Allows us to set OS specific system wide frameworks/libraries that need to be
# used in the build products
set(SYSTEM_FRAMEWORKS)

if( APPLE )
  list(APPEND GLOBAL_COMPILER_FLAGS
    "-stdlib=libc++"
    # Apple deprecates functions without providing alternatives. We want to
    # use deprecated functions for as long as possible. This will cause the
    # bulk of the update work to be moved to the point where the functions are
    # actually removed. But updating is only done when it's safe to do so and
    # when a function has finally been removed it has been deprecated for the
    # longest possible time so the likelyhood of a correctly functioning alternative
    # is better than updating sooner.
      "-Wno-deprecated"
    # Unused variables may happen in subclasses overriding virtual functions.
    # It's not an option to remove the variable names or
    # have them commented out because this breaks the ability to scan
    # through code without reading it as it's much more common that variable
    # names are present in their normal form so that's what readers expect the most.
     "-Wno-unused-variable"
    # Having to handle every tiny little warning is annoying, but having this
    # disabled will result in warnings building up to a point where new warnings
    # cannot be recognised anymore and thus issues will seep into the code.
    "-Werror"
    # Tell GLFW that we're using GL core features only (extensions are not
    # supported on OSX)
    "-DGLFW_INCLUDE_GLCOREARB"
  )

  # These seem to be added automatically but keeping the comment for documentation.
  # find_library(APPKIT AppKit REQUIRED)
  # find_library(CARBON Carbon REQUIRED)
  # list(APPEND SYSTEM_FRAMEWORKS ${APPKIT} ${CARBON})
elseif( WIN32 )
  list(APPEND GLOBAL_COMPILER_FLAGS
    # Tell GLEW that we're linking against a static library
    # (prebuilt in the ffgl/deps folder)
    "-DGLEW_STATIC"
  )
endif()

message("CXX Standard: ${CMAKE_CXX_STANDARD}")
message("Compiler Flags: ${GLOBAL_COMPILER_FLAGS}")

# Where to output plugins during development so they can be tested
# in FFGL hosts.
set(PLUGIN_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/plugins)

# Optimization to speed up PCH file genaration
set(CMAKE_PCH_INSTANTIATE_TEMPLATES ON)

# Make sure the plugin output directory exists
file(MAKE_DIRECTORY "${PLUGIN_OUTPUT_DIR}")

# System libraries that need to be loaded before the /deps folder
find_library(OPENGL OpenGL REQUIRED NAMES opengl OpenGL opengl32)
list(APPEND SYSTEM_FRAMEWORKS ${OPENGL})

# Include the subdirectories involved in the build
set(DEPS_DIR ${CMAKE_CURRENT_LIST_DIR}/deps)
set(LIBS_DIR ${CMAKE_CURRENT_LIST_DIR}/libs)
set(SRC_DIR ${CMAKE_CURRENT_LIST_DIR}/src)

# Ensure that files like config.h are available.
# include_directories("${PROJECT_BINARY_DIR}")

add_subdirectory(deps)
add_subdirectory(lib)
add_subdirectory(src)

# Generate a compile_commands.json file that can be used for IDE autocompletion.
if (${LINK_COMPILE_COMMANDS})
  message(STATUS "Linking compile_commands.json")
  # Symlink the commands db for clangd/ccls IDE integrations
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E create_symlink
    ${CMAKE_BINARY_DIR}/compile_commands.json
    ${CMAKE_SOURCE_DIR}/compile_commands.json
  )
endif()

