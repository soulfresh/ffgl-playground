cmake_minimum_required(VERSION 3.18)

include(cmake/utils.cmake)

# Create a compile_commands.json for VIM/ccls
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# set the project name
project(lolpxl VERSION 0.0.1)

# Compiler flags used for all targets
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

list(APPEND GLOBAL_COMPILER_FLAGS
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
)

IF( APPLE )
  list(APPEND GLOBAL_COMPILER_FLAGS "-stdlib=libc++")
ENDIF( APPLE )

message("CXX Standard: ${CMAKE_CXX_STANDARD}")
message("Compiler Flags: ${GLOBAL_COMPILER_FLAGS}")

# Where to output plugins during development so they can be tested
# in FFGL hosts.
set(PLUGIN_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/plugins)

# Make sure the plugin output directory exists
file(MAKE_DIRECTORY "${PLUGIN_OUTPUT_DIR}")

# Include the subdirectories involved in the build
set(DEPS_DIR ${CMAKE_CURRENT_LIST_DIR}/deps)
set(LIBS_DIR ${CMAKE_CURRENT_LIST_DIR}/libs)
set(SRC_DIR ${CMAKE_CURRENT_LIST_DIR}/src)

# provide preprocessor environment variables
configure_file(config.h.in config.h)

add_subdirectory(deps)
add_subdirectory(lib)
add_subdirectory(src)

if (${LINK_COMPILE_COMMANDS})
  message(STATUS "Linking compile_commands.json")
  # Symlink the commands db for clangd/ccls IDE integrations
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E create_symlink
    ${CMAKE_BINARY_DIR}/compile_commands.json
    ${CMAKE_SOURCE_DIR}/compile_commands.json
  )
endif()

# TODO Not sure if these remaining linker flags are necessary
# LINKER_FLAGS = -framework Carbon -framework AppKit
# TODO Not sure if these remaining compiler flags are necessary
# MACOSX_DEPLOYMENT_TARGET = 10.9

