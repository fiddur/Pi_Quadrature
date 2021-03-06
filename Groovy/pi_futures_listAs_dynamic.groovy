#! /usr/bin/env groovy

/*
 *  Calculation of π using quadrature realized with a parallel algorithm based on using Futures.
 *
 *  Copyright © 2009–2012, 2014  Russel Winder
 */

import java.util.concurrent.Callable
import java.util.concurrent.ScheduledThreadPoolExecutor

def execute(final numberOfTasks) {
  final n = 1_000_000_000
  final delta = 1.0d / n
  final startTimeNanos = System.nanoTime ()
  final sliceSize = (int)(n / numberOfTasks)
  final executor = new ScheduledThreadPoolExecutor(numberOfTasks)
  final futures = (0 ..< numberOfTasks).collect {taskId ->
    executor.submit({PartialSum.dynamicCompile(taskId, sliceSize, delta)} as Callable<Double>)
  }
  final pi = 4.0 * delta * futures.sum{f -> f.get()}
  final elapseTime = (System.nanoTime() - startTimeNanos) / 1e9
  executor.shutdown()
  Output.out getClass(), pi, n, elapseTime, numberOfTasks
}

execute 1
execute 2
execute 8
execute 32
