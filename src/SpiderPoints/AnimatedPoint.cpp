//
//  AnimatedPoint.cpp
//  sfSpiderPoints
//
//  Created by robert m wren on 1/15/22.
//
#include <iostream>
#include <iomanip>
#include <string>
#include <utility>
#include "AnimatedPoint.hpp"
#include <ffglquickstart/FFGLRandom.h>
// #include <easing-functions/easing.h>
#include "Utils.h"

using namespace glm;
using namespace std;

namespace lolpxl {

AnimatedPoint::AnimatedPoint(
  double duration
): duration(duration) {
  ffglqs::Random r;
  endValue = vec3(
    r.GetRandomFloat(-1, 1),
    r.GetRandomFloat(-1, 1),
    r.GetRandomFloat(-1, 1)
  );
}

AnimatedPoint::AnimatedPoint(
  double duration,
  vec3 endValue,
  double startTime,
  vec3 start
): endValue{endValue}, startTime{startTime}, duration{duration}, startValue{start} {
};

void AnimatedPoint::update(vec3 ev, double st) {
  startValue = endValue;
  endValue = ev;
  setStartTime(st);
}

void AnimatedPoint::setStartTime(double st) {
  startTime = st;
}

void AnimatedPoint::setDuration(double d) {
  duration = d;
}

//void AnimatedPoint::setEasing(F e) {
//
//}

vec3 AnimatedPoint::getStartValue() {
  return startValue;
}

vec3 AnimatedPoint::getValue(double time, bool debug) {
  if (time <= startTime) {
    // TODO spdlog + logging preprocessor command
    if (debug) {
      cout << "[AnimatedPoint] START:  " << std::fixed << std::setw(11) << std::setprecision(6) << std::setfill('0') << time << " " << vecToString(startValue) << "\n";
    }
    return startValue;
  } else if (time >= startTime + duration) {
    return endValue;
  } else {
    auto change = endValue - startValue;
    double percent = (time - startTime) / duration;
    double eased = percent; // getEasingFunction(EaseOutExpo)(percent);

    auto output = startValue + (change * (float)eased);
    if (debug) {
      cout << "[AnimatedPoint] startValue:             " << vecToString(startValue) << "\n";
      cout << "[AnimatedPoint] endValue  :             " << vecToString(endValue) << "\n";
      cout << "[AnimatedPoint] change:                 " << vecToString(change) << "\n";
      cout << "[AnimatedPoint] percent: " << percent << "\n";
      cout << "[AnimatedPoint] output: " << time << " " << vecToString(output) << "\n";
    }
    return output;
  }
}
}
