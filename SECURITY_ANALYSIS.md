# Security Analysis: Lua Todo App

SQL security analysis of the Lua todo app built on the Generic Temper ORM. Focuses on SQL injection vulnerabilities, ORM-generated SQL safety, and JOIN feature security.

**Original Analysis Date:** 2026-03-12
**Updated:** 2026-03-13 (JOIN feature analysis, SQL-only scope)
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
| JOIN + aggregate | `SELECT l.*, COUNT(t.id) ... LEFT JOIN ...` | Raw (hardcoded -- no user input) |
| DDL | `CREATE TABLE IF NOT EXISTS ...` | Raw (static) |

### ORM SQL Generation Path

```
User input (POST body)
  -> URL-decoded form field
    -> Temper Map construction via make_params()
      -> changeset(tableDef, paramsMap)              [factory -- sealed interface]
        -> :cast(allowedFields)                      [SafeIdentifier whitelist]
          -> :validateRequired(fields)               [non-null enforcement]
            -> :toInsertSql()                        [type-dispatched escaping]
              -> :toString()                         [rendered SQL string]
                -> conn:exec(sql)                    [lsqlite3 execution]
```

For queries:
```
Route parameter (/lists/(%d+))
  -> Lua pattern match (%d+ = digits only)
    -> tonumber(id)                                  [guaranteed number]
      -> SqlBuilder:appendInt32(id)                  [bare integer]
        -> from(safeIdentifier("lists")):where(fragment):toSql()
          -> conn:nrows(sql)
```

---

## SQL Injection Analysis

### ORM-Generated SQL: Protected

**SafeIdentifier validation** -- `safeIdentifier()` validates against `[a-zA-Z_][a-zA-Z0-9_]*`. The Lua-compiled ORM preserves the sealed-interface pattern -- `ValidatedIdentifier` is not directly constructable.

**SqlString escaping** -- String values pass through `SqlString` which escapes `'` -> `''`.

**Route parameter safety** -- Lua patterns use `(%d+)` which matches only digit sequences. `tonumber()` converts to a Lua number. Non-numeric paths return 404.

**field_names() helper** -- The app correctly extracts `.name` (SafeIdentifier) from FieldDef objects before passing to `cast()` and `validateRequired()`. An earlier bug passed FieldDef objects directly, causing a runtime error (`no such key: sqlValue`). This was fixed by adding the `field_names()` helper.

### Raw SQL: Mixed

```lua
-- Toggle -- parameterized via prepare/bind_values
local stmt = conn:prepare("UPDATE todos SET completed = 1 - completed WHERE id = ?")
stmt:bind_values(id)
stmt:step()

-- JOIN aggregate -- hardcoded, no user input
local stmt = conn:prepare([[
    SELECT l.id, l.name, l.created_at,
           COUNT(t.id) as total,
           SUM(CASE WHEN t.completed = 1 THEN 1 ELSE 0 END) as done
    FROM lists l LEFT JOIN todos t ON t.list_id = l.id
    GROUP BY l.id ORDER BY l.created_at DESC
]])
```

The toggle uses `conn:prepare` + `bind_values` -- fully parameterized. The JOIN query is entirely hardcoded with no user input.

**Note:** ORM-generated SQL is executed via `conn:exec(sql)` -- the full rendered string. This is escaping-based rather than parameterized, but the escaping is correct.

### DDL: Static

Schema creation uses hardcoded `CREATE TABLE` statements.

---

## SQL Findings

| # | Severity | CWE | Finding |
|---|----------|-----|---------|
| LU-SQL-1 | LOW | CWE-89 | ORM SQL executed via `conn:exec(sql)` as a pre-rendered string. lsqlite3's `exec()` does not support parameters -- it executes the literal SQL. The ORM's escaping handles this correctly, but if lsqlite3's `prepare`/`bind` were used for ORM output too, it would add defense-in-depth. |
| LU-SQL-2 | INFO | CWE-400 | SELECT queries use `toSql()` without limits. `safeToSql(defaultLimit)` available but unused. |
| LU-SQL-3 | INFO | CWE-20 | URL-decoded form values go directly to `make_params()` -> `tostring(v)`. The ORM's `SqlString` handles escaping, but no app-level length validation is performed before ORM processing. |

