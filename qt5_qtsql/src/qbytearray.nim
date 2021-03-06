# qbytearray.nim
# Part of nim-qt5_qtsql by Philip Wernersbach <philip.wernersbach@gmail.com>
#
# The MIT License (MIT)
#
# Copyright (c) 2016 Philip Wernersbach
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

import immutablecstring
import qobjectconversionerror

const QBYTEARRAY_H = "<QtCore/QByteArray>"

type
    QByteArrayObj* {.final, header: QBYTEARRAY_H, importc: "QByteArray".} = object

proc isNull*(self: QByteArrayObj): bool {.header: QBYTEARRAY_H, importcpp: "isNull".}
proc isEmpty*(self: QByteArrayObj): bool {.header: QBYTEARRAY_H, importcpp: "isEmpty".}

#proc constDataUnsafe(self: QByteArrayObj): cstring {.header: QBYTEARRAY_H, importcpp: "constData".}
proc constData*(self: QByteArrayObj): immutablecstring {.raises: [QObjectConversionError].} =
    var mutableData: cstring

    if unlikely(self.isNull == true):
        raise newException(QObjectConversionError, "Failed to convert QByteArrayObj to immutablecstring, QByteArrayObj is null!")

    {.emit: "`mutabledata` = (char *)`self`.constData();".}

    return (mutableData: mutableData)
