cmake_minimum_required(VERSION 3.18)

# Check for Link Time Optimization support
include(CheckIPOSupported)
check_ipo_supported(RESULT ipo_supported OUTPUT error)

set(PLUGINS "")
set(PLUGIN_INCLUDES_DIRS "")
set(PLUGIN_OBJS "")
set(PLUGIN_HEADERS "")
set(PLUGIN_SOURCES "")

###
# Add a new plugin to the build. The name of the folder and
# the output plugin name will be the same. Every plugin is
# built the same way. Plugins are installed in the `/plugins`
# directory on success.
#
# Example:
# add_plugin(MyPluginName)
###
macro(add_plugin name directory)
  # sources for this plugin
  file(GLOB_RECURSE headers ${directory}/*.hpp ${directory}/*.h)
  file(GLOB_RECURSE sources ${directory}/*.cpp)

  # playground for this plugin
  file(GLOB playsource ${directory}/Playground.cpp ${directory}/playground.cpp)

  # remove the playground from the actual plugin bundle compilation
  list(FILTER sources EXCLUDE REGEX "Playground.cpp")
  list(FILTER sources EXCLUDE REGEX "playground.cpp")

  set(includes
    ${DEPS_INCLUDE_DIRS}
    ${LIB_INCLUDE_DIRS}
  )

  if (sources)
    # Build the object files for this plugin which can be reused
    # by the playground.
    set(objects ${name}_OBJS)
    add_library(${objects} OBJECT
      ${sources}
      # Include FFGL as pre-compiled objects.
      # Not sure why I can't get a static lib to work instead.
      # TODO extern plugMain maybe?
      $<TARGET_OBJECTS:FFGL>
    )

    # Build the plugin as a module library.
    add_library(${name} MODULE
      $<TARGET_OBJECTS:${objects}>
      $<TARGET_OBJECTS:FFGL>
    )

    # Use link time optimizations in the release build
    if( ipo_supported AND NOT CMAKE_BUILD_TYPE MATCHES DEBUG)
      set_property(TARGET ${name} PROPERTY INTERPROCEDURAL_OPTIMIZATION TRUE)
    endif()

    # If any .pch files are found in the plugin directory,
    # use those as precompiled headers for the plugin (adding in
    # all headers from the deps folder). Otherwise, reuse the
    # generic .pch generated for /src/pch.cpp
    file(GLOB_RECURSE pchs ${directory}/*.pch)
    if (pchs)
      # Treat any file with a .pch extension as precompiled header list.
      target_precompile_headers(${objects} PUBLIC ${pchs} ${DEPS_HEADERS})
      target_precompile_headers(${name} PUBLIC ${pchs} ${DEPS_HEADERS})
    else()
      # Precompile all headers in deps and libs
      target_precompile_headers(${objects} REUSE_FROM PCH)
      target_precompile_headers(${name} REUSE_FROM PCH)
      # I'm not sure if using the PCH library is any faster than
      # just building on per plugin.
      # target_precompile_headers(${name} PUBLIC ${DEPS_HEADERS})
    endif()


    # Output a bundle file.
    set_target_properties(${name} PROPERTIES BUNDLE TRUE)

    target_include_directories(${objects} PUBLIC ${includes})
    target_include_directories(${name} PUBLIC ${includes})

    # Plugin dependencies
    set(libraries
      # 3rd party libraries from the /deps folder
      ${DEPS}
      # Local libraries in the /libs folder
      ${LIBS}
      # Other library/dependencies
      ${OPENGL}
    )
    target_link_libraries(${objects} ${libraries})
    target_link_libraries(${name} ${libraries})

    # Compile options
    target_compile_options(${objects} PUBLIC ${GLOBAL_COMPILER_FLAGS})
    target_compile_options(${name} PUBLIC ${GLOBAL_COMPILER_FLAGS})

    # Export metadata about this plugin
    list(APPEND PLUGINS ${name})
    list(APPEND PLUGIN_OBJS $<TARGET_OBJECTS:${objects}>)
    list(APPEND PLUGIN_INCLUDE_DIRS ${directory})
    list(APPEND PLUGIN_HEADERS ${headers})
    list(APPEND PLUGIN_SOURCES ${sources})

    # TODO Figure out how to get this to happen even if the build artifacts
    # have not changed. It currently only copies the directories if
    # the bundle dependencies cause a rebuild.
    # Copy plugin to the /plugins directory for easy access.
    # set(bundle_name ${name}.bundle)
    # set(bundle_input ${CMAKE_CURRENT_BINARY_DIR}/${bundle_name})
    # set(bundle_output ${PLUGIN_OUTPUT_DIRECTORY}/${bundle_name})
    #
    # add_custom_command(TARGET ${name} POST_BUILD
    #   COMMAND ${CMAKE_COMMAND} -E copy_directory
    #   ${bundle_input}
    #   ${bundle_output}
    #   COMMENT "Copying ${name} into /plugins..."
    #   VERBATIM
    # )
  else()
    message(WARNING "${name} Plugin folder is empty: ${directory}")
  endif()

  # If there's a playground file for this plugin, compile that.
  if (playsource)
    message(STATUS "Found Playground: ${name}")

    set(playground ${name}Playground)
    add_executable(${playground}
      ${playsource}
      # Reuse plugin object files
      $<TARGET_OBJECTS:${objects}>
      $<TARGET_OBJECTS:FFGL>
    )

    target_include_directories(${playground} PUBLIC
      ${includes}
      # include glfw directly because it is only needed for playgrounds
      ${GLFW_INCLUDE_DIRS}
    )

    target_link_libraries(${playground}
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
    target_compile_options(${playground} PUBLIC ${GLOBAL_COMPILER_FLAGS})
  endif()
endmacro()

###
# Add all folders in the current directory to the cmake build
# as plugins using the folder name as the plugin name.
#
# Example:
# add_all_plugins()
###
macro(add_all_plugins root)
  subdir_list(projects ${root})

  foreach(subdir ${projects})
    message(STATUS "Found Plugin: ${subdir}")
    add_plugin(${subdir} ${root}/${subdir})
  endforeach()
endmacro()
