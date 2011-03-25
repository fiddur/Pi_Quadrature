/*
 *  A D program to calculate Pi using quadrature as a parallel map algorithm.
 *
 *  Copyright © 2011 Russel Winder
 */

//  std.parallelism is currently not in Phobos2, though it is being voted on for inclusion in Phobos2, so
//  ensure the compilation command takes care of all the factors to include the library.

//  This version is due to David Simcha, stemming from various emails ont he various D email lists and
//  reified in the documentation for std.parallelism,
//  http://cis.jhu.edu/~dsimcha/d/phobos/std_parallelism.html#reduce

//  Attempt to make things more local than David's original.  This fails as paralle reduce cannot work with
//  closures only with global functions.

import std.algorithm ;
import std.datetime ;
import std.parallelism ;
import std.range ;
import std.stdio ;

int main ( immutable string[] args ) {
  immutable n = 1000000000 ;
  immutable delta = 1.0 / n ;
  //  Delegates cannot be assigned to immutables?
  /*immutable*/ auto getTerm = delegate real ( int i ) {
    immutable x = ( i - 0.5 ) * delta ;
    return 1.0 / ( 1.0 + x * x ) ;
  } ;
  StopWatch stopWatch ;
  stopWatch.start ( ) ;
  //  Have to use the string mechanism of specifying the lambda as std.parallelism cannot handle non-string
  //  closures jsut now.
  //immutable pi = 4.0 * delta * taskPool.reduce ! ( ( a , b ) { return a + b ; } ) ( map ! getTerm ( iota ( n ) ) ) ;
  immutable pi = 4.0 * delta * taskPool.reduce ! ( "a + b" ) ( map ! getTerm ( iota ( n ) ) ) ;
  stopWatch.stop ( ) ;
  immutable elapseTime = stopWatch.peek ( ).hnsecs * 100e-9 ;
  writefln ( "==== D Parallel Reduce RW variant of DS pi = %.18f" , pi ) ;
  writefln ( "==== D Parallel Reduce RW variant of DS iteration count = %d" , n ) ;
  writefln ( "==== D Parallel Reduce RW variant of DS elapse = %f" , elapseTime ) ;
  return 0 ;
}
