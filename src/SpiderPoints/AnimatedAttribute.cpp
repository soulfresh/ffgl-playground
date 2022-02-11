#include <iostream>
#include <ffgl/FFGL.h>
#include <ffglex/FFGLScopedBufferBinding.h>
#include "AnimatedAttribute.hpp"
#include "Utils.h"

using namespace std;
using namespace glm;
using namespace ffglex;

namespace lolpxl {
AnimatedAttribute::AnimatedAttribute(int count) {
  for(int i = 0; i < count; i++) {
    points.push_back(AnimatedPoint {duration});
    cpuBuffer.push_back(points.at(i).getStartValue());
  }
};

AnimatedAttribute::~AnimatedAttribute()
{
  release();
  // If any of these assertions hit you forgot to release this quad's gl resources.
  assert( vboID == 0 );
}

bool AnimatedAttribute::initialise() {
  glGenBuffers( 1, &vboID );
  
  if( vboID == 0 ) {
    // TODO Is it ok to glDeleteBuffers if the buffer doesn't exist?
    release();
    return false;
  }
  
  // Bind the buffer and release it when the function returns.
  ScopedVBOBinding vboBinding( vboID );
  
  // Share the current data with OpenGL.
  // TODO I think this is setting invalid data
  glBufferData( GL_ARRAY_BUFFER, cpuBuffer.size() * sizeof(vec3), cpuBuffer.data(), GL_DYNAMIC_DRAW);
  
  // Set the current attribute shader index
  glEnableVertexAttribArray( 0 );
  
  // Teach OpenGL the layout of our attribute
  glVertexAttribPointer(
    // The index of this attribute (position)
    0,
    // The number of values in this attribute
    3,
    // The type of each element in the attribute
    GL_FLOAT,
    // Normalize the values in this attribute
    // from 0 - 1?
    GL_FALSE,
    // Stride: The size of each attribute element
    // ie. the size of a vec3
//      sizeof(float) * 3,
    sizeof(vec3),
    // The start position of this attribute
    // in the list of attributes in this VAO
    0
    // Usually you would use something like
    // (const void)* 8
    // Resolume used:
    // (char*)NULL + 2 * sizeof( float )
  );
  
  return true;
};

void AnimatedAttribute::release() {
  glDeleteBuffers( 1, &vboID );
  vboID = 0;
};

void AnimatedAttribute::setStartTime(double time) {
  updateEach([=](AnimatedPoint& point){
    point.setStartTime(time);
  });
}

void AnimatedAttribute::setCount(int count) {
  // TODO Need to add a setCount to AnimatedAttribute
};

int AnimatedAttribute::getCount() {
  return (int)points.size();
}

void AnimatedAttribute::setDuration(double d) {
  duration = d;
  for (auto& point: points) {
    point.setDuration(d);
  }
}

void AnimatedAttribute::setDelay(double d) {
  delay = d;
}

void AnimatedAttribute::updateEach(function<void(AnimatedPoint&)> callback) {
  for (auto& point : points) {
    callback(point);
  }
};

// TODO There's a flash on the first animation. It looks like
// the initial positions are wrong.
bool AnimatedAttribute::update(double time) {
  bool changed = false;
  for (int i = 0; i < points.size(); i++) {
    vec3 point = points.at(i).getValue(time, i == 0);
    if (cpuBuffer.at(i) != point) {
      cpuBuffer.at(i) = point;
      changed = true;
    }
  }
  if (changed) {
    debugData();
  }
  return changed;
};

void AnimatedAttribute::sync() {
  // Bind our VBO and release it when the function returns.
  ScopedVBOBinding vboBinding( vboID );
  
  // Empty the data in the buffer
  glBufferData( GL_ARRAY_BUFFER, cpuBuffer.size() * sizeof(vec3), NULL, GL_DYNAMIC_DRAW);
  // And fill it back up again. This is supposed to be
  // faster and more stable than just changing the data.
  glBufferSubData( GL_ARRAY_BUFFER, 0, cpuBuffer.size() * sizeof(vec3), cpuBuffer.data());
}

void AnimatedAttribute::debugData() {
  for (int i = 0; i < cpuBuffer.size(); i++) {
    if (i == 0) {
      cout << "[AnimatedAttribute] update:         " << i << " = " << vecToString(cpuBuffer.at(i)) << "\n";
    }
  }
}
}
