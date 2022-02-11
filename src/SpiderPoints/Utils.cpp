#include <glm/glm.hpp>
#include <string>
#include "Utils.h"

using namespace glm;
using namespace std;

namespace lolpxl {

string vecToString(vec3 v) {
  return "(" + to_string(v.x) + "," + to_string(v.y) + "," + to_string(v.z) + ")";
}

}
