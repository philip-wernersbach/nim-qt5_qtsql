# sqlcat.nim
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

# This is a silly program that functions like the Unix utility cat. It reads lines
# from stdin, writes them to the database, reads them back, and outputs them to stdout.
#
# Even though no one would do this in the real world, it shows a lot of nim-qt5_qtsql's functionality.

import hashes

import qt5_qtsql

const DATABASE_DRIVER: cstring = "QSQLITE"
const CONNECTION_NAME_PREFIX = "sqlcat"
const DATABASE_NAME: cstring = "sqlcat.db"

const DROP_QUERY: cstring = "DROP TABLE IF EXISTS sqlcat;"
const CREATE_QUERY: cstring = """
CREATE TABLE sqlcat (
    hash INTEGER PRIMARY KEY NOT NULL,
    data TEXT
);
"""
const INSERT_QUERY: cstring = "INSERT INTO sqlcat VALUES (?, ?);"
const SELECT_QUERY: cstring = "SELECT data FROM sqlcat WHERE hash = ?;"

proc selectLines(database: var QSqlDatabaseObj, hash: int, callback: proc(x: QSqlQueryObj): bool): bool {.discardable.} =
    var selectQuery = database.qSqlQuery()

    selectQuery.prepare(SELECT_QUERY)
    selectQuery.bindValue(0, hash)
    selectQuery.exec()

    return callback(selectQuery)

proc insertLine(database: var QSqlDatabaseObj, line: string) =
    # Check if line already exists in database.
    let linesPresent = database.selectLines(line.hash(), proc(lines: QSqlQueryObj): bool =
        return lines.next()
    )

    if linesPresent == true:
        return

    var insertQuery = database.qSqlQuery()

    insertQuery.prepare(INSERT_QUERY)
    insertQuery.bindValue(0, line.hash())
    insertQuery.bindValue(1, line)
    insertQuery.exec()

try:
    var database = newQSqlDatabase(DATABASE_DRIVER, CONNECTION_NAME_PREFIX & "0")
    database.setDatabaseName(DATABASE_NAME)
    database.open()

    var dropQuery = database.qSqlQuery()
    dropQuery.prepare(DROP_QUERY)
    dropQuery.exec()

    var createQuery = database.qSqlQuery()
    createQuery.prepare(CREATE_QUERY)
    createQuery.exec()

    for line in stdin.lines:
        database.insertLine(line)

        database.selectLines(line.hash(), proc(lines: QSqlQueryObj): bool =
            while lines.next() == true:
                var dbLine = lines.value(0)

                # Qt's way to convert a QVariant to a char * is kind of hard, we should probably
                # provide a convience function for this.
                let dbLineString = dbLine.toQStringObj().toUtf8().constData().umc()
                echo dbLineString

            return true
        )

except QSqlException:
    let e = getCurrentException()
    stderr.write(e.getStackTrace())
    stderr.write("Error: unhandled exception: ")
    stderr.writeln(getCurrentExceptionMsg())

    stderr.writeln("")
    quit(QuitFailure)

quit(QuitSuccess)

# Database connection closes automatically when it goes out of scope.
