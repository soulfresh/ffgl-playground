cmake_minimum_required(VERSION 3.18)

include(cmake/utils.cmake)

# Create a compile_commands.json for VIM/ccls
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# set the project name
project(lolpxl VERSION 0.0.1)

set(DEPS_DIR ${CMAKE_CURRENT_LIST_DIR}/deps)
set(LIBS_DIR ${CMAKE_CURRENT_LIST_DIR}/libs)
set(SRC_DIR ${CMAKE_CURRENT_LIST_DIR}/src)

# Where to output plugins during development so they can be tested
# in FFGL hosts.
set(PLUGIN_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/plugins)

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

add_subdirectory(deps)
add_subdirectory(lib)
add_subdirectory(src)

# Symlink the commands db for clangd/ccls IDE integrations
execute_process(
  COMMAND ${CMAKE_COMMAND} -E create_symlink
  ${CMAKE_BINARY_DIR}/compile_commands.json
  ${CMAKE_SOURCE_DIR}/compile_commands.json
)

# TODO These linker flags need to be set:
# LINKER_FLAGS = -framework OpenGL -framework Carbon -framework AppKit

# TODO These compilation flags need to be set:
# MACOSX_DEPLOYMENT_TARGET = 10.9
# USE_HEADERMAP = NO
# CLANG_CXX_LANGUAGE_STANDARD = c++17
# CLANG_CXX_LIBRARY = libc++
# ALWAYS_SEARCH_USER_PATHS = NO
# CLANG_WARN_DOCUMENTATION_COMMENTS = NO
# //Unused variables may happen in subclasses overriding virtual functions. It's not an option to remove the variable names or
# //have them commented out because this breaks the ability to scan through code without reading it as
# //it's much more common that variable names are present in their normal form so that's what readers expect the most.
# GCC_WARN_UNUSED_VARIABLE = NO
# //Having to handle every tiny little warning is annoying, but having this disabled will result
# //in warnings building up to a point where new warnings cannot be recognised anymore and thus issues
# //will seep into the code.
# GCC_TREAT_WARNINGS_AS_ERRORS = YES
# //Apple deprecates functions without providing alternatives. We want to use deprecated functions
# //for as long as possible. This will cause the bulk of the update work to be moved to the point where
# //the functions are actually removed. But updating is only done when it's safe to do so and when a function
# //has finally been removed it has been deprecated for the longest possible time so the likelyhood of a
# //correctly functioning alternative is better than updating sooner.
# GCC_WARN_ABOUT_DEPRECATED_FUNCTIONS = NO
