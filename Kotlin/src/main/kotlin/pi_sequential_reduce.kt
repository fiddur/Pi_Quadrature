/*
 *  Calculation of π using quadrature realized with reduce.
 *
 *  Copyright © 2013–2015  Russel Winder
 */

package uk.org.winder.pi_quadrature.pi_sequential_reduce

import uk.org.winder.pi_quadrature.out

fun main(args:Array<String>) {
  val n = 1000000000
  val delta = 1.0 / n
  val startTimeNanos = System.nanoTime()
  // cf. KT-8067 Type inference and overload resolution with reduce function,
  // https://youtrack.jetbrains.com/issue/KT-8067
  val r = (1.0..n).reduce{t, i ->
    val x = (i - 0.5) * delta
    t + 1.0 / (1.0 + x * x)
  }
  val pi = 4.0 * delta * r
  val elapseTime = (System.nanoTime() - startTimeNanos) / 1e9
  out("pi_sequential_reduce", pi, n, elapseTime)
}
