// Your First C++ Program

#include <iostream>
#include <glm/glm.hpp>

int main() {
	glm::vec3 foo = {10, 20, 30};
	std::cout << "Hello World!" << foo.x << foo.y << foo.z;
	return 0;
}

