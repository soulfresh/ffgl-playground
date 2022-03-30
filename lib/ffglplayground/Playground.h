#pragma once

#include <FFGLSDK.h>

#include "imgui/imgui.h"
#include "imgui/backends/imgui_impl_glfw.h"
#include "imgui/backends/imgui_impl_opengl3.h"

// TODO I think this might be Mac only
#define GLFW_INCLUDE_GLCOREARB
// TODO Can we use debug if this is setup?
#define GLFW_INCLUDE_GLEXT
#include <GLFW/glfw3.h>

#include <functional>
#include "lolpxl/gl/FBO.h"

namespace ffglplayground {
  class FFGLPlayground {
    public:
      FFGLPlayground(int width = 640, int height = 480, char const * title = "FFGL Playground");

      void initUI(std::function<void()> callback);
      void initUI();
      void initGL(std::function<void(double time)> callback);
      void initGL();
      void preRender(std::function<void(double time)> callback);
      void preRender();
      void renderGL(std::function<void(double time, int width, int height)> callback);
      void postRender(std::function<void()> callback);
      void postRender();
      int releaseGL(std::function<void()> callback);
      int releaseGL();

      bool isRunning();

      void onKey(GLFWwindow* window, int key, int scancode, int action, int mods);

    private:
      int width;
      int height;
      char const* title;
      GLFWwindow* window;
  };
};
