#include "Playground.h"
#include "ffglex/FFGLUtilities.h"
#include "lolpxl/gl/FBO.h"
#include "lolpxl/gl/debug.h"
#include <iostream>

using namespace std;

static void error_callback(int error, const char* description)
{
  fprintf(stderr, "Error: %s\n", description);
}

static void key_callback(GLFWwindow* window, int key, int scancode, int action, int mods)
{
  if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
    glfwSetWindowShouldClose(window, GLFW_TRUE);
  }
}

static double getNow() {
  auto duration = std::chrono::system_clock::now().time_since_epoch();
  return std::chrono::duration_cast<std::chrono::milliseconds>(duration).count();
}

namespace ffglplayground {
  FFGLPlayground::FFGLPlayground(int width, int height, char const * title, vec3 bgColor) :
    width(width),
    height(height),
    title(title),
    bgColor(bgColor)
  {
    startTime = getNow();

    ffglex::Log("Initializing GL Resources");
    glfwSetErrorCallback(error_callback);

    if (!glfwInit()) {
      ffglex::Log("Unable to initialize GLFW. See https://www.glfw.org/docs/latest/group__init.html#ga317aac130a235ab08c6db0834907d85e");
      exit(EXIT_FAILURE);
    }

    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 1);
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    glfwWindowHint(GLFW_OPENGL_DEBUG_CONTEXT, GLFW_TRUE);
    glfwWindowHint(GLFW_SAMPLES, 4);

    window = glfwCreateWindow(width, height, title, NULL, NULL);

    if (!window) {
      ffglex::Log("Unable to create window. See https://www.glfw.org/docs/latest/group__window.html#ga3555a418df92ad53f917597fe2f64aeb");
      glfwTerminate();
      exit(EXIT_FAILURE);
    }

    glfwSetKeyCallback(window, key_callback);

    // Other callbacks we might want to add. See jgl
    // glfwSetWindowUserPointer(glWindow, window);
    // glfwSetKeyCallback(glWindow, on_key_callback);
    // glfwSetScrollCallback(glWindow, on_scroll_callback);
    // glfwSetWindowSizeCallback(glWindow, on_window_size_callback);
    // glfwSetWindowCloseCallback(glWindow, on_window_close_callback);

    glfwMakeContextCurrent(window);
    glfwSwapInterval(1);

