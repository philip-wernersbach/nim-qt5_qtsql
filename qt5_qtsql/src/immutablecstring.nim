# immutablecstring.nim
# Part of nim-qt5_qtsql by Philip Wernersbach <philip.wernersbach@gmail.com>
#
# The MIT License (MIT)
#
# Copyright (c) 2015 Philip Wernersbach
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

type
    immutablecstring* = tuple
        mutableData: cstring

# umc stands for Unsafe Mutable Cast
template umc*(x: immutablecstring): expr =
    x.mutableData

template `==`*(x: immutablecstring, y: cstring): expr =
    x.umc() == y

template `==`*(x: cstring, y: immutablecstring): expr =
    y == x.umc()

template len*(x: immutablecstring): expr =
    x.umc().len()

# Doesn't work
# Not even called by runtime
#proc `$`*(x: immutablecstring): string =
#    var newS = newString(x.len())
#    var oldS = x.umc()
#    copyMem(addr(newS[0]), addr(oldS[0]), x.len())
#
#    return newS
