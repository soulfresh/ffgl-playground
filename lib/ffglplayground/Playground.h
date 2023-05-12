#pragma once

#include <FFGLSDK.h>

#include "imgui/imgui.h"
#include "imgui/backends/imgui_impl_glfw.h"
#include "imgui/backends/imgui_impl_opengl3.h"

#include <GLFW/glfw3.h>

#include <functional>
#include <glm/glm.hpp>
#include "lolpxl/gl/FBO.h"

using namespace glm;

namespace ffglplayground {
  class FFGLPlayground {
    public:
      FFGLPlayground(int width = 640, int height = 480, char const * title = "FFGL Playground", vec3 bgColor = vec3(0.0f, 0.0f, 0.0f));

      void initUI(std::function<void()> callback);
      void initUI();
      void initGL(std::function<void(double time, int width, int height)> callback);
      void initGL();
      void preRender(std::function<void(double time)> callback);
      void preRender();
      void renderGL(std::function<void(double time, int width, int height)> callback);
      void postRender(std::function<void()> callback);
      void postRender();
      int releaseGL(std::function<void()> callback);
      int releaseGL();

      double getTime();

      bool isRunning();

      void onKey(GLFWwindow* window, int key, int scancode, int action, int mods);

    private:
      bool initialized = false;
      double startTime;
      int width;
      int height;
      char const* title;
      GLFWwindow* window;
      vec3 bgColor;
  };
};
