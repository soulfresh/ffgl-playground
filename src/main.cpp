// Your First C++ Program

#include <iostream>
#include <glm.hpp>
#include "FFGLSDK.h"

int main() {
	glm::vec3 foo = {10, 20, 30};
	std::cout << "Vector: (" << foo.x << "," << foo.y << "," << foo.z << ")";
	int x;
	std::cin >> x;
	return 0;
}

