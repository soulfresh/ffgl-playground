#pragma once

#include <functional>
#include <vector>
#include <stdio.h>
#include <ffgl/FFGL.h> //For OpenGL
#include <glm/glm.hpp>
#include "AnimatedPoint.hpp"

namespace lolpxl {

using namespace std;
using namespace glm;

// TODO Should this be AnimatedAttribute?
class AnimatedAttribute {
public:
  AnimatedAttribute(int count);
  ~AnimatedAttribute();
  
  /**
   * Initialize OpenGL resources for this attribute.
   * A false return value indicates that it could not
   * initialize its resources and the plugin should fail
   */
  bool initialise();
  /**
   * Release the OpenGL resources created by this attribute.
   */
  void release();
  
  /**
   * Set the start time for each point. This is most important
   * at startup when we don't have a stable hostTime until a
   * couple draw commands in.
   */
  void setStartTime(double time);

  // TODO
  void setCount(int count);
  /**
   * Get the number of verticies in this attribute.
   */
  int getCount();

  /**
   * Change each point in the Attribute.
   */
  void updateEach(function<void(AnimatedPoint&)> callback);
  
  /**
   * Update the inner AnimatedVector's time. Returns true
   * if the attribute needs to be synced to the GPU.
   */
  bool update(double time);

  /**
   * Send the updated data to the GPU if it has changed.
   */
  void sync();
  
//  void setStartTime(double time);
  void setDuration(double duration);
  void setDelay(double delay);
  
  void debugData();

private:
  GLuint vboID;
  
  double duration = 500;
  double delay = 0;
  // TODO Better name for _data
  vector<vec3> cpuBuffer;
  vector<AnimatedPoint> points;
};
}
