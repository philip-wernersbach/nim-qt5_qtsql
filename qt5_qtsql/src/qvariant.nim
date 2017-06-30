# qvariant.nim
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

import qstring
import qdatetime
import qobjectconversionerror

const QVARIANT_H = "<QtCore/QVariant>"

type
    qulonglong* {.final, importc: "qulonglong"} = culonglong
    qlonglong* {.final, importc: "qulonglong"} = clonglong
    QVariantObj* {.final, header: QVARIANT_H, importc: "QVariant".} = object

proc internalToQulonglong*(x: QVariantObj, ok: ptr bool): qulonglong {.header: QVARIANT_H, importcpp: "toULongLong"}
proc internalToQlonglong*(x: QVariantObj, ok: ptr bool): qlonglong {.header: QVARIANT_H, importcpp: "toLongLong"}
proc internalToQStringObj*(x: QVariantObj): QStringObj {.header: QVARIANT_H, importcpp: "toString".}
proc internalToQDateTimeObj*(variant: QVariantObj): QDateTimeObj {.header: QVARIANT_H, importcpp: "toDateTime"}
proc internalToBool*(variant: QVariantObj): bool {.header: QVARIANT_H, importcpp: "toBool"}
proc internalToFloat*(variant: QVariantObj, ok: ptr bool): float64 {.header: QVARIANT_H, importcpp: "toFloat"}
proc internalToDouble*(variant: QVariantObj, ok: ptr bool): float64 {.header: QVARIANT_H, importcpp: "toDouble"}
proc internalToQVariantObj*[T](x: T): QVariantObj {.header: QVARIANT_H, importcpp: "QVariant::QVariant(@)"}

proc isNull*(variant: QVariantObj): bool {.header: QVARIANT_H, importcpp: "isNull".}
proc isValid*(variant: QVariantObj): bool {.header: QVARIANT_H, importcpp: "isValid".}
proc canConvert*(variant: QVariantObj, typ: typedesc): bool {.header: QVARIANT_H, importcpp: "#.canConvert<'*2>()".}

template toQStringObj*(variant: QVariantObj): QStringObj = #{.raises: [QObjectConversionError]} =
    if unlikely(variant.canConvert(QStringObj) == false):
        raise newException(QObjectConversionError, "Failed to convert QVariantObj to QStringObj!")
    
    variant.internalToQStringObj

template toQDateTimeObj*(variant: QVariantObj): QDateTimeObj = #{.raises: [QObjectConversionError]} =
    var result: QDateTimeObj

    if unlikely(variant.canConvert(QDateTimeObj) == false):
        raise newException(QObjectConversionError, "Failed to convert QVariantObj to QDateTimeObj!")
    else:
        result = variant.internalToQDateTimeObj

        if unlikely(result.isValid == false):
            raise newException(QObjectConversionError, "Failed to convert QVariantObj to QDateTimeObj!")

    result

converter toBool*(variant: QVariantObj): bool {.raises: [QObjectConversionError]} =
    if unlikely(variant.canConvert(bool) == false):
        raise newException(QObjectConversionError, "Failed to convert QVariantObj to bool!")
    else:
        result = variant.internalToBool

proc toFloat*(variant: QVariantObj): float64 {.raises: [QObjectConversionError]} =
    if unlikely(variant.canConvert(float64) == false):
        raise newException(QObjectConversionError, "Failed to convert QVariantObj to float64 via toFloat!")
    else:
        var ok: bool = false
        result = variant.internalToFloat(addr(ok))

        if unlikely(ok == false):
            raise newException(QObjectConversionError, "Failed to convert QVariantObj to float64 via toFloat!")

proc toDouble*(variant: QVariantObj): float64 {.raises: [QObjectConversionError]} =
    if unlikely(variant.canConvert(float64) == false):
        raise newException(QObjectConversionError, "Failed to convert QVariantObj to float64 via toDouble!")
    else:
        var ok: bool = false
        result = variant.internalToDouble(addr(ok))

        if unlikely(ok == false):
            raise newException(QObjectConversionError, "Failed to convert QVariantObj to float64 via toDouble!")

proc toQulonglong*(variant: QVariantObj): qulonglong {.raises: [QObjectConversionError]} =
    if unlikely(variant.canConvert(qulonglong) == false):
        raise newException(QObjectConversionError, "Failed to convert QVariantObj to qulonglong!")
    else:
        var ok: bool = false
        result = variant.internalToQulonglong(addr(ok))

        if unlikely(ok == false):
            raise newException(QObjectConversionError, "Failed to convert QVariantObj to qulonglong!")

proc toQlonglong*(variant: QVariantObj): qlonglong {.raises: [QObjectConversionError]} =
    if unlikely(variant.canConvert(qlonglong) == false):
        raise newException(QObjectConversionError, "Failed to convert QVariantObj to qulonglong!")
    else:
        var ok: bool = false
        result = variant.internalToQlonglong(addr(ok))

        if unlikely(ok == false):
            raise newException(QObjectConversionError, "Failed to convert QVariantObj to qulonglong!")

template toQVariantObj*[T](x: T): QVariantObj = #{.raises: [QObjectConversionError]} =
    var result = x.internalToQVariantObj

    if unlikely(result.isValid == false):
        raise newException(QObjectConversionError, "Failed to convert value to QVariantObj!")

    result

proc userType*(variant: QVariantObj): cint {.header: QVARIANT_H, importcpp: "userType".}
