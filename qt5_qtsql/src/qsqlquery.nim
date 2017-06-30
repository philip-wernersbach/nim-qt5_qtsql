# qsqlquery.nim
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
import qvariant
import qstring
import qsqlerror
import qsqldatabase
import qobjectconversionerror

const QSQLQUERY_H = "<QtSql/QSqlQuery>"

type
    QSqlQueryObj* {.final, header: QSQLQUERY_H, importc: "QSqlQuery".} = object

proc qSqlQuery*(db: var QSqlDatabaseObj): QSqlQueryObj {.header: QSQLQUERY_H, importcpp: "QSqlQuery::QSqlQuery(@)".}
proc qSqlQuery*(query: cstring, db: var QSqlDatabaseObj): QSqlQueryObj {.header: QSQLQUERY_H, importcpp: "QSqlQuery::QSqlQuery(@)"}

proc internalPrepare(self: QSqlQueryObj, query: cstring): bool {.header: QSQLQUERY_H, importcpp: "prepare".}

proc bindValue*(self: QSqlQueryObj, placeholder: cstring, val: QVariantObj) {.header: QSQLQUERY_H, importcpp: "bindValue"}
proc bindValue*[T](self: QSqlQueryObj, placeholder: cstring, cint, val: T) =
    when T is string:
        self.bindValue(placeholder, cstring(val).toQVariantObj())
    else:
        self.bindValue(placeholder, val.toQVariantObj())
proc bindValue*(self: QSqlQueryObj, pos: cint, val: QVariantObj) {.header: QSQLQUERY_H, importcpp: "bindValue"}
proc bindValue*[T](self: QSqlQueryObj, pos: cint, val: T) =
    when T is string:
        self.bindValue(pos, cstring(val).toQVariantObj())
    else:
        self.bindValue(pos, val.toQVariantObj())

proc internalExec(self: QSqlQueryObj, query: cstring): bool {.header: QSQLQUERY_H, importcpp: "exec"}
proc internalExec(self: QSqlQueryObj): bool {.header: QSQLQUERY_H, importcpp: "exec"}

proc lastError*(self: QSqlQueryObj): QSqlErrorObj {.header: QSQLQUERY_H, importcpp: "lastError".}

proc exec*(self: var QSqlQueryObj, query: cstring): bool {.raises: [QSqlException, QObjectConversionError], discardable.} =
    result = self.internalExec(query)

    if unlikely(result == false):
        raise newQSqlError(self.lastError())

proc exec*(self: var QSqlQueryObj): bool {.raises: [QSqlException, QObjectConversionError], discardable.} =
    result = self.internalExec()

    if unlikely(result == false):
        raise newQSqlError(self.lastError())

proc prepare*(self: var QSqlQueryObj, query: cstring): bool {.raises: [QSqlException, QObjectConversionError], discardable.} =
    result = self.internalPrepare(query)

    if unlikely(result == false):
        raise newQSqlError(self.lastError())

proc internalValue*(self: QSqlQueryObj, index: cint): QVariantObj {.header: QSQLQUERY_H, importcpp: "value".}
proc internalValue*(self: QSqlQueryObj, index: cstring): QVariantObj {.header: QSQLQUERY_H, importcpp: "value".}

proc next*(self: QSqlQueryObj): bool {.header: QSQLQUERY_H, importcpp: "next".}

when compileOption("boundChecks"):
    template value*(query: QSqlQueryObj, index: cint): QVariantObj = #{.raises: [IndexError].} =
        var result = query.internalValue(index)

        if unlikely(result.isValid == false):
            raise newException(IndexError, "Field " & $(index + 1) & " requested from current query record, but the field is invalid!")

        result

    template value*(query: QSqlQueryObj, name: cstring): QVariantObj = #{.raises: [IndexError].} =
        var result = query.internalValue(name)

        if unlikely(result.isValid == false):
            raise newException(IndexError, "Field with name \"" & $name & "\" requested from current query record, but the field is invalid!")

        result
else:
    template value*(query: QSqlQueryObj, index: cint): QVariantObj =
        query.internalValue(index)

    template value*(query: QSqlQueryObj, name: cstring): QVariantObj =
        query.internalValue(name)

proc isNull*(self: QSqlQueryObj, index: cint): bool {.header: QSQLQUERY_H, importcpp: "isNull".}
proc isNull*(self: QSqlQueryObj, name: cstring): bool {.header: QSQLQUERY_H, importcpp: "isNull".}
proc isValid*(self: QSqlQueryObj): bool {.header: QSQLQUERY_H, importcpp: "isValid".}
proc isActive*(self: QSqlQueryObj): bool {.header: QSQLQUERY_H, importcpp: "isActive".}
