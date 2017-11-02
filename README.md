# Computing the n digits of pi

## Description
The procedure named pi, produces a infinite stream of pi digits.
We have:
<ul>
<li> An input stream strm. This is just the stream f1, f2, f3, ... of linear fractional transformations, each one represented as a matrix.
  </li>
<li>An intermediate data structure called a. a will itself be a linear fractional transformation.
  </li>
<li> An output stream consisting of the digits of π.
  </li>
</ul>

Each step of the computation is a (recursive) call to the procedure action, which in turn calls one of two procedures:
<br>

**consume**: Multiply a on the right by the first element of strm and make that the new a. Replace strm by the stream you get when you  remove its first element.
<br>
**produce**: Extract the next decimal digit of π from a (and incorporate that digit in the output stream), and multiply a on the left by a linear fractional transformation that reflects the fact that it has “lost that value”.

## How to use
```
==>(load "pi.scm")
()
==>(display-n (pi) 6)
3 1 4 1 5 9 done
==>(display-n (pi) 100)
3 1 4 1 5 9 2 6 5 3 5 8 9 7 9 3 2 3 8 4 6 2 6 4 3 3 8 3 2 7 9 5 0 2 8 8 4 1 9 7 1 6 9 3 9 9 3 7 5 1 0 5 8 2 0 9 7 4 9 4 4 5 9 2 3 0 7 8 1 6 4 0 6 2 8 6 2 0 8 9 9 8 6 2 8 0 3 4 8 2 5 3 4 2 1 1 7 0 6 7 done
```
