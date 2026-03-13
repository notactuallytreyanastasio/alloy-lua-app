# SQL Security Analysis: Lua Todo App

SQL injection analysis of the Lua todo app built on the Generic Temper ORM. This analysis focuses exclusively on SQL generation and execution — the core value proposition of the ORM.

**Analysis Date:** 2026-03-12
**Framework:** Raw socket HTTP server + lsqlite3
**ORM:** Generic Temper ORM (compiled to Lua)

---

## How This App Uses the ORM

All user-facing CRUD operations flow through the Temper ORM's type-safe SQL generation:

| Operation | Method | SQL Source |
|-----------|--------|------------|
| SELECT lists/todos | `from(safeIdentifier("...")):where(...):toSql()` | ORM |
| INSERT list/todo | `changeset(table, params):cast(fields):validateRequired(fields):toInsertSql()` | ORM |
| DELETE list/todo | `deleteSql(table, id)` | ORM |
| WHERE clauses | `SqlBuilder:appendSafe()` + `:appendInt32()` | ORM |
| Toggle completed | `UPDATE todos SET completed = 1 - completed WHERE id = ?` | Raw (parameterized) |
| JOIN + aggregate | `SELECT l.*, COUNT(t.id) ... LEFT JOIN ...` | Raw (hardcoded — no user input) |
| DDL | `CREATE TABLE IF NOT EXISTS ...` | Raw (static) |

### ORM SQL Generation Path

```
User input (POST body)
  → URL-decoded form field
    → Temper Map construction via make_params()
      → changeset(tableDef, paramsMap)              [factory — sealed interface]
        → :cast(allowedFields)                      [SafeIdentifier whitelist]
          → :validateRequired(fields)               [non-null enforcement]
            → :toInsertSql()                        [type-dispatched escaping]
              → :toString()                         [rendered SQL string]
                → conn:exec(sql)                    [lsqlite3 execution]
```

For queries:
```
Route parameter (/lists/(%d+))
  → Lua pattern match (%d+ = digits only)
    → tonumber(id)                                  [guaranteed number]
      → SqlBuilder:appendInt32(id)                  [bare integer]
        → from(safeIdentifier("lists")):where(fragment):toSql()
          → conn:nrows(sql)
```

---

## SQL Injection Analysis

### ORM-Generated SQL: Protected

**SafeIdentifier validation** — `safeIdentifier()` validates against `[a-zA-Z_][a-zA-Z0-9_]*`. The Lua-compiled ORM preserves the sealed-interface pattern — `ValidatedIdentifier` is not directly constructable.

**SqlString escaping** — String values pass through `SqlString` which escapes `'` → `''`.

**Route parameter safety** — Lua patterns use `(%d+)` which matches only digit sequences. `tonumber()` converts to a Lua number. Non-numeric paths return 404.

**field_names() helper** — The app correctly extracts `.name` (SafeIdentifier) from FieldDef objects before passing to `cast()` and `validateRequired()`. An earlier bug passed FieldDef objects directly, causing a runtime error (`no such key: sqlValue`). This was fixed by adding the `field_names()` helper.

### Raw SQL: Mixed

```lua
-- Toggle — parameterized via prepare/bind_values
local stmt = conn:prepare("UPDATE todos SET completed = 1 - completed WHERE id = ?")
stmt:bind_values(id)
stmt:step()

-- JOIN aggregate — hardcoded, no user input
local stmt = conn:prepare([[
    SELECT l.id, l.name, l.created_at,
           COUNT(t.id) as total,
           SUM(CASE WHEN t.completed = 1 THEN 1 ELSE 0 END) as done
    FROM lists l LEFT JOIN todos t ON t.list_id = l.id
    GROUP BY l.id ORDER BY l.created_at DESC
]])
```

The toggle uses `conn:prepare` + `bind_values` — fully parameterized. The JOIN query is entirely hardcoded with no user input.

**Note:** ORM-generated SQL is executed via `conn:exec(sql)` — the full rendered string. This is escaping-based rather than parameterized, but the escaping is correct.

### DDL: Static

Schema creation uses hardcoded `CREATE TABLE` statements.

---

## Findings

| # | Severity | CWE | Finding |
|---|----------|-----|---------|
| LU-SQL-1 | LOW | CWE-89 | ORM SQL executed via `conn:exec(sql)` as a pre-rendered string. lsqlite3's `exec()` does not support parameters — it executes the literal SQL. The ORM's escaping handles this correctly, but if lsqlite3's `prepare`/`bind` were used for ORM output too, it would add defense-in-depth. |
| LU-SQL-2 | INFO | CWE-400 | SELECT queries use `toSql()` without limits. `safeToSql(defaultLimit)` available but unused. |
| LU-SQL-3 | INFO | CWE-20 | URL-decoded form values go directly to `make_params()` → `tostring(v)`. The ORM's `SqlString` handles escaping, but no app-level length validation is performed before ORM processing. |

### ORM-Level Concerns (shared across all apps)

| # | Severity | CWE | Finding |
|---|----------|-----|---------|
| ORM-1 | MEDIUM | CWE-89 | `toInsertSql`/`toUpdateSql` pass `pair.key` (a `String`) to `appendSafe`. Safe by construction but not type-enforced. |
| ORM-2 | LOW | CWE-89 | `SqlDate.formatTo` wraps `value.toString()` in quotes without escaping. |
| ORM-3 | LOW | CWE-20 | `SqlFloat64.formatTo` can produce `NaN`/`Infinity`. |

---

## Verdict

**No SQL injection vulnerabilities found.** The ORM covers all user-input-to-SQL paths with type-safe escaping. Raw SQL is either parameterized (toggle) or contains no user input (JOIN aggregate). Lua's `(%d+)` route patterns provide strong integer validation at the routing level.
