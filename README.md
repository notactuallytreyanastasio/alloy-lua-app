# Alloy Todo App -- Lua

A full-featured todo list manager built with a **raw socket HTTP server + lsqlite3** that demonstrates **every feature** of the [Alloy ORM](https://github.com/notactuallytreyanastasio/alloy) compiled from Temper to Lua. The app exercises **41+ ORM features** across 20 routes with a retro Mac System 6 + Windows 95 hybrid UI theme, including a dedicated SQL Showcase page that generates SQL for every single ORM method.

## Overview

This application is a complete, working todo list manager with lists, todos, tags, priorities, due dates, search, analytics, and a comprehensive SQL showcase. Every database interaction is built through the Alloy ORM's type-safe query builder and changeset validation pipeline. The HTTP server is implemented from scratch using LuaSocket -- no web framework dependencies at all.

The UI features a retro aesthetic blending Windows 95 chrome (beveled borders, grey panels, classic button styles) with a Mac System 6 desktop feel. Inline editing, confirmation dialogs, priority badges (color-coded 1-5), due date pickers, and tag chips are all supported.

## Data Model

Four tables with foreign key relationships:

```sql
lists (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT NOT NULL,
    description TEXT,
    created_at  TEXT DEFAULT (datetime('now'))
)

todos (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    title       TEXT NOT NULL,
    completed   INTEGER DEFAULT 0,
    priority    INTEGER DEFAULT 3,
    due_date    TEXT,
    list_id     INTEGER NOT NULL REFERENCES lists(id) ON DELETE CASCADE,
    created_at  TEXT DEFAULT (datetime('now'))
)

tags (
    id   INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
)

todo_tags (
    id      INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id INTEGER NOT NULL REFERENCES todos(id) ON DELETE CASCADE,
    tag_id  INTEGER NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    UNIQUE(todo_id, tag_id)
)
```

All four tables have corresponding `TableDef` and `FieldDef` schema definitions in `db.lua` using `safeIdentifier` for every table and column name.

## Complete ORM Feature Coverage

### Query Builder

| ORM Feature | Route / Location | Description |
|---|---|---|
| `from` | `GET /`, `GET /lists/{id}`, all queries | Start SELECT query on a table |
| `select` | `db.todos_get_list_id()`, `db.todos_get_distinct_priorities()` | Select specific columns |
| `selectExpr` | `GET /` (lists index), `GET /analytics` | Select with aggregate expressions and `col()` refs |
| `where` | `GET /lists/{id}`, `POST /todos/{id}/toggle` | WHERE with `SqlBuilder`-generated conditions |
| `orWhere` | `GET /analytics` (completed or urgent) | OR WHERE for compound conditions |
| `whereNull` | `GET /search` (no due date section) | `IS NULL` check on `due_date` |
| `whereNotNull` | `GET /search` (overdue section) | `IS NOT NULL` check on `due_date` |
| `whereIn` | `db.todos_get_by_priorities()` | `IN (values)` with `SqlInt32` list |
| `whereInSubquery` | `db.todos_in_lists_with_name()`, `GET /search` | `IN (SELECT ...)` for related table filtering |
| `whereNot` | `GET /search` (high priority), `db.todos_get_overdue()` | `NOT (condition)` for negation |
| `whereBetween` | `GET /search` (high priority range) | `BETWEEN low AND high` with `SqlInt32` bounds |
| `whereLike` | `GET /search?q=...` | `LIKE` pattern matching on title |
| `whereILike` | `GET /sql-showcase` | Case-insensitive `ILIKE` (SQL generation) |
| `orderBy` | `GET /lists/{id}`, `GET /tags` | `ORDER BY` with ASC/DESC control |
| `orderByNulls` | `GET /lists/{id}`, `GET /search` | `NULLS FIRST` / `NULLS LAST` ordering |
| `groupBy` | `GET /` (list counts), `GET /analytics` | `GROUP BY` for aggregate grouping |
| `having` | `GET /analytics` (lists with min todos) | `HAVING` with count threshold |
| `orHaving` | `GET /analytics` (compound group filters) | `OR HAVING` for alternative conditions |
| `limit` | `GET /lists/{id}` (single lookup), `GET /search` | `LIMIT n` for result capping |
| `offset` | `GET /search` (high priority pagination) | `OFFSET n` for pagination |
| `distinct` | `GET /analytics` (distinct priorities) | `SELECT DISTINCT` for unique values |
| `lock (ForUpdate)` | `GET /sql-showcase` | `FOR UPDATE` row-level locking (SQL generation) |
| `lock (ForShare)` | `GET /sql-showcase` | `FOR SHARE` row-level locking (SQL generation) |
| `countSql` | `GET /analytics` (total count) | `SELECT COUNT(*)` variant |
| `safeToSql` | `GET /sql-showcase` | Query with enforced default limit |
| `toSql` | All routes | Convert query to `SqlFragment` for execution |

### Joins

| ORM Feature | Route / Location | Description |
|---|---|---|
| `innerJoin` | `GET /tags/{id}`, `GET /lists/{id}` (tag lookup) | Todos joined with tags through todo_tags |
| `leftJoin` | `GET /` (lists with counts) | Lists left-joined with todos for counts |
| `rightJoin` | `GET /sql-showcase` | SQL generation demo (RIGHT JOIN) |
| `fullJoin` | `GET /sql-showcase` | SQL generation demo (FULL OUTER JOIN) |
| `crossJoin` | `GET /sql-showcase` | SQL generation demo (CROSS JOIN) |

### Aggregates

| ORM Feature | Route / Location | Description |
|---|---|---|
| `countAll` | `GET /` (list counts), `GET /analytics` | `COUNT(*)` for total counts |
| `countCol` | `GET /analytics` (priority stats) | `COUNT(column)` for non-null counts |
| `sumCol` | `GET /analytics` (priority sum) | `SUM(priority)` across all todos |
| `avgCol` | `GET /analytics` (average priority) | `AVG(priority)` average computation |
| `minCol` | `GET /analytics` (min priority) | `MIN(priority)` minimum value |
| `maxCol` | `GET /analytics` (max priority) | `MAX(priority)` maximum value |

### Set Operations

| ORM Feature | Route / Location | Description |
|---|---|---|
| `unionSql` | `GET /analytics` | UNION of completed from list A + incomplete from list B |
| `unionAllSql` | `GET /sql-showcase` | UNION ALL (preserves duplicates) |
| `intersectSql` | `GET /analytics` | INTERSECT -- priority 1 AND completed |
| `exceptSql` | `GET /analytics` | EXCEPT -- priority 1 but NOT completed |

### Subqueries

| ORM Feature | Route / Location | Description |
|---|---|---|
| `subquery` | `db.todos_subquery_demo()`, `GET /sql-showcase` | Wrap query as derived table with alias |
| `existsSql` | `db.todos_exists_demo()`, `GET /search` | `EXISTS (SELECT ...)` for existence checks |

### Mutations

| ORM Feature | Route / Location | Description |
|---|---|---|
| `update().set().where().toSql()` | `POST /todos/{id}/toggle`, `POST /todos/{id}/priority` | UPDATE with `SqlInt32` / `SqlString` values |
| `deleteFrom().where().toSql()` | `POST /lists/{id}/delete-completed`, `POST /todos/{id}/untag/{tid}` | DELETE with WHERE conditions |
| `deleteSql` | `POST /lists/{id}/delete`, `POST /tags/{id}/delete` | Quick DELETE by primary key ID |

### Changeset Validation

| ORM Feature | Route / Location | Description |
|---|---|---|
| `changeset` | `POST /lists`, `POST /lists/{id}/todos`, `POST /tags` | Create changeset from TableDef + params |
| `cast` | All POST routes | Whitelist allowed fields |
| `validateRequired` | `POST /lists`, `POST /lists/{id}/todos` | Non-empty field check |
| `validateLength` | `POST /lists`, `POST /lists/{id}/todos`, `POST /tags` | Min/max string length |
| `validateInt` | `POST /lists/{id}/todos`, `POST /todos/{id}/tag` | Integer parsing validation |
| `validateInt64` | `GET /validations` | 64-bit integer validation demo |
| `validateFloat` | `GET /validations` | Float parsing validation demo |
| `validateBool` | `GET /validations` | Boolean parsing validation demo |
| `validateInclusion` | Seed data (`insert_todo`) | Value must be in allowed list |
| `validateExclusion` | `POST /tags`, seed data | Value must NOT be in blocked list |
| `validateNumber` | `POST /lists/{id}/todos`, seed data | Numeric range with `NumberValidationOpts` |
| `validateAcceptance` | `GET /validations` | Must be truthy ("true", "1", "yes") |
| `validateConfirmation` | `GET /validations` | Two fields must match |
| `validateContains` | `GET /validations` | String must contain substring |
| `validateStartsWith` | `GET /validations` | String must start with prefix |
| `validateEndsWith` | `GET /validations` | String must end with suffix |
| `putChange` | `db.lists_update()` | Programmatically set a changeset value |
| `getChange` | `db.lists_update()` | Read back a changeset value |
| `deleteChange` | `db.lists_update()` | Remove a change from the changeset |
| `toInsertSql` | All create routes | Generate INSERT SQL |
| `toUpdateSql` | `POST /lists/{id}/update` | Generate UPDATE SQL for a given ID |

### Types Used

| Type | Usage |
|---|---|
| `SafeIdentifier` | Every table and column name (`safeIdentifier()`) |
| `TableDef` | Schema for `lists`, `todos`, `tags`, `todo_tags` |
| `FieldDef` | Each column in every table |
| `StringField` | `name`, `title`, `description`, `due_date`, `created_at` |
| `IntField` | `completed`, `priority`, `list_id`, `todo_id`, `tag_id` |
| `Int64Field` | 64-bit integer demo in validations |
| `FloatField` | Float demo in validations |
| `BoolField` | Boolean demo in validations |
| `DateField` | Date type (available for schema definitions) |
| `SqlBuilder` | Manual fragment construction (join conditions, WHERE clauses, expressions) |
| `SqlFragment` | Immutable SQL fragments from `toSql()` |
| `SqlString` | Parameterized string values in SET clauses and WHERE |
| `SqlInt32` | Parameterized integer values (priority, completed toggle) |
| `SqlInt64` | 64-bit integer values (available) |
| `SqlFloat64` | Float values (used in `showcase_all_sql` manual builder demo) |
| `SqlBoolean` | Boolean values (used in `showcase_all_sql` manual builder demo) |
| `SqlDate` | Date type (available) |
| `SqlDefault` | SQL DEFAULT keyword type |
| `SqlSource` | Raw safe SQL source fragments |
| `NumberValidationOpts` | Priority range validation (1-5) |
| `NullsFirst` | NULLS FIRST ordering mode |
| `NullsLast` | NULLS LAST ordering mode (used in todo listing) |
| `ForUpdate` | FOR UPDATE lock mode |
| `ForShare` | FOR SHARE lock mode |

## Route Reference

| Route | Method | Description | Key ORM Features |
|---|---|---|---|
| `/` | GET | Lists index with todo counts | `from`, `leftJoin`, `selectExpr`, `groupBy`, `orderBy`, `col` |
| `/lists` | POST | Create a new list | `changeset`, `cast`, `validateRequired`, `validateLength`, `toInsertSql` |
| `/lists/{id}` | GET | Show list with todos | `from`, `where`, `orderBy`, `orderByNulls`, `NullsLast`, `innerJoin` |
| `/lists/{id}/todos` | POST | Create todo with validation | `changeset`, `cast`, `validateRequired`, `validateLength`, `validateInt`, `validateNumber`, `validateInclusion`, `toInsertSql` |
| `/lists/{id}/delete` | POST | Delete list | `deleteSql` |
| `/lists/{id}/delete-completed` | POST | Delete completed todos | `deleteFrom`, `where` (compound), `toSql` |
| `/lists/{id}/update` | POST | Update list | `changeset`, `putChange`, `getChange`, `deleteChange`, `toUpdateSql` |
| `/todos/{id}/toggle` | POST | Toggle completed | `update`, `set`, `where`, `SqlInt32` |
| `/todos/{id}/delete` | POST | Delete todo | `deleteSql` |
| `/todos/{id}/priority` | POST | Update priority | `update`, `set` with `SqlInt32`, `where` |
| `/todos/{id}/tag` | POST | Add tag to todo | `changeset`, `validateRequired`, `validateInt`, `toInsertSql` |
| `/todos/{id}/untag/{tid}` | POST | Remove tag | `deleteFrom` with compound `where` |
| `/tags` | GET | Tags list | `from`, `orderBy` |
| `/tags` | POST | Create tag | `changeset`, `validateExclusion`, `validateLength`, `toInsertSql` |
| `/tags/{id}` | GET | Tag detail with todos | `from`, `innerJoin` (chained), `where` |
| `/tags/{id}/delete` | POST | Delete tag | `deleteSql` |
| `/search` | GET | Search with multiple modes | `whereLike`, `whereNot`, `whereNotNull`, `whereNull`, `whereBetween`, `whereIn`, `whereInSubquery`, `existsSql`, `offset` |
| `/analytics` | GET | Aggregate analytics | `countAll`, `countCol`, `sumCol`, `avgCol`, `minCol`, `maxCol`, `groupBy`, `having`, `orHaving`, `distinct`, `unionSql`, `intersectSql`, `exceptSql`, `orWhere` |
| `/sql-showcase` | GET | SQL Lab (all 40+ features) | Every single ORM method generates and displays SQL |
| `/validations` | GET | Validator demos | `validateFloat`, `validateBool`, `validateAcceptance`, `validateConfirmation`, `validateContains`, `validateStartsWith`, `validateEndsWith`, `validateInt64` |

## Code Examples

### Query Builder -- Left Join with Aggregates

```lua
-- From db.lua -- lists with todo counts using leftJoin + selectExpr + col()
local lid  = col(lists_id, id_col)
local lname = col(lists_id, name_col)

local q = from(lists_id)
    :leftJoin(todos_id, join_cond)
    :selectExpr(temper.listof(lid, lname, total_expr, done_expr))
    :groupBy(safeIdentifier("lists__id"))
    :orderBy(created_at_col, false)
```

### Changeset -- Full Validation Pipeline

```lua
-- From db.lua -- insert a todo with full validation chain
local cs = changeset(todos_table, params)
cs = cs:cast(cast_fields)
cs = cs:validateRequired(temper.listof(title_col, list_id_col))
cs = cs:validateLength(title_col, 1, 200)
cs = cs:validateInt(completed_col)
cs = cs:validateInt(priority_col)
cs = cs:validateNumber(priority_col,
    NumberValidationOpts(temper.null, temper.null, 1.0, 5.0, temper.null))
cs = cs:validateInclusion(completed_col, temper.listof("0", "1"))
local sql = cs:toInsertSql():toString()
conn:exec(sql)
```

### Set Operations -- Union, Intersect, Except

```lua
-- From db.lua -- set operations between filtered queries
local q1 = from(todos_id):where(where_eq_int("priority", 1))
local q2 = from(todos_id):where(where_eq_int("completed", 1))

local union_sql     = unionSql(q1, q2):toString()
local intersect_sql = intersectSql(q1, q2):toString()
local except_sql    = exceptSql(q1, q2):toString()
```

### SQL Showcase -- SqlBuilder Manual Construction

```lua
-- From db.lua -- build SQL manually with typed values
local b = SqlBuilder()
b:appendSafe("SELECT ")
b:appendString("hello")
b:appendSafe(", ")
b:appendInt32(42)
b:appendSafe(", ")
b:appendFloat64(3.14)
b:appendSafe(", ")
b:appendBoolean(true)
-- Produces: SELECT 'hello', 42, 3.14, TRUE
```

## Security Model

The Alloy ORM enforces **5 layers of defense** against SQL injection and mass-assignment attacks:

1. **SafeIdentifier** -- Table and column names are validated against `[a-zA-Z_][a-zA-Z0-9_]*` at construction time. Invalid identifiers throw immediately.
2. **SqlBuilder / SqlFragment** -- All values are type-dispatched through `SqlPart` variants (`SqlString`, `SqlInt32`, `SqlFloat64`, etc.) that handle escaping per type. No string interpolation.
3. **Changeset `cast()`** -- Field whitelisting prevents mass-assignment (CWE-915). Only explicitly listed fields are accepted from user input.
4. **Changeset validators** -- 15 validators catch invalid data before any SQL is generated. Invalid changesets refuse to produce SQL.
5. **No raw SQL with user input** -- DDL (`CREATE TABLE`) is the only raw SQL in the codebase, using static strings with zero user input.

For the full MITRE CWE analysis, see [SECURITY_ANALYSIS.md](SECURITY_ANALYSIS.md) or the [main Alloy repository](https://github.com/notactuallytreyanastasio/alloy).

## Running the App

### Prerequisites

- Lua 5.1+ or LuaJIT
- LuaSocket (`luarocks install luasocket`)
- lsqlite3 (`luarocks install lsqlite3complete`)

### Run

```bash
lua app.lua
```

The app starts at **http://localhost:5005** with seeded sample data (3 lists, 13 todos, 5 tags).

## Source

- **Alloy ORM (Temper source):** [github.com/notactuallytreyanastasio/alloy](https://github.com/notactuallytreyanastasio/alloy)
- **Compiled Lua library:** [github.com/notactuallytreyanastasio/alloy-lua](https://github.com/notactuallytreyanastasio/alloy-lua)

The `vendor/` directory contains the ORM compiled from Temper to Lua modules. Updated automatically by CI when the ORM source changes.

---

Part of the [Alloy](https://github.com/notactuallytreyanastasio/alloy) project -- write once in Temper, compile to Java/Python/Lua/JS, secure everywhere.