### ORM-Level Concerns (shared across all apps)

| # | Severity | CWE | Finding |
|---|----------|-----|---------|
| ORM-1 | MEDIUM | CWE-89 | `toInsertSql`/`toUpdateSql` pass `pair.key` (a `String`) to `appendSafe`. Safe by construction but not type-enforced. |
| ORM-2 | LOW | CWE-89 | `SqlDate.formatTo` wraps `value.toString()` in quotes without escaping. |
| ORM-3 | LOW | CWE-20 | `SqlFloat64.formatTo` can produce `NaN`/`Infinity`. |

---

## JOIN Feature Security Analysis

**ORM Version:** Latest with JOIN support (INNER, LEFT, RIGHT, FULL OUTER JOIN)
**Temper Source:** `src/query.temper.md`

### Architecture

The ORM's JOIN implementation follows the same security model as the rest of the query builder:

```
JoinType     -- sealed interface with 4 implementations (InnerJoin, LeftJoin, RightJoin, FullJoin)
JoinClause   -- (joinType: JoinType, table: SafeIdentifier, onCondition: SqlFragment)
Query        -- extended with joinClauses: List<JoinClause>
```

### Security Properties

**1. Table Names: SafeIdentifier-enforced**

The `table` parameter in all join methods (`innerJoin`, `leftJoin`, `rightJoin`, `fullJoin`) is typed as `SafeIdentifier`. This is the same validation used for the primary table in `from()`:

```
safeIdentifier(name) validates: [a-zA-Z_][a-zA-Z0-9_]*
```

A user cannot supply an arbitrary string as a JOIN table name. The Temper type system enforces this at compile time, and `safeIdentifier()` validates at runtime. Attempting `safeIdentifier("users; DROP TABLE users; --")` will bubble (fail) because `;`, space, and `-` are not in `[a-zA-Z0-9_]`.

**2. ON Conditions: SqlFragment-typed**

The `onCondition` parameter is typed as `SqlFragment`, not `String`. SqlFragments are constructed either:

- Via the `sql` tagged template (compile-time safe interpolation), or
- Via `SqlBuilder` with explicit `appendSafe`/`appendInt32`/`appendString` calls, or
- Via the `col()` helper which produces qualified `table.column` references from two SafeIdentifiers

There is no code path where a raw user string can become an `onCondition` without going through type-safe escaping.

**3. JOIN Type Keywords: Sealed Interface**

The `JoinType` is a sealed interface with exactly 4 implementations. Each returns a hardcoded keyword string:

| Type | Keyword |
|------|---------|
| `InnerJoin` | `"INNER JOIN"` |
| `LeftJoin` | `"LEFT JOIN"` |
| `RightJoin` | `"RIGHT JOIN"` |
| `FullJoin` | `"FULL OUTER JOIN"` |

These are appended via `appendSafe()` -- they are static strings, not user-influenced.

**4. SQL Generation Order**

JOINs are rendered after `FROM` and before `WHERE` in the `toSql()` method:

```sql
SELECT [fields] FROM [table] [JOIN clauses] [WHERE conditions] [ORDER BY] [LIMIT] [OFFSET]
```

This matches standard SQL syntax. The implementation uses `appendFragment` for the ON condition, which preserves the structured `SqlPart` list rather than flattening to a string prematurely.

### How the Lua App Uses JOINs

Currently, the Lua app does **not** use the ORM's new JOIN API. The `lists_get_all()` function uses a raw hardcoded SQL query with a LEFT JOIN + GROUP BY + aggregate functions:

