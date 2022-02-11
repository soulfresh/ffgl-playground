#include "SpiderPoints.h"
#include <math.h>//floor
#include <ffglquickstart/FFGLRandom.h>
#include <iostream>
#include <cmath>

using namespace ffglex;

enum ParamType : FFUInt32
{
  PT_RED1,
  PT_GREEN1,
  PT_BLUE1,
  PT_ALP1,

  PT_POINT_COUNT,
  PT_RANDOMIZE,
};

static CFFGLPluginInfo PluginInfo(
  PluginFactory< SpiderPoints >,// Create method
  "SF02",                        // Plugin unique ID
  "Spider Points",               // Plugin name
  2,                             // API major version number
  2,                             // API minor version number
  1,                             // Plugin major version number
  000,                           // Plugin minor version number
  FF_SOURCE,                     // Plugin type
  "A shape shifting 3d object that animates its points to random locations.",// Plugin description
  "by Marc Wren, www.soul-fresh.com"        // About
);

static const char vertexShaderCode[] = R"(#version 410 core
layout( location = 0 ) in vec4 vPosition;
layout( location = 1 ) in vec2 vUV;

out vec2 uv;

void main()
{
  gl_Position = vPosition;
  uv = vUV;
}
)";

static const char fragmentShaderCode[] = R"(#version 410 core
uniform vec4 RGBALeft;
uniform vec4 RGBARight;

in vec2 uv;

out vec4 fragColor;

void main()
{
  fragColor = RGBALeft;
}
)";

SpiderPoints::SpiderPoints() :
  rgbLeftLocation( -1 )
{
  // Input properties
  SetMinInputs( 0 );
  SetMaxInputs( 0 );

  // Parameters
  // TODO See FFGLParamRange and FF_TYPE_INTEGER for non 0-1 integer sliders
  SetParamInfof( PT_RANDOMIZE, "Randomize Points", FF_TYPE_EVENT );//The button that'll cause parameter values/names etc to change.
  SetParamInfof( PT_RED1, "Solid Color", FF_TYPE_RED );
  SetParamInfof( PT_GREEN1, "Green", FF_TYPE_GREEN );
  SetParamInfof( PT_BLUE1, "Blue", FF_TYPE_BLUE );
  SetParamInfof( PT_ALP1, "Alpha", FF_TYPE_ALPHA );
  
  SetParamInfof( PT_POINT_COUNT, "Number of Points", FF_TYPE_STANDARD);
  
  std::cout << "\nSpiderPoints created \n";
  FFGLLog::LogToHost( "Created Spider Points Plugin" );
}

FFResult SpiderPoints::InitGL( const FFGLViewportStruct* vp )
{
  if( !shader.Compile( vertexShaderCode, fragmentShaderCode ) )
  {
    DeInitGL();
    return FF_FAIL;
  }
//  if( !quad.Initialise() )
//  {
//    DeInitGL();
//    return FF_FAIL;
//  }
  if (!mesh.initialize()) {
    DeInitGL();
    return FF_FAIL;
  }
  
  std::cout << "[SpiderPoints] Initial Host Time? " << hostTime << "\n";

  //FFGL requires us to leave the context in a default state on return,
  //so use this scoped binding to help us do that.
  ScopedShaderBinding shaderBinding( shader.GetGLID() );
  rgbLeftLocation  = shader.FindUniform( "RGBALeft" );

  //Use base-class init as success result so that it retains the viewport.
  return CFFGLPlugin::InitGL( vp );
}

FFResult SpiderPoints::ProcessOpenGL( ProcessOpenGLStruct* pGL )
{
  // Skip the first draw because the host time will be incorrect.
  // TODO Not sure if this is a bug in Resolume, FFGL or is expected.
  if (firstDraw) {
    firstDraw = false;
  } else {
    if (!initialized) {
      initialized = true;
      mesh.setStartTime(hostTime);
    }
  //  std::cout << "Host Time now: " << hostTime << "\n";
    // TODO This should move into the Mesh
    //FFGL requires us to leave the context in a default state on return, so use this scoped binding to help us do that.
    ScopedShaderBinding shaderBinding( shader.GetGLID() );
    glUniform4f( rgbLeftLocation, rgba1.red, rgba1.green, rgba1.blue, rgba1.alpha );

//    std::cout << "[SpiderPoints] ProcessOpenGL Time: " << hostTime << "\n";
    mesh.draw(hostTime);
  //  std::cout << "back faces visible? " << glIsEnabled(GL_CULL_FACE) << "\n";
  }

  return FF_SUCCESS;
}
FFResult SpiderPoints::DeInitGL()
{
  std::cout << "Closing SpiderPoints\n";
  shader.FreeGLResources();
  mesh.release();
  rgbLeftLocation  = -1;

  return FF_SUCCESS;
}

FFResult SpiderPoints::SetFloatParameter( unsigned int dwIndex, float value )
{
  switch( dwIndex )
  {
  case PT_RED1:
    rgba1.red = value;
    break;
  case PT_GREEN1:
    rgba1.green = value;
    break;
  case PT_BLUE1:
    rgba1.blue = value;
    break;
  case PT_ALP1:
    rgba1.alpha = value;
    break;
      
  case PT_RANDOMIZE:
    if (value == 1) {
      mesh.randomizePositions(hostTime);
    }
    break;
  case PT_POINT_COUNT:
    mesh.setVertexCount(3 + round(value * (maxPoints - 3)));
    break;

//  default:
//    return FF_FAIL;
  }

  return FF_SUCCESS;
}

float SpiderPoints::GetFloatParameter( unsigned int index )
{
  switch( index )
  {
  case PT_RED1:
    return rgba1.red;
  case PT_GREEN1:
    return rgba1.green;
  case PT_BLUE1:
    return rgba1.blue;
  case PT_ALP1:
    return rgba1.alpha;
  case PT_POINT_COUNT:
    return (float)mesh.getVertexCount() / (float)maxPoints;
  }

  return 0.0f;
}
