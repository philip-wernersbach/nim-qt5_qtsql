# qsqldatabase.nim
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

import qbytearray
import qstring
import qsqlerror
import qobjectconversionerror

const QSQLDATABASE_H = "<QtSql/QSqlDatabase>"

type
    QSqlDatabaseObj* {.final, header: QSQLDATABASE_H, importc: "QSqlDatabase".} = object
    InvalidQSqlDatabaseException* = object of SystemError

proc isValid*(self: QSqlDatabaseObj): bool {.header: QSQLDATABASE_H, importcpp: "isValid".}

# uc stands for Unsafe Cast
template qSqlDatabaseProcWithOneArgThatReturnsVoid(typ: typedesc, name: expr, importcppname: string) =
    proc `name`*(self: QSqlDatabaseObj, a: typ) {.header: QSQLDATABASE_H, importcpp: importcppname.}

template qSqlDatabaseProcThatReturnsVoid(name: expr, importcppname: string) =
    proc `name`*(self: QSqlDatabaseObj) {.header: QSQLDATABASE_H, importcpp: importcppname.}

proc internalQSqlDatabaseAddDatabase*(typ: cstring): QSqlDatabaseObj {.header: QSQLDATABASE_H, importcpp: "QSqlDatabase::addDatabase(@)".}
proc internalQSqlDatabaseAddDatabase*(typ: cstring, connectionName: cstring): QSqlDatabaseObj {.header: QSQLDATABASE_H, importcpp: "QSqlDatabase::addDatabase(@)".}
proc qSqlDatabaseRemoveDatabase*(connectionName: cstring) {.header: QSQLDATABASE_H, importcpp: "QSqlDatabase::removeDatabase(@)".}

template qSqlDatabaseAddDatabase(typ: cstring): QSqlDatabaseObj = #{.raises: [InvalidQSqlDatabaseException].}=
    var result = typ.internalQSqlDatabaseAddDatabase

    if unlikely(result.isValid == false):
        raise newException(InvalidQSqlDatabaseException, "QSqlDatabaseObj is invalid!")
    
    result

template qSqlDatabaseAddDatabase(typ: cstring, connectionName: cstring): QSqlDatabaseObj = #{.raises: [InvalidQSqlDatabaseException].} =
    var result = typ.internalQSqlDatabaseAddDatabase(connectionName)

    if unlikely(result.isValid == false):
        raise newException(InvalidQSqlDatabaseException, "QSqlDatabaseObj is invalid!")

    result

#proc cppNew(other: QSqlDatabase): ptr QSqlDatabaseObj {.header: QSQLDATABASE_H, importcpp: "new QSqlDatabase::QSqlDatabase(@)".}
#proc cppDelete(self: ptr QSqlDatabaseObj) {.header: QSQLDATABASE_H, importcpp: "delete @".}

template newQSqlDatabase*(typ: cstring): expr =
    qSqlDatabaseAddDatabase(typ)

template newQSqlDatabase*(typ: cstring, connectionName: cstring): expr =
    qSqlDatabaseAddDatabase(typ, connectionName)

#proc newQSqlDatabase*(typ: var cstring): QSqlDatabase =
#    var databaseStack = qSqlDatabaseAddDatabase(typ)
#    var databaseHeap = databaseStack.cppNew()
#    var database: QSqlDatabase
#    new(database)
#
#    database.up = databaseHeap
#
#    return database

#proc newQSqlDatabase*(typ: var cstring, connectionName: var cstring): QSqlDatabase =
#    var databaseStack = qSqlDatabaseAddDatabase(typ, connectionName)
#    var databaseHeap = databaseStack.cppNew()
#    var database: QSqlDatabase
#    new(database)
#
#    database.up = databaseHeap
#
#    return database

#proc destroy*(self: var QSqlDatabase) {.override.} =
#    self.up.cppDelete()
#    self.up = nil

proc internalGetQSqlDatabase*(connectionName: cstring, open = true): QSqlDatabaseObj {.header: QSQLDATABASE_H, importcpp: "QSqlDatabase::database(@)".}

template getQSqlDatabase*(connectionName: cstring, open = true): QSqlDatabaseObj = #{.raises: [InvalidQSqlDatabaseException].} =
    var result = connectionName.internalGetQSqlDatabase(open)

    if unlikely(result.isValid == false):
        raise newException(InvalidQSqlDatabaseException, "QSqlDatabaseObj is invalid!")
    
    result

proc internalOpen(self: QSqlDatabaseObj): bool {.header: QSQLDATABASE_H, importcpp: "open".}
proc internalOpen(self: QSqlDatabaseObj, user: cstring, password: cstring): bool {.header: QSQLDATABASE_H, importcpp: "open".}
proc lastError*(self: QSqlDatabaseObj): QSqlErrorObj {.header: QSQLDATABASE_H, importcpp: "lastError".}

proc internalTransaction(self: QSqlDatabaseObj): bool {.header: QSQLDATABASE_H, importcpp: "transaction".}
proc internalCommit(self: QSqlDatabaseObj): bool {.header: QSQLDATABASE_H, importcpp: "commit".}
proc internalRollback(self: QSqlDatabaseObj): bool {.header: QSQLDATABASE_H, importcpp: "rollback"}

template nativeErrorCodeCString*(self: QSqlErrorObj): expr =
    self.nativeErrorCode().toUtf8().constData()

template textCString*(self: QSqlErrorObj): expr =
    self.text().toUtf8().constData()

proc open*(self: var QSqlDatabaseObj): bool {.raises: [QSqlException, QObjectConversionError], discardable.} =
    result = self.internalOpen()

    if unlikely(result == false):
        raise newQSqlError(self.lastError())

proc open*(self: var QSqlDatabaseObj, user: cstring, password: cstring): bool {.raises: [QSqlException, QObjectConversionError], discardable.} =
    result = self.internalOpen(user, password)

    if unlikely(result == false):
        raise newQSqlError(self.lastError())

proc beginTransaction*(self: var QSqlDatabaseObj): bool {.raises: [QSqlException, QObjectConversionError], discardable.} =
    result = self.internalTransaction()

    if unlikely(result == false):
        raise newQSqlError(self.lastError())

proc commitTransaction*(self: var QSqlDatabaseObj): bool {.raises: [QSqlException, QObjectConversionError], discardable.} =
    result = self.internalCommit()

    if unlikely(result == false):
        raise newQSqlError(self.lastError())

proc rollback*(self: var QSqlDatabaseObj): bool {.raises: [QSqlException, QObjectConversionError], discardable.} =
    result = self.internalRollback()

    if unlikely(result == false):
        raise newQSqlError(self.lastError())

qSqlDatabaseProcWithOneArgThatReturnsVoid(cstring, setHostName, "setHostName")
qSqlDatabaseProcWithOneArgThatReturnsVoid(cint, setPort, "setPort")
qSqlDatabaseProcWithOneArgThatReturnsVoid(cstring, setDatabaseName, "setDatabaseName")

qSqlDatabaseProcThatReturnsVoid(close, "close")
