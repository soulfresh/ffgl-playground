#include "ffglplayground/Playground.h"

#include <thread> 
#include <chrono>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>

using namespace ffglplayground;
using namespace std;

int main(void) {
  FFGLPlayground playground;

  // You can do any inital UI setup work here if you want.
  playground.initUI([&]() {});

  playground.initGL([&](auto time, auto width, auto height) {
    // Do any GL initialization here. For example, call your
    // plugin's `InitGL` function.
  });

  bool firstPass = true;

  // Accurate BPM timing
  // https://stackoverflow.com/a/75522904
  using frames = std::chrono::duration<std::int64_t, std::ratio<1, 60>>;
  auto nextLoopStart = std::chrono::steady_clock::now() + frames{0};

  int bpm = 30;
  double nextBeat = 0;
  // Used for logging frame duration
  double lastTime = 0;

  ImVec4 sectionLabelColor(0.0f, 0.5f, 1.0f, 1.0f);

  // Game Loop
  while (playground.isRunning()) {
    // Use the `preRender` function to render your UI.
    playground.preRender([&](auto time) {
      ImGui::ShowDemoWindow();


      // Example ImGui slider.
      if (ImGui::SliderFloat("Scale", &scale, 0.f, 2.f)) {
        // Call your plugin code here to update a parameter.
      }

      // The BPM slider
      ImGui::SliderInt("BPM", &bpm, 0, 300);

      // Update the BPM tracker.
      if (time > nextBeat) {
        // Place any code here that you want to run on the BPM.

        double beatLength = (1000.f * 60.f) / bpm;
        nextBeat = time + beatLength;
        lastTime = time;
      }
    });

    // Use the `renderGL` function to draw your plugin to the screen.
    playground.renderGL([&](auto time, auto width, auto height) {
      // Resolume will call your plugin once with an undefined host time
      // in order to generate a thumbnail for your plugin. This `firstPass`
      // code is used to mimic that behavior.
      if (firstPass) {
        firstPass = false;
        Log("[Playground] Beat Interval ms > ", time - lastTime, "\n");

        // Do any work you'd like to do on the first pass here.
      }

      FFGLViewportStructTag vp;
      vp.x = 0;
      vp.y = 0;
      vp.width = width;
      vp.height = height;

      // Call your plugin `ProcessOpenGL` function here
    });

    // Do any work you want to do after each render.
    playground.postRender();

    // Wait until the next frame.
    nextLoopStart += frames{1};
    std::this_thread::sleep_until(nextLoopStart);
  }

  return playground.releaseGL([&]() {
      // Run the teardown functions for your plugin here.
  });
}