```lua
-- db.lua:233-241 (raw SQL, no user input)
local stmt = conn:prepare([[
    SELECT l.id, l.name, l.created_at,
           COUNT(t.id) as total,
           SUM(CASE WHEN t.completed = 1 THEN 1 ELSE 0 END) as done
    FROM lists l
    LEFT JOIN todos t ON t.list_id = l.id
    GROUP BY l.id
    ORDER BY l.created_at DESC
]])
```

This is secure because:
- The query is entirely static (no string interpolation)
- No user input reaches any part of the query
- It uses `conn:prepare()` (though with no bound parameters, since there are none)

The ORM's JOIN feature could replace part of this query (the JOIN clause itself), but the GROUP BY and aggregate functions (`COUNT`, `SUM/CASE`) are beyond the ORM's current scope.

### JOIN Feature Risk Assessment

| Aspect | Risk Level | Analysis |
|--------|------------|----------|
| SQL injection via table name | NONE | `SafeIdentifier` enforced by type system |
| SQL injection via ON condition | NONE | `SqlFragment` enforced by type system |
| SQL injection via JOIN keyword | NONE | Sealed interface, hardcoded strings |
| Cartesian product (missing ON) | NONE | `onCondition` is a required parameter |
| Resource exhaustion from JOINs | LOW | JOINs can produce large result sets, but `safeToSql(limit)` can bound this. Same risk as existing unbounded SELECTs (LU-SQL-2). |

### JOIN Feature Findings

| # | Severity | CWE | Finding |
|---|----------|-----|---------|
| LU-JOIN-1 | INFO | -- | The Lua app has a raw SQL LEFT JOIN in `lists_get_all()` that could partially migrate to the ORM's JOIN API. The raw query is safe (hardcoded), but using the ORM would improve consistency and make the security properties explicit in the type system. |
| LU-JOIN-2 | INFO | CWE-400 | JOIN queries can amplify result set sizes (e.g., many-to-many relationships). The `safeToSql(defaultLimit)` method should be used when JOINs are applied to user-facing queries to bound output. |

---

## SQL-Relevant CWE Mapping

Mapping of SQL-related CWEs from the MITRE Top 25 against this application.

| CWE | Name | Status | Details |
|-----|------|--------|---------|
| CWE-89 | SQL Injection | **MITIGATED** | All user-input-to-SQL paths go through the ORM's type-safe escaping (`SafeIdentifier` for identifiers, `SqlString` for values, `SqlInt32` for integers). Raw SQL is either parameterized (`prepare`/`bind_values` for toggle) or contains no user input (JOIN aggregate, DDL). Route IDs validated by Lua `(%d+)` pattern. See findings LU-SQL-1 through LU-SQL-3, and ORM-1 through ORM-3. |
| CWE-20 | Improper Input Validation | **PARTIALLY MITIGATED** | Route parameters are validated by Lua patterns (`%d+`). The ORM validates field types during `cast()`. However, no app-level length validation on form inputs (list names, todo titles). See finding LU-SQL-3. |
| CWE-400 | Uncontrolled Resource Consumption | **PARTIALLY MITIGATED** | SELECT queries use `toSql()` without limits. `safeToSql(defaultLimit)` available but unused. JOIN queries can amplify result set sizes. See findings LU-SQL-2, LU-JOIN-2. |
| CWE-915 | Improperly Controlled Modification of Dynamically-Determined Object Attributes | **MITIGATED** | The ORM's `cast()` method uses a SafeIdentifier whitelist to explicitly allow only specified fields in INSERT/UPDATE operations. Users cannot modify arbitrary columns via mass assignment. |

---

## Verdict

**SQL injection: No vulnerabilities found.** The ORM covers all user-input-to-SQL paths with type-safe escaping. Raw SQL is either parameterized (toggle) or contains no user input (JOIN aggregate). Lua's `(%d+)` route patterns provide strong integer validation at the routing level. The new JOIN feature maintains the same security properties as the rest of the ORM.

