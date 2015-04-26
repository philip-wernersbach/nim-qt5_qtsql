# nim-qt5_qtsql
Nim binding for Qt 5's Qt SQL library that integrates with the features of the
Nim language.

##Features
* Production-ready
* All of the features that you would expect from Qt SQL
	* Such as a single API for multiple database engines
	* And support for prepared statements
* Utilizes features of the Nim language for easier usage
* Avoids complexity by utilizing C++'s type system
	* For instance, instead of providing full bindings for `QVariant`, this
	provides a minimal binding and lets C++'s type system take care of
	converting to and from `QVariant` objects automatically.

##Known Limitations
* Qt SQL does not deep copy `QSqlQuery` objects, so they must be kept in scope
on the stack during usage.

##Usage
See [`qt5_qtsql/tests/sqlcat.nim`](qt5_qtsql/tests/sqlcat.nim) for an example
program that reads and writes a SQLite database.

##License
This project is licensed under the MIT License. For full license text, see
[`LICENSE`](LICENSE).
