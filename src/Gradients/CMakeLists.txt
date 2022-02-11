cmake_minimum_required(VERSION 3.18)

# sources for this plugin
set(sources FFGLGradients.cpp)
set(headers FFGLGradients.h)

# Build the plugin as a module library.
add_library(Gradients MODULE
  ${sources}
  ${headers}
  ${FFGL_SOURCES}
)

# Output a bundle file.
set_target_properties(Gradients PROPERTIES BUNDLE TRUE)
target_include_directories(Gradients PUBLIC
  ${FFGL_INCLUDE_DIRS}
  ${GLM_INCLUDE_DIRS}
)

# TODO I think we also need to generate the plist.
# See: https://stackoverflow.com/a/65928709

# Plugin dependencies
target_link_libraries(Gradients ${OPENGL})

message("PLUGIN_OUTPUT_DIRECTORY: ${PLUGIN_OUTPUT_DIRECTORY}")
message("CMAKE_CURRENT_BINARY_DIR: ${CMAKE_CURRENT_BINARY_DIR}")
# TODO I don't understand why install doesn't work here.
# install(DIRECTORY DESTINATION ${PLUGIN_OUTPUT_DIR}/Gradients.bundle)
# add_custom_command(TARGET Gradients POST_BUILD
#   COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_BIN_DIR}/Gradients.bundle/ ${PLUGIN_OUTPUT_DIRECTORY}
# )
# add_custom_command(TARGET Gradients POST_BUILD
#   COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:Gradients> ${PLUGIN_OUTPUT_DIRECTORY}/Gradients.bundle
# )
# install(TARGETS Gradients DESTINATION ${PLUGIN_OUTPUT_DIRECTORY})
# install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/
#   DESTINATION ${PLUGIN_OUTPUT_DIRECTORY}
# )
