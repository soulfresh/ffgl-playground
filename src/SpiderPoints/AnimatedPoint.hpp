#pragma once

#include <stdio.h>
#include <glm/glm.hpp>

namespace lolpxl {

//template<typename Easing>
class AnimatedPoint {
public:
  AnimatedPoint(double duration);
  
  AnimatedPoint(
    double duration,
    glm::vec3 endValue,
    double startTime = 0,
    glm::vec3 start = {0, 0, 0}
  );
  
  /**
   * Get the value of the animated point at the given time or the start of the
   * animation if no time is given.
   */
  glm::vec3 getValue(double time = 0, bool debug = true);
  
  glm::vec3 getStartValue();
  
  /**
   * Set a new start and end time for the animation.
   */
  void update(glm::vec3 endValue, double startTime);
  
  void setStartTime(double time);
  void setDuration(double duration);
  
  /**
   * Change the easing equation used for this animation.
   */
//  template<typename F>
//  void setEasing(F easing);
  
private:
  glm::vec3 startValue = {0, 0, 0};
  glm::vec3 endValue = {0, 0, 0};
  double startTime = 0;
  double duration = 500;
//  Easing easing;
};
}

