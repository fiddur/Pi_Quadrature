/*
 *  A Chapel program to calculate Pi using quadrature as a parallel reduce-based algorithm.
 *
 *  Copyright © 2009-10 Russel Winder
 */

use Time ;

def execute ( param numberOfTasks : int ) {
  param n : int(64) = 1000000000 ;
  const delta : real = 1.0 / n ;
  param sliceSize : int(64) = n / numberOfTasks ;
  const eachProcessor : domain(1) = [ 0 .. ( numberOfTasks - 1 ) ] ;
  const results : [eachProcessor] real ;
  def partialSum ( const id : int ) : real {
    const start : int(64) = 1 + id * sliceSize ;
    const end : int(64) = ( id + 1 ) * sliceSize ;
    var sum : real = 0.0 ;
    for i in start .. end {
      sum += 1.0 / ( 1.0 + ( ( i - 0.5 ) * delta ) ** 2 ) ;
    }
    return sum ;
  }
  var timer : Timer ;
  timer.start ( ) ;
  // Prior to version 1.1 of Chapel, this is always handled in a single thread.
  // From version 1.1, it is correctly parallelized,
  const pi = 4.0 * ( + reduce [ i in eachProcessor ] partialSum ( i ) ) * delta ;
  timer.stop ( ) ;
  writeln ( "==== Chapel Reduce pi = " , pi ) ;
  writeln ( "==== Chapel Reduce iteration count = " , n ) ;
  writeln ( "==== Chapel Reduce elapse = " , timer.elapsed ( ) ) ;
  writeln ( "==== Chapel Reduce task count = " , numberOfTasks ) ;
}

def main ( ) {
  execute ( 1 ) ;
  writeln ( ) ;
  execute ( 2 ) ;
  writeln ( ) ;
  execute ( 8 ) ;
  writeln ( ) ;
  execute ( 32 ) ;
}
