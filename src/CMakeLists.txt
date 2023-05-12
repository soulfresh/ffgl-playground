cmake_minimum_required(VERSION 3.18)

include(Projects.cmake)

### Pre-compiled Headers ###
# TODO Turning off the generic PCH file for the moment in favor of
# just using .pch files in the plugin folders. Not sure if I'll
# bring this back so leaving the code for now.
# # Create a dummy target so we can generate/use
# # the same precompiled headers for all plugins.
# add_executable(PCH pch.cpp $<TARGET_OBJECTS:FFGL>)
# target_include_directories(PCH PUBLIC ${DEPS_INCLUDE_DIRS})
# target_link_libraries(PCH ${SYSTEM_FRAMEWORKS})
# 
# # Only the `/deps` folder is used in the precompiled
# # headers to avoid any weirdness if the libs change.
# target_precompile_headers(PCH PUBLIC ${DEPS_HEADERS})
# target_compile_options(PCH PUBLIC ${GLOBAL_COMPILER_FLAGS})

### PLUGINS ###
# Get the list of subdirectories that contain plugins to compile.
# This would be any subdirectory other than "playground".
subdir_list(plugin_groups ${CMAKE_CURRENT_LIST_DIR})
list(FILTER plugin_groups EXCLUDE REGEX "playground")

# Generate the build for each plugin found in the plugin groups.
foreach(group ${plugin_groups})
  add_all_plugins(${CMAKE_CURRENT_LIST_DIR}/${group})
endforeach()

### PLAYGROUND ###
add_subdirectory(playground)
