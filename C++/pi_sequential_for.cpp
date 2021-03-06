/*
 *  A C++ program to calculate π using quadrature as a sequential algorithm.
 *
 *  Copyright © 2008–2011, 2013, 2014  Russel Winder
 */

#include <chrono>

#include "output.hpp"

int main() {
  auto const n = 1000000000;
  auto const delta = 1.0 / n;
  auto const startTime = std::chrono::steady_clock::now();
  auto sum = 0.0;
  for (auto i = 1; i <= n; ++i) {
    auto const x = (i - 0.5) * delta;
    sum += 1.0 / (1.0 + x * x);
  }
  auto const pi = 4.0 * delta * sum;
  auto const elapseTime = std::chrono::steady_clock::now() - startTime;
  out("Sequential For", pi, n, elapseTime);
  return 0;
}
