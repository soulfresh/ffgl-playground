cmake_minimum_required(VERSION 3.18)

# Check for Link Time Optimization support
include(CheckIPOSupported)
check_ipo_supported(RESULT ipo_supported OUTPUT error)

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

  # Build the plugin as a module library.
  add_library(${name} MODULE
    ${sources}
    # Include FFGL as pre-compiled objects.
    # Not sure why I can't get a static lib to work instead.
    # TODO extern plugMain maybe?
    $<TARGET_OBJECTS:FFGL>
  )

  if (sources)
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
      target_precompile_headers(${name} PUBLIC ${pchs} ${DEPS_HEADERS})
    else()
      # Precompile all headers in deps and libs
      target_precompile_headers(${name} REUSE_FROM PCH)
      # I'm not sure if using the PCH library is any faster than
      # just building on per plugin.
      # target_precompile_headers(${name} PUBLIC ${DEPS_HEADERS})
    endif()


    # Output a bundle file.
    set_target_properties(${name} PROPERTIES BUNDLE TRUE)
    target_include_directories(${name} PUBLIC
      ${CMAKE_CURRENT_LIST_DIR}
      ${DEPS_INCLUDE_DIRS}
      ${LIB_INCLUDE_DIRS}
    )

    # Plugin dependencies
    target_link_libraries(${name}
      # Local libraries in the /libs folder
      ${LIBS}
      # Other library/dependencies
      ${OPENGL}
    )

    # Compile options
    target_compile_options(${name} PUBLIC ${GLOBAL_COMPILER_FLAGS})

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
