# Generic ORM — Lua Demo App

A todo-list application built with a custom socket-based HTTP server and lsqlite3, demonstrating the [Generic ORM](https://github.com/notactuallytreyanastasio/generic_orm) compiled from Temper to Lua.

## Stack

| Component | Technology |
|-----------|-----------|
| Framework | Custom TCP socket HTTP server |
| Templates | Inline HTML generation |
| Database | SQLite via lsqlite3 |
| ORM | [Generic ORM](https://github.com/notactuallytreyanastasio/generic_orm) (vendored) |
| Port | 5005 |

## ORM Usage

```lua
local orm = require("orm/src")

-- SELECT — type-safe query builder
local q = orm.from(orm.safeIdentifier("todos"))
    :where(where_fragment)
    :orderBy(orm.safeIdentifier("created_at"), true)
    :toSql():toString()

-- INSERT — changeset pipeline with field whitelisting
local cs = orm.changeset(table_def, params)
    :cast({orm.safeIdentifier("title"), orm.safeIdentifier("list_id")})
    :validateRequired({orm.safeIdentifier("title")})
local sql = cs:toInsertSql():toString()

-- DELETE — validated identifier
local sql = orm.deleteSql(table_def, id):toString()
```

## Security Model

- **Zero SQL injection vulnerabilities** — all queries generated through the ORM
- `safeIdentifier()` validates table/column names against `[a-zA-Z_][a-zA-Z0-9_]*`
- Sealed `SqlPart` hierarchy handles per-type value escaping
- `Changeset:cast()` enforces field whitelisting (CWE-915 prevention)
- No external web framework dependencies — custom HTTP implementation
- DDL (`CREATE TABLE`) is the only raw SQL — static strings with no user input

## Running

```bash
# Requires lsqlite3: luarocks install lsqlite3
lua app.lua
# Open http://localhost:5005
```

## Vendored ORM

The `vendor/` directory contains the ORM compiled from Temper to Lua modules. Updated automatically by CI when the ORM source changes.

---

Part of the [Generic ORM](https://github.com/notactuallytreyanastasio/generic_orm) project — write once in Temper, secure everywhere.
