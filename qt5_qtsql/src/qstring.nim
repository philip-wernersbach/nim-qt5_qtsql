# qstring.nim
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

import qbytearray
import qobjectconversionerror

const QSTRING_H = "<QtCore/QString>"

type
    QStringObj* {.final, header: QSTRING_H, importc: "QString".} = object

proc internalToUtf8*(self: QStringObj): QByteArrayObj {.header: QSTRING_H, importcpp: "toUtf8".}

# Qt recommends to always use isEmpty() and avoid isNull().
#
# See the "Distinction Between Null and Empty Strings" section of
# http://doc.qt.io/qt-5/qstring.html
proc isNull*(self: QStringObj): bool {.header: QSTRING_H, importcpp: "isNull".}
proc isEmpty*(self: QStringObj): bool {.header: QSTRING_H, importcpp: "isEmpty".}

template toUtf8*(self: QStringObj): QByteArrayObj = #{.raises: [QObjectConversionError].} =
    var result = self.internalToUtf8

    if unlikely(result.isNull == true):
        raise newException(QObjectConversionError, "Failed to convert QStringObj to UTF-8 QByteArrayObj!")

    result

proc `==`*(self: QStringObj, other: cstring): bool {.header: QSTRING_H, importcpp: "operator==".}
proc `==`*(self: QStringObj, other: var QByteArrayObj): bool {.header: QSTRING_H, importcpp: "operator==".}

template `!=`*(self: QStringObj, other: cstring): expr =
    !(self == other)

template `!=`*(self: QStringObj, other: var QByteArrayObj): expr =
    !(self == other)