**Remaining SQL concerns:** All identified issues are informational or low severity. The primary observation is that ORM-generated SQL is executed via string rendering + escaping rather than parameterized queries, which is a design limitation of the current architecture but implemented correctly. Result set size limits should be applied to user-facing queries to prevent resource exhaustion.

---

## Evolution: Temper-Level Remediation

**Date:** 2026-03-12
**Commit:** [`1df8c7a`](https://github.com/notactuallytreyanastasio/generic_orm/commit/1df8c7a)

The security analysis above identified 3 ORM-level concerns (ORM-1, ORM-2, ORM-3) shared across all 6 app implementations. Because the ORM is written once in Temper and compiled to all backends, fixing these issues at the Temper source level automatically resolves them in every language -- including this Lua app.

### What Changed

**ORM-1 (MEDIUM -> RESOLVED): Column name type safety in INSERT/UPDATE SQL**

The `toInsertSql()` and `toUpdateSql()` methods previously passed `pair.key` (a raw `string`) to `appendSafe()`. While safe by construction (keys originated from `cast()` via `safeIdentifier.sqlValue`), the type system didn't enforce this. A future refactor could have silently introduced an unvalidated code path.

The fix routes column names through the looked-up `fieldDef.name.sqlValue` -- a `SafeIdentifier` -- so the column name in the generated SQL always comes from a validated identifier, not a raw map key.

**ORM-2 (LOW -> RESOLVED): SqlDate quote escaping**

`SqlDate:formatTo()` previously wrapped `value:toString()` in quotes without escaping. The fix adds character-by-character quote escaping identical to `SqlString:formatTo()`, ensuring defense-in-depth against any future Date format that might contain single quotes.

**ORM-3 (LOW -> RESOLVED): SqlFloat64 NaN/Infinity handling**

`SqlFloat64:formatTo()` previously called `value:toString()` directly, which could produce `nan`, `inf`, or `-inf` -- none valid SQL literals. The fix checks for these values and renders `NULL` instead, which is the safest SQL representation for non-representable floating-point values.

### Why This Matters

This is the core value proposition of a cross-compiled ORM: **one fix in Temper source propagates to all 6 backends simultaneously.** The same commit that fixed the Lua compiled output also fixed JavaScript, Python, Rust, Java, and C#. No per-language patches needed. No risk of inconsistent fixes across implementations.

### Updated Status

| Finding | Original | Current | Resolution |
|---------|----------|---------|------------|
| ORM-1 | MEDIUM | RESOLVED | Column names routed through `SafeIdentifier` |
| ORM-2 | LOW | RESOLVED | `SqlDate:formatTo()` now escapes quotes |
| ORM-3 | LOW | RESOLVED | `SqlFloat64:formatTo()` renders NaN/Infinity as `NULL` |
| ORM-4 | INFO | ACKNOWLEDGED | Design limitation -- escaping-based, not parameterized |

---

## SQL Findings Summary

**Total: 9 findings** (1 MEDIUM resolved, 1 LOW, 2 LOW resolved, 5 INFO)

| # | Severity | CWE | Category | Status |
|---|----------|-----|----------|--------|
| ORM-1 | MEDIUM | CWE-89 | SQL Injection | Resolved |
| LU-SQL-1 | LOW | CWE-89 | SQL Injection | Open (accepted risk) |
| ORM-2 | LOW | CWE-89 | SQL Injection | Resolved |
| ORM-3 | LOW | CWE-20 | Input Validation | Resolved |
| LU-SQL-2 | INFO | CWE-400 | Unbounded Queries | Open |
| LU-SQL-3 | INFO | CWE-20 | Input Validation | Open |
| LU-JOIN-1 | INFO | -- | ORM Adoption | Open |
| LU-JOIN-2 | INFO | CWE-400 | JOIN Resource Use | Open |
| ORM-4 | INFO | -- | Design Limitation | Acknowledged |
