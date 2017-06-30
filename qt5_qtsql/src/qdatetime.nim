# qdatetime.nim
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
import qtimezone
import qttimespec
import qobjectconversionerror

const QDATETIME_H = "<QtCore/QDateTime>"

type
    qint64* {.final, header: "<QtCore/QtGlobal>", importc: "qint64".} = clonglong
    QDateTimeObj* {.final, header: QDATETIME_H, importc: "QDateTime".} = object

proc newQDateTimeObj*(): QDateTimeObj {.header: QDATETIME_H, importcpp: "QDateTime".}
proc isNull*(dateTime: QDateTimeObj): bool {.header: QDATETIME_H, importcpp: "isNull".}
proc isValid*(dateTime: QDateTimeObj): bool {.header: QDATETIME_H, importcpp: "isValid".}
proc setMSecsSinceEpoch*(dateTime: var QDateTimeObj, msecs: qint64) {.header: QDATETIME_H, importcpp: "setMSecsSinceEpoch".}
proc setTimeSpec*(dateTime: var QDateTimeObj, timeSpec: QtTimeSpec) {.header: QDATETIME_H, importcpp: "setTimeSpec".}

# The newQDateTimeObj procs need to be templates to workaround a bug in the Nim compiler.
# When they are procs, Nim zeros the memory of the "result" variable, which is invalid in
# C++. (nim-lang/Nim#5140)
template newQDateTimeObj*(msecs: qint64): QDateTimeObj =
    var result = newQDateTimeObj()
    result.setMSecsSinceEpoch(msecs)

    result

template newQDateTimeObj*(msecs: qint64, timeSpec: QtTimeSpec): QDateTimeObj =
    var result = newQDateTimeObj()
    result.setTimeSpec(timeSpec)
    result.setMSecsSinceEpoch(msecs)

    result

proc currentQDateTimeUtc*(): QDateTimeObj {.header: QDATETIME_H, importcpp: "QDateTime::currentDateTimeUtc".}

proc internalToQStringObj*(dateTime: QDateTimeObj, format: cstring): QStringObj {.header: QDATETIME_H, importcpp: "toString".}
proc internalToMSecsSinceEpoch*(dateTime: QDateTimeObj): qint64 {.header: QDATETIME_H, importcpp: "toMSecsSinceEpoch".}

template toQStringObj*(dateTime: QDateTimeObj, format: cstring): QStringObj = #{.raises: [QObjectConversionError].} =
    var result = dateTime.internalToQStringObj(format)

    if unlikely(result.isEmpty == true):
        raise newException(QObjectConversionError, "Failed to convert QDateTimeObj to QStringObj!")

    result

proc toMSecsSinceEpoch*(dateTime: QDateTimeObj): qint64 {.raises: [QObjectConversionError].} =
    if unlikely(dateTime.isValid == false):
        raise newException(QObjectConversionError, "Failed to convert QDateTimeObj to qint64!")
    else:
        result = dateTime.internalToMSecsSinceEpoch

proc setTimeZone*(dateTime: QDateTimeObj, toZone: QTimeZoneObj) {.header: QDATETIME_H, importcpp: "setTimeZone".}
proc addMSecs*(a: var QDateTimeObj, b: qint64): QDateTimeObj {.header: QDATETIME_H, importcpp: "addMSecs".}

proc `<`*(a: QDateTimeObj, b: QDateTimeObj): bool {.header: QDATETIME_H, importcpp: "(# < #)".}
