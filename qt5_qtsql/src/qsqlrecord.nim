# qsqlrecord.nim
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
import qvariant
import qsqlquery

const QSQLRECORD_H = "<QtSql/QSqlRecord>"

type
    QSqlRecordObj* {.final, header: QSQLRECORD_H, importc: "QSqlRecord".} = object

proc record*(query: QSqlQueryObj): QSqlRecordObj {.header: QSQLRECORD_H, importcpp: "record".}

proc count*(record: QSqlRecordObj): cint {.header: QSQLRECORD_H, importcpp: "count".}
proc fieldName*(record: QSqlRecordObj, index: cint): QStringObj {.header: QSQLRECORD_H, importcpp: "fieldName".}
proc value*(record: QSqlRecordObj, index: cint): QVariantObj {.header: QSQLRECORD_H, importcpp: "value".}
proc value*(record: QSqlRecordObj, name: cstring): QVariantObj {.header: QSQLRECORD_H, importcpp: "value".}
proc isNull*(record: QSqlRecordObj, index: cint): bool {.header: QSQLRECORD_H, importcpp: "isNull".}
