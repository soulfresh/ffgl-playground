#pragma once
#include <ffgl/FFGL.h>//For OpenGL
#include <string>
#include <vector>
#include <glm/glm.hpp>
#include "AnimatedAttribute.hpp"

using namespace std;
using namespace glm;

namespace lolpxl
{

/**
 * The ScreenQuad is a utility that helps you load vertex data representing a quad into a buffer
 * and setting up a vao to source it's vertex attributes from this buffer. You can then tell this
 * quad to draw itself which will use that buffer and vao to render the quad.
 */
class Mesh
{
public:
  Mesh(int vertexCount = 10);
  // TODO Do we want these? Is this something I should be doing?
	Mesh( const Mesh& ) = delete;
	Mesh( Mesh&& )      = delete;
	~Mesh();
  
/**
 * Allow this utility to load the data it requires to do it's rendering into it's buffers.
 * This function needs to be called using an active OpenGL context, for example in your plugin's
 * InitGL function.
 *
 * @param flipV: When this is true the quad's uvs will be flipped on the y axis.
 * @return: Whether or not initialising this quad succeeded.
 */
	bool initialize( bool flipV = false );
  /**
   * Initialize animations once we know the host time.
   */
  void setStartTime(double time);
	void draw(double time);
	void release();
  
  void randomizePositions(double time);
  void setVertexCount(int count);
  int getVertexCount();

private:
  
	GLuint vaoID;
  
  bool synced;
  
  int vertexCount = 10;
  vector<vec3> points;
  AnimatedAttribute positions;
};

}
