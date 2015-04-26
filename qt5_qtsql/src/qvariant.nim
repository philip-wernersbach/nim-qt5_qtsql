# qvariant.nim
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

import qstring

const QVARIANT_H = "<QtCore/QVariant>"

type
    qulonglong* {.final, importc: "qulonglong"} = culonglong
    qlonglong* {.final, importc: "qulonglong"} = clonglong
    QVariantObj* {.final, header: QVARIANT_H, importc: "QVariant".} = object

proc internalToQulonglong(x: QVariantObj, ok: ptr bool): qulonglong {.header: QVARIANT_H, importcpp: "toULongLong"}
proc internalToQlonglong(x: QVariantObj, ok: ptr bool): qlonglong {.header: QVARIANT_H, importcpp: "toLongLong"}

converter toQStringObj*(x: QVariantObj): QStringObj {.header: QVARIANT_H, importcpp: "toString".}

converter toQulonglong*(x: QVariantObj): qulonglong {.raises: [ObjectConversionError]} =
    var ok: bool = false
    var data = x.internalToQuLongLong(addr(ok))

    if ok != true:
        raise newException(ObjectConversionError, "Failed to convert QVariantObj to qulonglong!")
    else:
        return data

converter toQlonglong*(x: QVariantObj): qlonglong {.raises: [ObjectConversionError]} =
    var ok: bool = false
    var data = x.internalToQLongLong(addr(ok))

    if ok != true:
        raise newException(ObjectConversionError, "Failed to convert QVariantObj to qlonglong!")
    else:
        return data

proc toQVariantObj*[T](x: T): QVariantObj {.header: QVARIANT_H, importcpp: "QVariant::QVariant(@)"}
