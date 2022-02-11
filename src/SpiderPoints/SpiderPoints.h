#pragma once
#include <glm/glm.hpp>
#include <FFGLSDK.h>
#include <vector>
#include "Mesh.h"

class SpiderPoints : public CFFGLPlugin
{
public:
  SpiderPoints();

  //CFFGLPlugin
  FFResult InitGL( const FFGLViewportStruct* vp ) override;
  FFResult ProcessOpenGL( ProcessOpenGLStruct* pGL ) override;
  FFResult DeInitGL() override;

  FFResult SetFloatParameter( unsigned int dwIndex, float value ) override;

  float GetFloatParameter( unsigned int index ) override;

private:
  // Track if we're passed the first ProcessOpenGL call.
  bool firstDraw = true;
  // Track if we've initialized time dependent objects.
  bool initialized = false;
  // TODO Convert to HSV
  // TODO Use a vec4
  struct RGBA
  {
    float red   = 1.0f;
    float green = 1.0f;
    float blue  = 0.0f;
    float alpha = 1.0f;
  };
  RGBA rgba1;

  ffglex::FFGLShader shader;  //!< Utility to help us compile and link some shaders into a program.
  GLint rgbLeftLocation;

  // TODO Use a logarithmic scale to allow even higher max?
  int maxPoints = 30;
  // TODO How do I declare this without constructing it
  // so I can construct it later?
  lolpxl::Mesh mesh{10};
};
