# Aprendiendo PostgreSQL

## Manejo De DB

* **Crear:** `CREATE DATABASE {nombre};`
* **Listar:** `\l`
* **Conectar:** `\c {db}`
* **Renombrar:** `ALTER DATABASE {db} RENAME TO {nombre}`
* **Eliminar:** `DROP DATABASE {db}`

## Manejo De Tabla

* **Crear:** `CREATE TABLE {nombre}({nombre_var} {TIPO} {ATRIBUTOS}, …)`
* **Listar:** `\d` para todas, `\d {tabla}`.
* **Eliminar:** `DROP TABLE {tabla}`
* **Tipos de datos:**
	* `INT`
	* `VARCHAR({max})`
	* `SERIAL`: INT NOT NULL AUTOINCREMENTABLE
	* `NUMERIC({digit}, {decimal})`: FLOAT
* **Tipos de atributos:**
	* `NOT NULL`
	* `UNIQUE`: No se puede repetir
	* `PRIMARY KEY:` UNIQUE NOT NULL ONE PER TABLE
	* `FORAIGN KEY`: Relaciona tipos de datos de otra tabla
* **Agregar columna:** `ALTER TABLE {tabla} ADD COLUMN {nombre} {TIPO}`
* **Editar nombre columna:** `ALTER TABLE {tabla} RENAME COLUMN {nombre} TO {nuevo}`
* **Editar TIPO columna:** `ALTER TABLE {tabla} ALTER COLUMN {columna} TYPE {tipo}`
* **Eliminar columna:** `ALTER TABLE {tabla} DROP COLUMN {nombre}`
* **Convertir en PRIMARY KEY:** `ALTER TABLE {tabla} ADD PRIMARY KEY({columna})`
	* Tambien sirve para hacerlos **UNIQUE**
* **Convertir en Foreign Key:** `ALTER TABLE {tabla} ADD FOREIGN KEY({columna}) REFERENCES {tabla}({columna})`
* **Remover constraint (PK, FK):** `ALTER TABLE {tabla} DROP CONSTRAINT {valor_primary}`
* **Convertir en Foreign Key:** `ALTER TABLE {tabla} ADD COLUMN {nombre} {tipo} REFERENCES {tabla({columna})}`
* **UNIQUE FORAIGN KEY:** `ALTER TABLE {tabla} ADD UNIQUE({columna})`, teniendo _relacion 1-1_

## Manejo De Datos

* **Agregar:** `INSERT INTO {tabla}({…columnas}) VALUES({…valores})`
* **Eliminar:** `DELETE FROM {tabla} WHERE {condicion}`
* **Editar:** `UPDATE {table} SET {columna}={valor} WHERE {condition}`
* **Seleccionar:** `SELECT {…columnas} FROM {table}`
* **Seleccionar (ordenado):** `SELECT * FROM {table} ORDER BY {columna}` Se puede agregar `DESC` para orden inverso.
	* **Limitando resultados:** `LIMIT {cantidad}`
* **Cambiar mayúsculas:** `UPPER()` y `LOWER()`

## Búsqueda Avanzada

* **Operadores:** `SELECT {columna} FROM {tabla} WHERE {columna}>='D'`, Se pueden usar los operadores `=`, `!=`, `>`, `>=`, `<`, `<=`.
* **Múltiples condiciones:** Se pueden usar los operadores `OR` y `AND`, ej. `SELECT * FROM students WHERE last_name < 'M' AND (gpa=3.9 OR gpa < 2.3)`
* **Patrones:** `SELECT {columna} FROM {tabla} WHERE {columna} LIKE {patron}`
	* Patrón puede usar `_` como place holder para una letra, ej. `_lgorithms`.
	* Patrón puede usar `%` como place holder para cualquier cosa, no solo una letra, ej. `%thms`.
	* `NOT LIKE`
	* `ILIKE`: Ignora case
	* `IS NULL`: Esta vacio
* **Minimo:** `SELECT MIN({columna}) FROM {table}`
* **Maximo:** `SELECT MAX({columna}) FROM {table}`
* **Sumatoria:** `SELECT SUM({columna}) FROM {table}`
* **Promedio:** `SELECT AVG({columna}) FROM {table}`
* **Redondeo:** `SELECT CEIL(AVG({columna})) FROM {table}`, tambien se puede usar `FLOOR()` y `ROUND({numero}, {decimales})`
* **Conteo:** `SELECT COUNT({columna}) FROM {table}` se puede usar como columna `*`
* **Distinción:** `SELECT DISTINCT({columna}) FROM {table}`, _la diferencia con COUNT es que este no muestra repetidos_
* **GROUP BY:** `SELECT {columna} FROM {table} GROUP BY {columna}`, parecido a _DISTINCT pero aca se puede usar MAX, MIN, COUNT,…_
* **HAVING:** `SELECT {COLUMNA} FROM {table} GROUP BY {columna} HAVING {condicion}`
* **Renombrar columna:** `SELECT {columna} AS {nombre} FROM {table}`
* **Renombrar tabla:** `SELECT {columna} FROM {table} AS {nombre}`
* **Unir tablas:** En caso de tener _Foraign Key_ se puede unir haciendo `SELECT * FROM {tabla1} FULL JOIN {tabla2} ON {tabla1}.{columna} = {tabla2}.{columna}`
	* Se puede usar `LEFT JOIN` solo muestra de la `{tabla2}` si tienen `FK` en `{tabla1}`
	* Se puede usar `RIGHT JOIN` solo muestra de la `{tabla1}` si tienen `FK` en `{tabla2}`
	* Se puede usar `INNER JOIN` solo muestra los que estén en la `{tabla1}` y `{tabla2}` al mismo tiempo
	* **Shortcut:** `SELECT * FROM {tabla1} FULL JOIN {tabla2} USING({columna})`

## Bash

* **Shebang:** `#!/bin/bash`
* **Hacer script ejecutable:** `chmod +x script.sh`
* **IFS:** Internal Field Separator se usa para leer o parsear, `IFS=','`
* **PSQL:** `PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"`
* **Split string a array:** `IFS='<delimitador>' read -r -a <array> <<< "<string>"`
	* `-r`: Para no tratar `\` como _escape chracter_
	* `-a`: Para hacer un _split_ en el _array_ `<array>`
	* Tambien se puede hacer `IFS='<delimitador>' read -r <v1> <v2> <v..> <<< "<string>"`

> [!note] Resumen
> La mayoría de los apuntes los tome de [esta web](https://devhints.io/bash)
