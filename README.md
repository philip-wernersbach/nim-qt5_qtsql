# nim-qt5_qtsql
Nim binding for Qt 5's Qt SQL library that integrates with the features of the
Nim language.

## Features
* Production-ready
* All of the features that you would expect from Qt SQL
	* Such as a single API for multiple database engines
	* And support for prepared statements
* Utilizes features of the Nim language for easier usage
* Avoids complexity by utilizing C++'s type system
	* For instance, instead of providing full bindings for `QVariant`, this
	provides a minimal binding and lets C++'s type system take care of
	converting to and from `QVariant` objects automatically.
* Abstracts certain Qt behaviors that are not Nim-like, and presents a
Nim-like API.

## Qt Type Conversions
Qt uses a system of default values, null properties, and invalid properties to
indicate the failure of a type conversion. The objects and values produced by
failed conversions often function like regular objects and values, but produce 
unexpected results when used. This behavior leads to a silent failure
situation if the result of a Qt type conversion is not checked properly by the
program.

In Nim, most type conversion errors are not possible due to the type system
and compiler checks. When it is impossible for a type conversion error to be
checked at runtime, the Nim runtime and most Nim procedures will raise
exceptions, which prevents silent failure situations.

`nim-qt5_qtsql` abstracts the Qt behavior and changes it to the Nim behavior.
When possible, the binding checks for default values, null properties, and
invalid properties after Qt type conversions. If these are present, the
binding will throw a `QObjectConversionError`, which inherits from Nim's
`ObjectConversionError`. Default values, null properties, and invalid
properties are only checked for type conversions. Programs can still
purposefully create Qt objects with default values, null properties, and
invalid properties.

## Known Limitations
* Qt SQL does not deep copy `QSqlQuery` objects, so they must be kept in scope
on the stack during usage.
* Automatic conversions from Qt types to Nim types are temporarily disabled in
version 1.1.x of the binding.
	* The Nim 0.17.0 compiler produces buggy code for procedures that return
	C++ objects. This has been worked around, but the work around requires
	changing `converter`s to `proc`s, which disables automatic conversion.
	Manual conversion is still possible by calling the conversion procedures
	in the binding.
		* See [nim-lang/Nim#5140](https://github.com/nim-lang/Nim/issues/5140)
		for more details.

## Usage
See [`qt5_qtsql/tests/sqlcat.nim`](qt5_qtsql/tests/sqlcat.nim) for an example
program that reads and writes a SQLite database.

## License
This project is licensed under the MIT License. For full license text, see
[`LICENSE`](LICENSE).
