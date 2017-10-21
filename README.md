# Computing the nth digits of pi

## Description
The procedure named pi, produces a infinite stream of pi digits.
We have:
<ul>
<li> An input stream strm. This is just the stream f1, f2, f3, ... of linear fractional transforma- tions, each one represented as a matrix.
  </li>
<li>An intermediate data structure called a. a will itself be a linear fractional transformation.
  </li>
<li> An output stream consisting of the digits of π.
  </li>
</ul>

Each step of the computation is a (recursive) call to the procedure action, which in turn calls one of two procedures:
<br>

**consume**: Multiply a on the right by the first element of strm and make that the new a. Replace strm by the stream you get when you  remove its first element. (Of course, I really mean by this that you make a recursive call to action, passing new values of a and strm as defined here.)
<br>
**produce**: Extract the next decimal digit of π from a (and incorporate that digit in the output stream), and multiply a on the left by a linear fractional transformation that reflects the fact that it has “lost that value”.

## How to use
==>(display-n (pi) 6)
<br>
3 1 4 1 5 9 done
