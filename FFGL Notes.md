# Questions

- Why does the hostTime jump between the first and second ProcessOpenGL calls?
- What is FFGLLog.SetLogCallback?

# FFGL Notes

## Plugin SubClass
There are multiple options for the base class of your plugins.
1. `CffglPlugin` from `<ffgl/FFGLPluginSDK.h>` - This is a low level base class
  you can extend to create your own plugins.
2. `Plugin` from `<ffglqs/Plugin.h>` - This is a slightly higher level base class.
  It provides the following advantages:
  - A set of default shader uniforms that are automatically included in your shaders.
  - An API for mapping host parameters directly to shader uniforms (including generating
    the code for those uniforms in your shaders).
  - A simpler API for adding host color parameters.
  - A simpler API for getting audio and FFT data to your shaders.
  - An API for including reusable GLSL code snippets in your shaders.
3. `Effect` from `<ffglquickstart/FFGLEffect.h>` ???
4. `Source` from `<ffglquickstart/FFGLSource.h>` ???
5. `Mixxer` from `<ffglquickstart/FFGLMixer.h>` ???

## OpenGL Calls
- Plugins should only change the OpenGL state inside the ProcessGL function.
  Otherwise your plugin can crash the host.

## Parameter types and how to use them

## Viewport Dimensions
- `currentViewport`

## Timing
- Use the hostTime property of your plugin instance

## Debugging
There are two logging options
- `FFGLLog::LogToHost` from `<ffgl/FFGLLog.h>` - This will add logs to the host log
  file. This is useful for debugging information that can be shared by users.
- `Log` from `<ffglex/FFGLUtilities.h>` - This will log to `stdout` and is useful
  for debugging during development.
