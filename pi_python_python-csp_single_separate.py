#! /usr/bin/env python
# -*- mode:python; coding:utf-8; -*-

#  Calculation of Pi using quadrature.  Using the python-csp package by Sarah Mount.
#
#  Copyright © 2009-10 Russel Winder

import time
import multiprocessing

from csp.cspprocess import *

@process
def calculator ( channel , id , sliceSize , delta , _process = None ) :
    sum = 0.0
    for i in xrange ( 1 + id * sliceSize , ( id + 1 ) * sliceSize + 1 ) :
        x = ( i - 0.5 ) * delta
        sum += 1.0 / ( 1.0 + x * x )
    channel.write ( sum )
        
@process
def accumulator ( channel , n , delta , startTime , processCount , _process = None ) :
    pi = 4.0 * sum ( [ channel.read ( ) for i in xrange ( 0 , processCount ) ] ) * delta
    elapseTime = time.time ( ) - startTime
    print "==== Python CSP Single Separate pi =" , pi
    print "==== Python CSP Single Separate iteration count =", n
    print "==== Python CSP Single Separate elapse =" , elapseTime
    print "==== Python CSP Single Separate process count = ", processCount
    print "==== Python CSP Single Separate processor count =" , multiprocessing.cpu_count ( )

def execute ( processCount ) :
    n = 100000000 # 10 times fewer due to speed issues.
    delta = 1.0 / n
    startTime = time.time ( )
    sliceSize = n / processCount
    channel = Channel ( )
    processes = [ ] 
    for i in xrange ( 0 , processCount ) : processes.append ( calculator ( channel , i , sliceSize , delta ) )
    processes.append ( accumulator ( channel , n , delta , startTime , processCount ) )
    Par ( *processes ).start ( )

if __name__ == '__main__' :
    execute ( 1 )
    print
    execute ( 2 )
    print
    execute ( 8 )
    print
    execute ( 32 )