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
# Build a playground executable for the given directory.
# If no playground.cpp file exists, then the playground build
# is skipped. To find out if a playground was created, pass
# a variable that will be set to TRUE.
###
macro(add_playground name directory success)
  # playground for this plugin
  file(GLOB source ${directory}/Playground.cpp ${directory}/playground.cpp)

  # If there's a playground file for this plugin, compile that.
  if (source)
    message(STATUS "Found Playground: ${name}")
    set(${success} TRUE)

    add_executable(${name}
      ${source}
    )

    target_include_directories(${name} PUBLIC
      ${directory}
      ${PLAYGROUND_DEPS_INCLUDE_DIRS}
      ${DEPS_INCLUDE_DIRS}
      ${LIB_INCLUDE_DIRS}
    )

    target_link_libraries(${name}
      ${PLAYGROUND_DEPS}
      ${DEPS} # deps/ directory
      ${LIBS} # libs/ directory
      ${SYSTEM_FRAMEWORKS}
    )

    # Compile options
    target_compile_options(${name} PUBLIC ${GLOBAL_COMPILER_FLAGS})
  endif()
endmacro()

###
# Add a new plugin to the build. The name of the folder and
# the output plugin name will be the same. Every plugin is
# built the same way. Plugins are installed in the `/plugins`
# directory on success. Any `.pch` files in the plugin folder
# will be used as precompiled headers for the plugin.
#
# Example:
# add_plugin(MyPluginName ./my-plugin)
###
macro(add_plugin name directory)
  # sources for this plugin
  file(GLOB_RECURSE headers ${directory}/*.hpp ${directory}/*.h)
  file(GLOB_RECURSE sources ${directory}/*.cpp)

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
    )

    # Build the plugin as a module library.
    add_library(${name} MODULE
      $<TARGET_OBJECTS:${objects}>
    )

    set_target_properties(${name} PROPERTIES
      LIBRARY_OUTPUT_DIRECTORY "${PLUGIN_OUTPUT_DIRECTORY}"
    )

    # Use link time optimizations in the release build
    if(RELEASE)
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
# TODO Turning this off for now as I think it's better to use
# explicit .pch files
#   else()
#     # Precompile all headers in deps and libs
#     target_precompile_headers(${objects} REUSE_FROM PCH)
#     target_precompile_headers(${name} REUSE_FROM PCH)
#     # I'm not sure if using the PCH library is any faster than
#     # just building on per plugin.
#     # target_precompile_headers(${name} PUBLIC ${DEPS_HEADERS})
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
      ${SYSTEM_FRAMEWORKS}
    )
    
    if (PUBLISH_TO_JUICEBAR)
      target_link_libraries(${name} ${RELEASE_DEPS})
    endif()

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

  set(playground ${name}Playground)
  set(playground_created "")

  # Generate a playground file if it exists.
  add_playground(${playground} ${directory} playground_created)

  # If a playground was generated, add the plugin sources to it.
  if(${playground_created})
    target_sources(${playground} PUBLIC $<TARGET_OBJECTS:${objects}>)
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
