/*
 *  A D program to calculate Pi using quadrature as a parallel map algorithm.
 *
 *  Copyright © 2010-11 Russel Winder
 */

//  std.parallelism is currently not in Phobos2, though it is being voted on for inclusion in Phobos2, so
//  ensure the compilation command takes care of all the factors to include the library.

import std.date ;
import std.parallelism ;
import std.stdio ;
import std.typecons ;

//  As at version 2.051 D is a 32-bit system generating 32-bit code.  Using long rather than int makes this
//  quite a lot slower than the equivalents in C and C++.  64-bit D is due "very soon now".

real partialSum ( immutable Tuple ! ( int , int , double ) data ) { 
  auto sum = 0.0 ;
  foreach ( i ; data[0] .. data[1] ) {
    immutable x = ( i - 0.5 ) * data[2] ;
    sum += 1.0 / ( 1.0 + x * x ) ;
  }
  return sum ;
}

void execute ( immutable int numberOfTasks ) {
  immutable n = 1000000000 ;
  immutable delta = 1.0 / n ;
  immutable startTime = getUTCtime ( ) ;
  immutable sliceSize = n / numberOfTasks ;
  auto inputData = new Tuple ! ( int , int , double ) [ numberOfTasks ] ;
  //
  //  The D compiler cannot currently (2.051) handle tuples with elements of immutable type.  So without the cast, the following
  //  error message is emitted:
  //
  //      Error: template instance std.typecons.tuple!(int,int,immutable(double)) error instantiating
  //
  //foreach ( i ; 0 .. numberOfTasks ) { inputData[i] = tuple ( 1 + i * sliceSize , ( i + 1 ) * sliceSize , delta ) ; }
  foreach ( i ; 0 .. numberOfTasks ) { inputData[i] = tuple ( 1 + i * sliceSize , ( i + 1 ) * sliceSize , cast ( double ) ( delta ) ) ; }
  //
  //  David Simcha reports that using explicit TaskPool creation is only for special cases, that using the
  //  lazy, singleton taskPool is the right way of handling this sort of map use.
  //
  auto outputData = taskPool.map ! ( partialSum ) ( inputData ) ;
  immutable pi = 4.0 * taskPool.reduce ! ( "a + b" ) ( 0.0 , outputData ) * delta ;
  immutable elapseTime = ( cast ( double ) ( getUTCtime ( ) - startTime ) ) / ticksPerSecond ;
  writefln ( "==== D Parallel Map pi = %.18f" , pi ) ;
  writefln ( "==== D Parallel Map iteration count = %d" , n ) ;
  writefln ( "==== D Parallel Map elapse = %f" , elapseTime ) ;
  writefln ( "==== D Parallel Map task count = %d" , numberOfTasks ) ;
}

int main ( immutable string[] args ) {
  execute ( 1 ) ;
  writeln ( ) ;
  execute ( 2 ) ;
  writeln ( ) ;
  execute ( 8 ) ;
  writeln ( ) ;
  execute ( 32 ) ;
  return 0 ;
}