    ffglex::Log("GL Ready");
  }

  double FFGLPlayground::getTime() {
    if (initialized) {
      return getNow() - startTime;
    } else {
      return -DBL_MAX;
    }
  }

  bool FFGLPlayground::isRunning() {
    return !glfwWindowShouldClose(window);
  }

  void FFGLPlayground::onKey(GLFWwindow* window, int key, int scancode, int action, int mods) {
    if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
      ffglex::Log("Exit signal. Shutting down...");
      glfwSetWindowShouldClose(window, GLFW_TRUE);
    }
  }

  void FFGLPlayground::initGL() {
    ffglex::Log("Initializing User GL Context");
    // glEnable(GL_DEBUG_OUTPUT);
    // Initializing already completed in constructor
    // but leaving this here for constistency.
  }

  void FFGLPlayground::initGL(std::function<void(double time, int width, int height)> callback) {
    initGL();

    int width, height;
    glfwGetFramebufferSize(window, &width, &height);

    // Initialize user callback
    callback(getTime(), width, height);

    ffglex::Log("User GL Context Ready");
  }

  void FFGLPlayground::initUI() {
    ffglex::Log("Initializing UI");
    const char* glsl_version = "#version 410";

    // Setup Dear ImGui context
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();

    ImGuiIO& io = ImGui::GetIO(); (void)io;
    // Enable Keyboard Controls
    io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;
    // Enable Docking
    io.ConfigFlags |= ImGuiConfigFlags_DockingEnable;
    // Enable Multi-Viewport / Platform Windows
    io.ConfigFlags |= ImGuiConfigFlags_ViewportsEnable;

    // auto& colors = ImGui::GetStyle().Colors;
    // colors[ImGuiCol_WindowBg] = ImVec4{ 0.1f, 0.1f, 0.1f, 1.0f };
    // colors[ImGuiCol_Header] = ImVec4{ 0.2f, 0.2f, 0.2f, 1.0f };
    // colors[ImGuiCol_HeaderHovered] = ImVec4{ 0.3f, 0.3f, 0.3f, 1.0f };
    // colors[ImGuiCol_HeaderActive] = ImVec4{ 0.15f, 0.15f, 0.15f, 1.0f };
    // colors[ImGuiCol_Button] = ImVec4{ 0.2f, 0.2f, 0.2f, 1.0f };
    // colors[ImGuiCol_ButtonHovered] = ImVec4{ 0.3f, 0.3f, 0.3f, 1.0f };
    // colors[ImGuiCol_ButtonActive] = ImVec4{ 0.15f, 0.15f, 0.15f, 1.0f };
    // colors[ImGuiCol_FrameBg] = ImVec4{ 0.2f, 0.2f, 0.2f, 0.3f };
    // colors[ImGuiCol_FrameBgHovered] = ImVec4{ 0.3f, 0.3f, 0.3f, 1.0f };
    // colors[ImGuiCol_FrameBgActive] = ImVec4{ 0.15f, 0.15f, 0.15f, 1.0f };
    // colors[ImGuiCol_Tab] = ImVec4{ 0.15f, 0.15f, 0.15f, 0.3f };
    // colors[ImGuiCol_TabHovered] = ImVec4{ 0.38f, 0.38f, 0.38f, 1.0f };
    // colors[ImGuiCol_TabActive] = ImVec4{ 0.28f, 0.28f, 0.28f, 1.0f };
    // colors[ImGuiCol_TabUnfocused] = ImVec4{ 0.15f, 0.15f, 0.15f, 0.3f };
    // colors[ImGuiCol_TabUnfocusedActive] = ImVec4{ 0.2f, 0.2f, 0.2f, 0.3f };
    // colors[ImGuiCol_TitleBg] = ImVec4{ 0.15f, 0.15f, 0.15f, 1.0f };
    // colors[ImGuiCol_TitleBgActive] = ImVec4{ 0.15f, 0.15f, 0.15f, 1.0f };
    // colors[ImGuiCol_TitleBgCollapsed] = ImVec4{ 0.15f, 0.15f, 0.15f, 1.0f };

    // ImGuiStyle& style = ImGui::GetStyle();
    // if (io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable)
    // {
    //   style.WindowRounding = 0.0f;
    //   style.Colors[ImGuiCol_WindowBg].w = 1.0f;
    // }

    // Setup Platform/Renderer backends
    ImGui_ImplGlfw_InitForOpenGL(window, true);
    ImGui_ImplOpenGL3_Init(glsl_version);
  }

  void FFGLPlayground::initUI(std::function<void()> callback) {
    initUI();

    ffglex::Log("Initializing User UI");

    // Initialize the user's UI
    callback();
  }

  void FFGLPlayground::preRender() {
    // GL Render Setup
    float ratio;
    int width, height;
    glfwGetFramebufferSize(window, &width, &height);
    ratio = width / (float) height;

    GL( glViewport(0, 0, width, height) );
    GL( glClearColor(bgColor.r, bgColor.g, bgColor.b, 1.0f) );
    // GL( glClearColor(0.0f, 0.0f, 0.0f, 1.0f) );
    GL( glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT) );
    GL( glEnable(GL_DEPTH_TEST) );

    // UI Render Setup
    ImGui_ImplOpenGL3_NewFrame();
    ImGui_ImplGlfw_NewFrame();
    ImGui::NewFrame();

    // Create the docking environment
    ImGuiWindowFlags windowFlags = ImGuiWindowFlags_NoDocking | ImGuiWindowFlags_NoTitleBar |
      ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoMove |
      ImGuiWindowFlags_NoBringToFrontOnFocus | ImGuiWindowFlags_NoNavFocus |
      ImGuiWindowFlags_NoBackground;

    ImGuiViewport* viewport = ImGui::GetMainViewport();
    ImGui::SetNextWindowPos(viewport->Pos);
    ImGui::SetNextWindowSize(viewport->Size);
    ImGui::SetNextWindowViewport(viewport->ID);

    ImGui::PushStyleVar(ImGuiStyleVar_WindowRounding, 0.0f);
    ImGui::PushStyleVar(ImGuiStyleVar_WindowBorderSize, 0.0f);
    ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(0.0f, 0.0f));
    ImGui::Begin("InvisibleWindow", nullptr, windowFlags);
    ImGui::PopStyleVar(3);

    ImGuiID dockSpaceId = ImGui::GetID("InvisibleWindowDockSpace");
    ImGui::DockSpace(dockSpaceId, ImVec2(0.0f, 0.0f), ImGuiDockNodeFlags_PassthruCentralNode);
    ImGui::End();
  }

  void FFGLPlayground::preRender(std::function<void(double time)> callback) {
    preRender();

    // ImGuiWindowFlags window_flags = 0;
    // window_flags |= ImGuiWindowFlags_NoBackground;
    // window_flags |= ImGuiWindowFlags_NoTitleBar;
    // bool open_ptr = true;
    // ImGui::Begin("Controls", &open_ptr, window_flags);

    ImGui::Begin("Controls");
      callback(getTime());
    // if (ImGui::CollapsingHeader("Mesh", ImGuiTreeNodeFlags_DefaultOpen))
    // {
    //
    //   if (ImGui::Button("Randomize Points"))
    //   {
    //     ffglex::Log("CLICK");
    //   }
    //   // ImGui::SameLine(0, 5.0f);
    //   // ImGui::Text(mCurrentFile.c_str());
    // }
    // if (ImGui::CollapsingHeader("Material") && mesh)
    // {
    //   ImGui::ColorPicker3("Color", (float*)&mesh->mColor, ImGuiColorEditFlags_PickerHueWheel | ImGuiColorEditFlags_DisplayRGB);
    //   ImGui::SliderFloat("Roughness", &mesh->mRoughness, 0.0f, 1.0f);
    //   ImGui::SliderFloat("Metallic", &mesh->mMetallic, 0.0f, 1.0f);
    // }
    //
    // if (ImGui::CollapsingHeader("Light"))
    // {
    //
    //   ImGui::Separator();
    //   ImGui::Text("Position");
    //   ImGui::Separator();
    //   nimgui::draw_vec3_widget("Position", scene_view->get_light()->mPosition, 80.0f);
    // }
    ImGui::End();
  }

  void FFGLPlayground::renderGL(std::function<void(double time, int width, int height)> callback) {
    int width, height;
    glfwGetFramebufferSize(window, &width, &height);

    callback(getTime(), width, height);

    // ImGui::Begin("Scene");
    //
    // ImVec2 panel = ImGui::GetContentRegionAvail();
    // // ffglex::Log("Render Context Size: ", panel.x, " x ", panel.y);
    //
    // // TODO How can we specify the initial docking?
    // if (panel.x > 10 && panel.y > 10) {
    //   lolpxl::FBO fbo;
    //   fbo.init(panel.x, panel.y);
    //
    //   // // TODO How do we set the aspect ratio of our mesh?
    //   // // mCamera->set_aspect(mSize.x / mSize.y);
    //   // // mCamera->update(mShader.get());
    //   //
    //   // add rendered texture to ImGUI scene window
    //   auto texture = fbo.render([&]() {
    //     callback(getTime());
    //   });
    //
    //   // TODO What does reinterpret_cast do and is this ok?
    //   ImGui::Image(reinterpret_cast<void*>(texture.Handle), ImVec2{ panel.x, panel.y }, ImVec2{ 0, 1 }, ImVec2{ 1, 0 });
    // }
    //
    // ImGui::End();
  }

  void FFGLPlayground::postRender() {
    // UI Render Cleanup
    ImGui::Render();
    ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());

    ImGuiIO& io = ImGui::GetIO();

    if (io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable)
    {
      GLFWwindow* backup_current_context = glfwGetCurrentContext();
      ImGui::UpdatePlatformWindows();
      ImGui::RenderPlatformWindowsDefault();
      glfwMakeContextCurrent(backup_current_context);
    }

    // GL Render Cleanup
    glfwSwapBuffers(window);
    glfwPollEvents();

    // Once postRender is complete, we know we've run at least one full
    // preRender -> render -> postRender cycle. This allows us to immitate the
    // effects of Resolume's `hostTime` which is uninitialized until the second
    // render cycle.
    initialized = true;
  }

  void FFGLPlayground::postRender(std::function<void()> callback) {
    callback();
    postRender();
  }

  int FFGLPlayground::releaseGL() {
    ffglex::Log("Cleaning up UI resources.");

    ImGui_ImplOpenGL3_Shutdown();
    ImGui_ImplGlfw_Shutdown();
    ImGui::DestroyContext();

    ffglex::Log("Cleaning up GL resources.");

    glfwDestroyWindow(window);
    glfwTerminate();

    ffglex::Log("Exiting the Playground");

    return EXIT_SUCCESS;
  }

  int FFGLPlayground::releaseGL(std::function<void()> callback) {
    ffglex::Log("Cleaning up User resources.");

    callback();

    return releaseGL();
  }
}
