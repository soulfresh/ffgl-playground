cmake_minimum_required(VERSION 3.18)

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

    # Precompile all headers in deps and libs
    target_precompile_headers(${name} REUSE_FROM PCH)
    # I'm not sure if using the PCH library is any faster than
    # just building on per plugin.
    # target_precompile_headers(${name} PUBLIC ${DEPS_HEADERS} ${LIB_HEADERS})

    # Output a bundle file.
    set_target_properties(${name} PROPERTIES BUNDLE TRUE)
    target_include_directories(${name} PUBLIC
      ${DEPS_INCLUDE_DIRS}
      ${LIB_INCLUDE_DIRS}
    )

    # Plugin dependencies
    target_link_libraries(${name}
      ${OPENGL}
    )

    # Install the generated plugin to the local plugins directory
    install(TARGETS ${name} DESTINATION ${PLUGIN_OUTPUT_DIRECTORY})
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
