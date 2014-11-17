#! /usr/bin/env groovy

/*
 *  Calculation of π using quadrature realized with GPars dataflow operators and channels, using an
 *  accumulator operator.
 *
 *  Copyright © 2014  Russel Winder
 */

import groovyx.gpars.dataflow.DataflowVariable
import static groovyx.gpars.dataflow.Dataflow.operator

void execute(final operatorCount) {
  final n = 1_000_000_000
  final delta = 1.0 / n
  final startTimeNanos = System.nanoTime ()
  final sliceSize = (int)(n / operatorCount)
  final scatterChannels = (0 ..< operatorCount).collect{new DataflowVariable()}
  final gatherChannels = (0 ..< operatorCount).collect{new DataflowVariable()}
  final sum = new DataflowVariable()
  operator(inputs: gatherChannels, outputs: [sum], stateObject: [accumulator: 0.0, count: 0]){Double... values ->
    while (stateObject.count < operatorCount) { stateObject.accumulator += values.sum() }
    bindOutput 0, stateObject.accumulator
  }
  (0 ..< operatorCount).each{index ->
    operator(inputs: [scatterChannels[index]], outputs: [gatherChannels[index]]){i ->
      bindOutput 0, PartialSum.dynamicCompile(i, sliceSize, delta)
    }
    scatterChannels[index] << index
  }
  final pi = 4.0 * delta * sum.val
  final elapseTime = (System.nanoTime() - startTimeNanos) / 1e9
  Output.out getClass(), pi, n, elapseTime, operatorCount
}

execute 1
execute 2
execute 8
execute 32
