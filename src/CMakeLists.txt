cmake_minimum_required(VERSION 3.18)

include(Projects.cmake)

### Pre-compiled Headers ###
# Create a dummy target so we can generate/use
# the same precompiled headers for all plugins.
add_executable(PCH pch.cpp $<TARGET_OBJECTS:FFGL>)
target_include_directories(PCH PUBLIC ${DEPS_INCLUDE_DIRS} ${LIB_INCLUDE_DIRS})
target_link_libraries(PCH ${OPENGL})

target_precompile_headers(PCH PUBLIC ${DEPS_HEADERS} ${LIBS_HEADERS})

### PLUGINS ###
# Include the cmake list for each subdirectory.
AddAllPlugins()
