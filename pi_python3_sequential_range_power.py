#! /usr/bin/env python3

#  Calculation of Pi using quadrature. Sequential algorithm. For loop with a range.
#
#  Copyright © 2008–2012 Russel Winder

from output import out
from time import time

if __name__ == '__main__' :
  n = 10000000 # 100 times fewer than C due to speed issues
  delta = 1.0 / n
  startTime = time ( )
  sum = 0.0
  for i in range ( 1 , n + 1 ) :
    sum += 1.0 / ( 1.0 + ( ( i - 0.5 ) * delta ) ** 2 )
  pi = 4.0 * delta * sum
  elapseTime = time ( ) - startTime
  out ( 'Python3 Sequential For/Range Power' , pi , n , elapseTime )
