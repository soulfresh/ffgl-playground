#include "Mesh.h"
#include <assert.h>
#include <ffglex/FFGLScopedVAOBinding.h>
#include <ffglex/FFGLScopedBufferBinding.h>
#include <ffglex/FFGLUtilities.h>
#include <ffglquickstart/FFGLRandom.h>
#include <iostream>

using namespace ffglex;

namespace lolpxl
{
Mesh::Mesh(int v) :
  vertexCount(v),
  positions(v),
  vaoID( 0 )
{ }

Mesh::~Mesh()
{
  //If any of these assertions hit you forgot to release this quad's gl resources.
  assert( vaoID == 0 );
}

bool Mesh::initialize( bool flipV )
{
  glGenVertexArrays( 1, &vaoID );
  if( vaoID == 0 ) {
    release();
    return false;
  }

  //FFGL requires us to leave the context in a default state, so use these scoped bindings to
  //help us restore the state after we're done.
  ScopedVAOBinding vaoBinding( vaoID );
  
  if (!positions.initialise()) {
    release();
    return false;
  }

  return true;
}

void Mesh::setStartTime(double time) {
  cout << "[Mesh] setStarTime: " << time << "\n";
  positions.setStartTime(time);
}

/**
 * Draw the quad. Depending on your vertex shader this will apply your fragment shader in the area where the quad ends up.
 * You need to have successfully initialised this quad before rendering it.
 */
void Mesh::draw(double time)
{
  if( vaoID == 0 )
    return;

  //Scoped binding to make sure we dont keep the vao bind after we're done rendering.
  ScopedVAOBinding vaoBinding( vaoID );
  
  if (positions.update(time)) {
    positions.sync();
  }
  
  glDrawArrays( GL_TRIANGLE_FAN, 0, positions.getCount() );
}

void Mesh::randomizePositions(double time) {
  ffglqs::Random r;
  cout << "[Mesh] RANDOMIZE!\n";
  positions.updateEach([&](AnimatedPoint& point){
    point.update(
      vec3(
        r.GetRandomFloat(-1, 1),
        r.GetRandomFloat(-1, 1),
        r.GetRandomFloat(-1, 1)
      ),
      time
    );
  });
}

// TODO Make sure this is always a multiple that will result in
// a triangle. Might already be working that way.
void Mesh::setVertexCount(int count) {
//  vertexCount = count;
  
  // TODO This needs to generate a new VBO because VBO size
  // cannot change.
//  if (vertexCount < points.size()) {
//    points.erase(points.begin() + vertexCount, points.end());
//  }
//  else if (vertexCount > points.size()) {
//    ffglqs::Random r;
//    for (double i = points.size(); i < vertexCount; i++) {
//      points.push_back(glm::vec3(
//        r.GetRandomFloat(0, 1),
//        r.GetRandomFloat(0, 1),
//        r.GetRandomFloat(0, 1)
//      ));
//    }
//  }
}

int Mesh::getVertexCount() {
  return vertexCount;
}

/**
 * Release the gpu resources this quad has loaded into vram. Call this before destruction if you've previously initialised us.
 */
void Mesh::release()
{
  glDeleteVertexArrays( 1, &vaoID );
  vaoID = 0;
}

}
