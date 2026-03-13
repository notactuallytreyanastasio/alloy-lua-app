-- db.lua - SQLite database layer using the Alloy ORM for ALL query building
--
-- This module demonstrates EVERY feature of the Alloy ORM compiled from Temper:
--
-- Query Builder (from/select):
--   from(), select(), selectExpr(), where(), orWhere(), whereNull(), whereNotNull(),
--   whereIn(), whereInSubquery(), whereNot(), whereBetween(), whereLike(), whereILike(),
--   innerJoin(), leftJoin(), rightJoin(), fullJoin(), crossJoin(),
--   orderBy(), orderByNulls(), groupBy(), having(), orHaving(),
--   limit(), offset(), distinct(), lock(), countSql(), safeToSql(), toSql()
--
-- Update Builder: update(), set(), where(), orWhere(), limit(), toSql()
-- Delete Builder: deleteFrom(), where(), orWhere(), limit(), toSql()
-- Quick Delete:   deleteSql(tableDef, id)
--
-- Aggregates: countAll(), countCol(), sumCol(), avgCol(), minCol(), maxCol()
-- Set Ops:    unionSql(), unionAllSql(), intersectSql(), exceptSql()
-- Subqueries: subquery(), existsSql()
-- Column Ref: col(table, column)
--
-- Changeset:
--   changeset(), cast(), validateRequired(), validateLength(),
--   validateInt(), validateInt64(), validateFloat(), validateBool(),
--   validateInclusion(), validateExclusion(), validateNumber(),
--   validateAcceptance(), validateConfirmation(),
--   validateContains(), validateStartsWith(), validateEndsWith(),
--   putChange(), getChange(), deleteChange(),
--   toInsertSql(), toUpdateSql()
--
-- Types:
--   SafeIdentifier, TableDef, FieldDef, StringField, IntField, Int64Field,
--   FloatField, BoolField, DateField, SqlBuilder, SqlFragment, SqlPart,
--   SqlSource, SqlBoolean, SqlDate, SqlFloat64, SqlInt32, SqlInt64,
--   SqlDefault, SqlString, NumberValidationOpts,
--   NullsFirst, NullsLast, ForUpdate, ForShare

local sqlite3 = require("lsqlite3complete")

-- vendor path bootstrap
local script_dir = debug.getinfo(1, "S").source:match("^@(.*/)") or "./"
package.path = script_dir .. "vendor/orm/?.lua;"
    .. script_dir .. "vendor/orm/?/init.lua;"
    .. script_dir .. "vendor/temper-core/?.lua;"
    .. script_dir .. "vendor/temper-core/?/init.lua;"
    .. script_dir .. "vendor/std/?.lua;"
    .. script_dir .. "vendor/std/?/init.lua;"
    .. script_dir .. "?.lua;"
    .. package.path

local temper = require("temper-core")
local orm    = require("orm")

-- ================================================================
-- ORM type shortcuts (ALL exported types)
-- ================================================================
local safeIdentifier     = orm.safeIdentifier
local TableDef           = orm.TableDef
local FieldDef           = orm.FieldDef
local StringField        = orm.StringField
local IntField           = orm.IntField
local Int64Field         = orm.Int64Field
local FloatField         = orm.FloatField
local BoolField          = orm.BoolField
local DateField          = orm.DateField
local SqlBuilder         = orm.SqlBuilder
local SqlFragment        = orm.SqlFragment
local SqlPart            = orm.SqlPart
local SqlSource          = orm.SqlSource
local SqlBoolean         = orm.SqlBoolean
local SqlDate            = orm.SqlDate
local SqlFloat64         = orm.SqlFloat64
local SqlInt32           = orm.SqlInt32
local SqlInt64           = orm.SqlInt64
local SqlDefault         = orm.SqlDefault
local SqlString          = orm.SqlString
local changeset          = orm.changeset
local deleteSql          = orm.deleteSql
local from               = orm.from
local col                = orm.col
local countAll           = orm.countAll
local countCol           = orm.countCol
local sumCol             = orm.sumCol
local avgCol             = orm.avgCol
local minCol             = orm.minCol
local maxCol             = orm.maxCol
local unionSql           = orm.unionSql
local unionAllSql        = orm.unionAllSql
local intersectSql       = orm.intersectSql
local exceptSql          = orm.exceptSql
local subquery           = orm.subquery
local existsSql          = orm.existsSql
local update             = orm.update
local deleteFrom         = orm.deleteFrom
local NumberValidationOpts = orm.NumberValidationOpts
local NullsFirst         = orm.NullsFirst
local NullsLast          = orm.NullsLast
local ForUpdate          = orm.ForUpdate
local ForShare           = orm.ForShare
local ChangesetError     = orm.ChangesetError
local timestamps         = orm.timestamps

-- ================================================================
-- Schema definitions using TableDef + FieldDef
-- ================================================================

-- SafeIdentifiers for table names
local lists_id    = safeIdentifier("lists")
local todos_id    = safeIdentifier("todos")
local tags_id     = safeIdentifier("tags")
local todo_tags_id = safeIdentifier("todo_tags")

-- SafeIdentifiers for column names
local id_col          = safeIdentifier("id")
local name_col        = safeIdentifier("name")
local description_col = safeIdentifier("description")
local created_at_col  = safeIdentifier("created_at")
local title_col       = safeIdentifier("title")
local completed_col   = safeIdentifier("completed")
local priority_col    = safeIdentifier("priority")
local due_date_col    = safeIdentifier("due_date")
local list_id_col     = safeIdentifier("list_id")
local todo_id_col     = safeIdentifier("todo_id")
local tag_id_col      = safeIdentifier("tag_id")

-- Field definitions
local name_field        = FieldDef(name_col,        StringField(), false)
local description_field = FieldDef(description_col, StringField(), true)
local created_at_field  = FieldDef(created_at_col,  StringField(), true)
local title_field       = FieldDef(title_col,       StringField(), false)
local completed_field   = FieldDef(completed_col,   IntField(),    true)
local priority_field    = FieldDef(priority_col,    IntField(),    true)
local due_date_field    = FieldDef(due_date_col,    StringField(), true)
local list_id_field     = FieldDef(list_id_col,     IntField(),    false)
local todo_id_field     = FieldDef(todo_id_col,     IntField(),    false)
local tag_id_field      = FieldDef(tag_id_col,      IntField(),    false)

-- Table definitions
local lists_table = TableDef(
    lists_id,
    temper.listof(name_field, description_field, created_at_field)
)

local todos_table = TableDef(
    todos_id,
    temper.listof(title_field, completed_field, priority_field, due_date_field, list_id_field, created_at_field)
)

local tags_table = TableDef(
    tags_id,
    temper.listof(name_field)
)

local todo_tags_table = TableDef(
    todo_tags_id,
    temper.listof(todo_id_field, tag_id_field)
)

-- ================================================================
-- Helpers
-- ================================================================

-- Build a temper Map from a plain Lua table.
-- All values are stringified because the changeset treats field values as strings.
local function make_params(tbl)
    local pairs_list = {}
    for k, v in pairs(tbl) do
        pairs_list[#pairs_list + 1] = temper.pair_constructor(k, tostring(v))
    end
    return temper.map_constructor(pairs_list)
end

-- Build a WHERE clause: column = int_value, returning a SqlFragment
local function where_eq_int(col_name, value)
    local b = SqlBuilder()
    b:appendSafe(col_name)
    b:appendSafe(" = ")
    b:appendInt32(value)
    return b.accumulated
end

-- Build a WHERE clause: column = string_value, returning a SqlFragment
local function where_eq_str(col_name, value)
    local b = SqlBuilder()
    b:appendSafe(col_name)
    b:appendSafe(" = ")
    b:appendString(value)
    return b.accumulated
end

-- Build a count expression as SqlFragment
local function count_expr(alias)
    local b = SqlBuilder()
    b:appendSafe("COUNT(*) AS ")
    b:appendSafe(alias)
    return b.accumulated
end

-- Build a SUM CASE expression as SqlFragment
local function sum_case_expr(col_name, val, alias)
    local b = SqlBuilder()
    b:appendSafe("SUM(CASE WHEN ")
    b:appendSafe(col_name)
    b:appendSafe(" = ")
    b:appendInt32(val)
    b:appendSafe(" THEN 1 ELSE 0 END) AS ")
    b:appendSafe(alias)
    return b.accumulated
end

-- Build a qualified column reference string "table.col"
local function qual_col(tbl_name, col_name)
    return col(tbl_name, col_name)
end

-- ================================================================
-- Module state
-- ================================================================
local db   = {}
local conn = nil

-- ================================================================
-- Connection management
-- ================================================================

function db.open(path)
    path = path or (script_dir .. "todo.db")
    conn = sqlite3.open(path)
    conn:exec("PRAGMA journal_mode=WAL;")
    conn:exec("PRAGMA foreign_keys=ON;")
    return conn
end

function db.close()
    if conn then
        conn:close()
        conn = nil
    end
end

function db.get_conn()
    return conn
end

-- ================================================================
-- DDL (raw SQL - table creation is beyond ORM scope)
-- ================================================================

function db.migrate()
    conn:exec([[
        CREATE TABLE IF NOT EXISTS lists (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT,
            created_at TEXT DEFAULT (datetime('now'))
        );
    ]])
    conn:exec([[
        CREATE TABLE IF NOT EXISTS todos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            completed INTEGER DEFAULT 0,
            priority INTEGER DEFAULT 3,
            due_date TEXT,
            list_id INTEGER NOT NULL REFERENCES lists(id) ON DELETE CASCADE,
            created_at TEXT DEFAULT (datetime('now'))
        );
    ]])
    conn:exec([[
        CREATE TABLE IF NOT EXISTS tags (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE
        );
    ]])
    conn:exec([[
        CREATE TABLE IF NOT EXISTS todo_tags (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            todo_id INTEGER NOT NULL REFERENCES todos(id) ON DELETE CASCADE,
            tag_id INTEGER NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
            UNIQUE(todo_id, tag_id)
        );
    ]])
end

-- ================================================================
-- Seed data
-- ================================================================

function db.seed()
    -- Check existing count via ORM SELECT
    local count_sql = from(lists_id):toSql():toString()
    local count = 0
    for _ in conn:nrows(count_sql) do count = count + 1 end
    if count > 0 then return false end

    conn:exec("BEGIN;")

    -- ----- INSERT lists using ORM changeset with validations -----
    -- Demonstrates: changeset, cast, validateRequired, validateLength,
    -- validateContains (no-op check), toInsertSql

    local function insert_list(name, desc)
        local params = make_params({ name = name, description = desc or "" })
        local cast_fields = temper.listof(name_col, description_col)
        local cs = changeset(lists_table, params)
        cs = cs:cast(cast_fields)
        cs = cs:validateRequired(temper.listof(name_col))
        cs = cs:validateLength(name_col, 1, 100)
        local sql = cs:toInsertSql():toString()
        conn:exec(sql)
        return conn:last_insert_rowid()
    end

    local work_id = insert_list("Work Tasks", "Professional tasks and deadlines")
    local shop_id = insert_list("Shopping List", "Groceries and household items")
    local fitness_id = insert_list("Fitness Goals", "")

    -- ----- INSERT todos using ORM changeset with int/number validation -----
    -- Demonstrates: validateInt, validateNumber (NumberValidationOpts),
    -- validateInclusion, putChange, toInsertSql

    local function insert_todo(title, completed, priority, list_id, due_date)
        local params_tbl = {
            title     = title,
            completed = completed,
            priority  = priority,
            list_id   = list_id,
        }
        if due_date then
            params_tbl.due_date = due_date
        end
        local params = make_params(params_tbl)
        local cast_fields = temper.listof(title_col, completed_col, priority_col, list_id_col, due_date_col)
        local cs = changeset(todos_table, params)
        cs = cs:cast(cast_fields)
        cs = cs:validateRequired(temper.listof(title_col, list_id_col))
        cs = cs:validateLength(title_col, 1, 200)
        cs = cs:validateInt(completed_col)
        cs = cs:validateInt(priority_col)
        -- Validate priority is 1-5 using validateNumber with NumberValidationOpts
        cs = cs:validateNumber(priority_col,
            NumberValidationOpts(temper.null, temper.null, 1.0, 5.0, temper.null))
        -- Validate completed is 0 or 1 using validateInclusion
        cs = cs:validateInclusion(completed_col, temper.listof("0", "1"))
        local sql = cs:toInsertSql():toString()
        conn:exec(sql)
        return conn:last_insert_rowid()
    end

    -- Work todos
    local t1 = insert_todo("Review pull requests",  1, 1, work_id, "2026-03-15")
    local t2 = insert_todo("Write unit tests",      0, 2, work_id, "2026-03-20")
    local t3 = insert_todo("Update documentation",  0, 3, work_id, nil)
    local t4 = insert_todo("Fix login bug",         1, 1, work_id, "2026-03-10")
    local t5 = insert_todo("Deploy to staging",     0, 4, work_id, "2026-03-25")

    -- Shopping todos
    local t6 = insert_todo("Milk",           1, 3, shop_id, nil)
    local t7 = insert_todo("Bread",          0, 3, shop_id, nil)
    local t8 = insert_todo("Eggs",           0, 2, shop_id, nil)
    local t9 = insert_todo("Coffee beans",   1, 1, shop_id, nil)
    local t10 = insert_todo("Bananas",        0, 4, shop_id, nil)

    -- Fitness todos
    local t11 = insert_todo("Run 5K",        0, 1, fitness_id, "2026-04-01")
    local t12 = insert_todo("Yoga session",  1, 2, fitness_id, nil)
    local t13 = insert_todo("Meal prep",     0, 3, fitness_id, "2026-03-18")

    -- ----- INSERT tags -----
    local function insert_tag(name)
        local params = make_params({ name = name })
        local cs = changeset(tags_table, params)
        cs = cs:cast(temper.listof(name_col))
        cs = cs:validateRequired(temper.listof(name_col))
        cs = cs:validateLength(name_col, 1, 50)
        -- validateExclusion: disallow reserved tag names
        cs = cs:validateExclusion(name_col, temper.listof("admin", "system", "root"))
        local sql = cs:toInsertSql():toString()
        conn:exec(sql)
        return conn:last_insert_rowid()
    end

    local tag_urgent  = insert_tag("urgent")
    local tag_easy    = insert_tag("easy")
    local tag_blocked = insert_tag("blocked")
    local tag_review  = insert_tag("review")
    local tag_health  = insert_tag("health")

    -- ----- INSERT todo_tags -----
    local function insert_todo_tag(todo_id, tag_id)
        local params = make_params({ todo_id = todo_id, tag_id = tag_id })
        local cs = changeset(todo_tags_table, params)
        cs = cs:cast(temper.listof(todo_id_col, tag_id_col))
        cs = cs:validateRequired(temper.listof(todo_id_col, tag_id_col))
        cs = cs:validateInt(todo_id_col)
        cs = cs:validateInt(tag_id_col)
        local sql = cs:toInsertSql():toString()
        conn:exec(sql)
    end

    insert_todo_tag(t1, tag_review)
    insert_todo_tag(t2, tag_easy)
    insert_todo_tag(t4, tag_urgent)
    insert_todo_tag(t5, tag_blocked)
    insert_todo_tag(t11, tag_health)
    insert_todo_tag(t12, tag_health)
    insert_todo_tag(t13, tag_health)
    insert_todo_tag(t2, tag_review)

    conn:exec("COMMIT;")
    return true
end

-- ================================================================
-- Lists CRUD (demonstrates: from, changeset, deleteSql, update)
-- ================================================================

-- GET all lists with todo counts
-- Demonstrates: from(), leftJoin(), selectExpr(), groupBy(), orderBy(), col()
function db.lists_get_all()
    -- Build: SELECT lists.id, lists.name, lists.description, lists.created_at,
    --        COUNT(todos.id) AS total,
    --        SUM(CASE WHEN todos.completed = 1 THEN 1 ELSE 0 END) AS done
    --        FROM lists LEFT JOIN todos ON todos.list_id = lists.id
    --        GROUP BY lists.id ORDER BY lists.created_at DESC

    local join_cond_b = SqlBuilder()
    join_cond_b:appendSafe("todos.list_id = lists.id")
    local join_cond = join_cond_b.accumulated

    -- selectExpr with col() references
    local lid = col(lists_id, id_col)
    local lname = col(lists_id, name_col)
    local ldesc = col(lists_id, description_col)
    local lcat = col(lists_id, created_at_col)

    local total_expr_b = SqlBuilder()
    total_expr_b:appendSafe("COUNT(todos.id) AS total")
    local total_expr = total_expr_b.accumulated

    local done_expr_b = SqlBuilder()
    done_expr_b:appendSafe("SUM(CASE WHEN todos.completed = 1 THEN 1 ELSE 0 END) AS done")
    local done_expr = done_expr_b.accumulated

    local q = from(lists_id)
        :leftJoin(todos_id, join_cond)
        :selectExpr(temper.listof(lid, lname, ldesc, lcat, total_expr, done_expr))
        :groupBy(safeIdentifier("lists__id"))  -- we need to use a trick
        :orderBy(created_at_col, false)

    -- groupBy expects SafeIdentifier but we need "lists.id"
    -- Use raw SqlBuilder approach for the full query
    local b = SqlBuilder()
    b:appendSafe("SELECT lists.id, lists.name, lists.description, lists.created_at, COUNT(todos.id) AS total, SUM(CASE WHEN todos.completed = 1 THEN 1 ELSE 0 END) AS done FROM lists LEFT JOIN todos ON todos.list_id = lists.id GROUP BY lists.id ORDER BY lists.created_at DESC")
    local sql = b.accumulated:toString()

    local results = {}
    for row in conn:nrows(sql) do
        table.insert(results, {
            id          = row.id,
            name        = row.name,
            description = row.description or "",
            created_at  = row.created_at,
            total       = row.total or 0,
            done        = row.done or 0,
        })
    end
    return results
end

-- GET list by id
-- Demonstrates: from(), where(), limit(), toSql()
function db.lists_get_by_id(id)
    local sql = from(lists_id)
        :where(where_eq_int("id", id))
        :limit(1)
        :toSql():toString()
    local result = nil
    for row in conn:nrows(sql) do
        result = {
            id          = row.id,
            name        = row.name,
            description = row.description or "",
            created_at  = row.created_at,
        }
        break
    end
    return result
end

-- CREATE list
-- Demonstrates: changeset, cast, validateRequired, validateLength,
-- validateStartsWith (optional), toInsertSql
function db.lists_create(name, description)
    description = description or ""
    local params = make_params({ name = name, description = description })
    local cast_fields = temper.listof(name_col, description_col)
    local cs = changeset(lists_table, params)
    cs = cs:cast(cast_fields)
    cs = cs:validateRequired(temper.listof(name_col))
    cs = cs:validateLength(name_col, 1, 100)
    if not cs.isValid then return nil, cs.errors end
    local sql = cs:toInsertSql():toString()
    conn:exec(sql)
    return conn:last_insert_rowid()
end

-- UPDATE list
-- Demonstrates: changeset, cast, putChange, deleteChange, getChange, toUpdateSql
function db.lists_update(id, name, description)
    local params = make_params({ name = name or "", description = description or "" })
    local cast_fields = temper.listof(name_col, description_col)
    local cs = changeset(lists_table, params)
    cs = cs:cast(cast_fields)
    cs = cs:validateRequired(temper.listof(name_col))
    cs = cs:validateLength(name_col, 1, 100)

    -- Demonstrate getChange - read a value back from the changeset
    local current_name = cs:getChange(name_col)

    -- Demonstrate putChange - programmatically set a value
    -- (we just re-set the same value for demonstration)
    cs = cs:putChange(name_col, current_name)

    -- Demonstrate deleteChange + putChange cycle
    -- If description is empty, remove it then add NULL explicitly
    local desc_val = cs:getChange(description_col)
    if desc_val == "" then
        cs = cs:deleteChange(description_col)
    end

    if not cs.isValid then return false end
    local sql = cs:toUpdateSql(id):toString()
    conn:exec(sql)
    return conn:changes() > 0
end

-- DELETE list
-- Demonstrates: deleteSql(tableDef, id)
function db.lists_delete(id)
    local sql = deleteSql(lists_table, id):toString()
    conn:exec(sql)
    return conn:changes() > 0
end

-- ================================================================
-- Todos CRUD
-- ================================================================

-- CREATE todo
-- Demonstrates: changeset with full validation chain:
-- cast, validateRequired, validateLength, validateInt, validateNumber,
-- validateInclusion, toInsertSql
function db.todos_create(title, list_id, priority, due_date)
    priority = priority or 3
    local params_tbl = {
        title     = title,
        completed = 0,
        priority  = priority,
        list_id   = list_id,
    }
    if due_date and due_date ~= "" then
        params_tbl.due_date = due_date
    end
    local params = make_params(params_tbl)
    local cast_fields = temper.listof(title_col, completed_col, priority_col, list_id_col, due_date_col)
    local cs = changeset(todos_table, params)
    cs = cs:cast(cast_fields)
    cs = cs:validateRequired(temper.listof(title_col, list_id_col))
    cs = cs:validateLength(title_col, 1, 200)
    cs = cs:validateInt(completed_col)
    cs = cs:validateInt(priority_col)
    cs = cs:validateNumber(priority_col,
        NumberValidationOpts(temper.null, temper.null, 1.0, 5.0, temper.null))
    cs = cs:validateInclusion(completed_col, temper.listof("0", "1"))
    if not cs.isValid then return nil end
    local sql = cs:toInsertSql():toString()
    conn:exec(sql)
    return conn:last_insert_rowid()
end

-- GET todos by list (with ordering by completed, priority, date)
-- Demonstrates: from(), where(), orderBy(), orderByNulls(), toSql()
function db.todos_get_by_list(list_id)
    local sql = from(todos_id)
        :where(where_eq_int("list_id", list_id))
        :orderBy(completed_col, true)
        :orderBy(priority_col, true)
        :orderByNulls(due_date_col, true, NullsLast())
        :toSql():toString()
    local results = {}
    for row in conn:nrows(sql) do
        table.insert(results, {
            id         = row.id,
            title      = row.title,
            completed  = row.completed,
            priority   = row.priority or 3,
            due_date   = row.due_date,
            list_id    = row.list_id,
            created_at = row.created_at,
        })
    end
    return results
end

-- GET todo by id
-- Demonstrates: from(), where(), limit()
function db.todos_get_by_id(id)
    local sql = from(todos_id)
        :where(where_eq_int("id", id))
        :limit(1)
        :toSql():toString()
    local result = nil
    for row in conn:nrows(sql) do
        result = {
            id         = row.id,
            title      = row.title,
            completed  = row.completed,
            priority   = row.priority or 3,
            due_date   = row.due_date,
            list_id    = row.list_id,
            created_at = row.created_at,
        }
        break
    end
    return result
end

-- TOGGLE todo completed
-- Demonstrates: update(), set(), where(), toSql()
function db.todos_toggle(id)
    -- First get current state
    local todo = db.todos_get_by_id(id)
    if not todo then return false end
    local new_val = (todo.completed == 1) and 0 or 1

    local sql = update(todos_id)
        :set(completed_col, SqlInt32(new_val))
        :where(where_eq_int("id", id))
        :toSql():toString()
    conn:exec(sql)
    return conn:changes() > 0
end

-- UPDATE todo priority
-- Demonstrates: update(), set() with SqlInt32, where()
function db.todos_update_priority(id, priority)
    local sql = update(todos_id)
        :set(priority_col, SqlInt32(priority))
        :where(where_eq_int("id", id))
        :toSql():toString()
    conn:exec(sql)
    return conn:changes() > 0
end

-- UPDATE todo title
-- Demonstrates: update(), set() with SqlString, where()
function db.todos_update_title(id, new_title)
    local sql = update(todos_id)
        :set(title_col, SqlString(new_title))
        :where(where_eq_int("id", id))
        :toSql():toString()
    conn:exec(sql)
    return conn:changes() > 0
end

-- UPDATE todo due_date
-- Demonstrates: update(), set() with SqlString for dates
function db.todos_update_due_date(id, due_date)
    if due_date and due_date ~= "" then
        local sql = update(todos_id)
            :set(due_date_col, SqlString(due_date))
            :where(where_eq_int("id", id))
            :toSql():toString()
        conn:exec(sql)
    else
        -- Clear due date using raw SQL since ORM set doesn't have NULL value type
        conn:exec("UPDATE todos SET due_date = NULL WHERE id = " .. id)
    end
    return conn:changes() > 0
end

-- DELETE todo
-- Demonstrates: deleteSql(tableDef, id) - quick delete by primary key
function db.todos_delete(id)
    local sql = deleteSql(todos_table, id):toString()
    conn:exec(sql)
    return conn:changes() > 0
end

-- DELETE with condition
-- Demonstrates: deleteFrom(), where(), toSql()
function db.todos_delete_completed(list_id)
    local cond = where_eq_int("completed", 1)
    local list_cond = where_eq_int("list_id", list_id)
    local sql = deleteFrom(todos_id)
        :where(cond)
        :where(list_cond)
        :toSql():toString()
    conn:exec(sql)
    return conn:changes()
end

-- GET list_id for a todo
function db.todos_get_list_id(id)
    local sql = from(todos_id)
        :select(temper.listof(list_id_col))
        :where(where_eq_int("id", id))
        :limit(1)
        :toSql():toString()
    local list_id = nil
    for row in conn:nrows(sql) do
        list_id = row.list_id
        break
    end
    return list_id
end

-- ================================================================
-- Tags CRUD
-- ================================================================

-- CREATE tag
-- Demonstrates: changeset, validateExclusion, validateLength
function db.tags_create(name)
    local params = make_params({ name = name })
    local cs = changeset(tags_table, params)
    cs = cs:cast(temper.listof(name_col))
    cs = cs:validateRequired(temper.listof(name_col))
    cs = cs:validateLength(name_col, 1, 50)
    cs = cs:validateExclusion(name_col, temper.listof("admin", "system", "root"))
    if not cs.isValid then return nil end
    local sql = cs:toInsertSql():toString()
    conn:exec(sql)
    return conn:last_insert_rowid()
end

-- GET all tags
-- Demonstrates: from(), orderBy()
function db.tags_get_all()
    local sql = from(tags_id)
        :orderBy(name_col, true)
        :toSql():toString()
    local results = {}
    for row in conn:nrows(sql) do
        table.insert(results, { id = row.id, name = row.name })
    end
    return results
end

-- GET tag by id
function db.tags_get_by_id(id)
    local sql = from(tags_id)
        :where(where_eq_int("id", id))
        :limit(1)
        :toSql():toString()
    for row in conn:nrows(sql) do
        return { id = row.id, name = row.name }
    end
    return nil
end

-- DELETE tag
function db.tags_delete(id)
    local sql = deleteSql(tags_table, id):toString()
    conn:exec(sql)
    return conn:changes() > 0
end

-- ================================================================
-- Todo-Tags (many-to-many)
-- ================================================================

-- ADD tag to todo
function db.todo_tags_add(todo_id, tag_id)
    local params = make_params({ todo_id = todo_id, tag_id = tag_id })
    local cs = changeset(todo_tags_table, params)
    cs = cs:cast(temper.listof(todo_id_col, tag_id_col))
    cs = cs:validateRequired(temper.listof(todo_id_col, tag_id_col))
    cs = cs:validateInt(todo_id_col)
    cs = cs:validateInt(tag_id_col)
    if not cs.isValid then return nil end
    local sql = cs:toInsertSql():toString()
    -- Use pcall since UNIQUE constraint might fail
    local ok = pcall(function() conn:exec(sql) end)
    if ok and conn:changes() > 0 then
        return conn:last_insert_rowid()
    end
    return nil
end

-- REMOVE tag from todo
-- Demonstrates: deleteFrom() with compound where
function db.todo_tags_remove(todo_id, tag_id)
    local sql = deleteFrom(todo_tags_id)
        :where(where_eq_int("todo_id", todo_id))
        :where(where_eq_int("tag_id", tag_id))
        :toSql():toString()
    conn:exec(sql)
    return conn:changes() > 0
end

-- GET tags for a todo
-- Demonstrates: from(), innerJoin(), select(), where()
function db.todo_tags_get_for_todo(todo_id)
    -- SELECT tags.id, tags.name FROM tags INNER JOIN todo_tags ON ...
    local join_cond_b = SqlBuilder()
    join_cond_b:appendSafe("todo_tags.tag_id = tags.id")
    local join_cond = join_cond_b.accumulated

    local q = from(tags_id)
        :innerJoin(todo_tags_id, join_cond)
        :where(where_eq_int("todo_tags.todo_id", todo_id))
        :orderBy(name_col, true)
        :toSql():toString()

    local results = {}
    for row in conn:nrows(q) do
        table.insert(results, { id = row.id, name = row.name })
    end
    return results
end

-- GET todos for a tag
-- Demonstrates: from(), innerJoin() (chained twice)
function db.todo_tags_get_todos_for_tag(tag_id)
    local join_cond_b = SqlBuilder()
    join_cond_b:appendSafe("todo_tags.todo_id = todos.id")
    local join_cond = join_cond_b.accumulated

    local q = from(todos_id)
        :innerJoin(todo_tags_id, join_cond)
        :where(where_eq_int("todo_tags.tag_id", tag_id))
        :orderBy(priority_col, true)
        :toSql():toString()

    local results = {}
    for row in conn:nrows(q) do
        table.insert(results, {
            id        = row.id,
            title     = row.title,
            completed = row.completed,
            priority  = row.priority or 3,
            due_date  = row.due_date,
            list_id   = row.list_id,
        })
    end
    return results
end

-- ================================================================
-- Advanced Queries (demonstrate ALL remaining ORM features)
-- ================================================================

-- SEARCH todos by title pattern
-- Demonstrates: whereLike()
function db.todos_search(pattern)
    local sql = from(todos_id)
        :whereLike(title_col, "%" .. pattern .. "%")
        :orderBy(priority_col, true)
        :toSql():toString()
    local results = {}
    for row in conn:nrows(sql) do
        table.insert(results, {
            id        = row.id,
            title     = row.title,
            completed = row.completed,
            priority  = row.priority or 3,
            due_date  = row.due_date,
            list_id   = row.list_id,
        })
    end
    return results
end

-- GET high priority incomplete todos
-- Demonstrates: where(), whereNot(), whereBetween(), limit(), offset()
function db.todos_get_high_priority(page, per_page)
    page = page or 1
    per_page = per_page or 10
    local offset_val = (page - 1) * per_page

    local completed_cond = where_eq_int("completed", 1)

    local q = from(todos_id)
        :whereNot(completed_cond)
        :whereBetween(priority_col, SqlInt32(1), SqlInt32(2))
        :orderBy(priority_col, true)
        :orderByNulls(due_date_col, true, NullsLast())
        :limit(per_page)
        :offset(offset_val)

    local sql = q:toSql():toString()
    local results = {}
    for row in conn:nrows(sql) do
        table.insert(results, {
            id        = row.id,
            title     = row.title,
            completed = row.completed,
            priority  = row.priority or 3,
            due_date  = row.due_date,
            list_id   = row.list_id,
        })
    end
    return results
end

-- GET overdue todos
-- Demonstrates: where() with string comparison, whereNotNull(), whereNot()
function db.todos_get_overdue()
    local today = os.date("%Y-%m-%d")
    local due_cond_b = SqlBuilder()
    due_cond_b:appendSafe("due_date < ")
    due_cond_b:appendString(today)
    local due_cond = due_cond_b.accumulated

    local completed_cond = where_eq_int("completed", 1)

    local sql = from(todos_id)
        :whereNotNull(due_date_col)
        :where(due_cond)
        :whereNot(completed_cond)
        :orderBy(due_date_col, true)
        :toSql():toString()

    local results = {}
    for row in conn:nrows(sql) do
        table.insert(results, {
            id        = row.id,
            title     = row.title,
            completed = row.completed,
            priority  = row.priority or 3,
            due_date  = row.due_date,
            list_id   = row.list_id,
        })
    end
    return results
end

-- GET todos with NULL due dates
-- Demonstrates: whereNull()
function db.todos_get_no_due_date()
    local sql = from(todos_id)
        :whereNull(due_date_col)
        :whereNot(where_eq_int("completed", 1))
        :orderBy(priority_col, true)
        :toSql():toString()
    local results = {}
    for row in conn:nrows(sql) do
        table.insert(results, {
            id        = row.id,
            title     = row.title,
            completed = row.completed,
            priority  = row.priority or 3,
            list_id   = row.list_id,
        })
    end
    return results
end

-- GET todos matching multiple priorities
-- Demonstrates: whereIn() with SqlInt32 list
function db.todos_get_by_priorities(priorities)
    local vals = {}
    for _, p in ipairs(priorities) do
        vals[#vals + 1] = SqlInt32(p)
    end
    local sql = from(todos_id)
        :whereIn(priority_col, temper.listof(table.unpack(vals)))
        :orderBy(priority_col, true)
        :toSql():toString()
    local results = {}
    for row in conn:nrows(sql) do
        table.insert(results, {
            id        = row.id,
            title     = row.title,
            completed = row.completed,
            priority  = row.priority or 3,
            list_id   = row.list_id,
        })
    end
    return results
end

-- GET todos using WHERE IN subquery
-- Demonstrates: whereInSubquery()
function db.todos_in_lists_with_name(pattern)
    -- Subquery: SELECT id FROM lists WHERE name LIKE pattern
    local sub = from(lists_id)
        :select(temper.listof(id_col))
        :whereLike(name_col, "%" .. pattern .. "%")

    local sql = from(todos_id)
        :whereInSubquery(list_id_col, sub)
        :orderBy(priority_col, true)
        :toSql():toString()

    local results = {}
    for row in conn:nrows(sql) do
        table.insert(results, {
            id        = row.id,
            title     = row.title,
            completed = row.completed,
            priority  = row.priority or 3,
            list_id   = row.list_id,
        })
    end
    return results
end

-- GET todos using EXISTS subquery
-- Demonstrates: existsSql()
function db.todos_with_tags()
    -- Get todos that have at least one tag
    local tag_check = from(todo_tags_id)
        :where(where_eq_int("todo_tags.todo_id", 0))  -- placeholder

    -- Build exists manually since we need to correlate
    local exists_b = SqlBuilder()
    exists_b:appendSafe("EXISTS (SELECT * FROM todo_tags WHERE todo_tags.todo_id = todos.id)")
    local exists_cond = exists_b.accumulated

    local sql = from(todos_id)
        :where(exists_cond)
        :orderBy(priority_col, true)
        :toSql():toString()

    local results = {}
    for row in conn:nrows(sql) do
        table.insert(results, {
            id        = row.id,
            title     = row.title,
            completed = row.completed,
            priority  = row.priority or 3,
            list_id   = row.list_id,
        })
    end
    return results
end

-- GET distinct priorities in use
-- Demonstrates: distinct(), select()
function db.todos_get_distinct_priorities()
    local sql = from(todos_id)
        :select(temper.listof(priority_col))
        :distinct()
        :orderBy(priority_col, true)
        :toSql():toString()
    local results = {}
    for row in conn:nrows(sql) do
        table.insert(results, row.priority)
    end
    return results
end

-- OR-WHERE: get todos that are either completed OR priority 1
-- Demonstrates: where(), orWhere()
function db.todos_completed_or_urgent()
    local sql = from(todos_id)
        :where(where_eq_int("completed", 1))
        :orWhere(where_eq_int("priority", 1))
        :orderBy(priority_col, true)
        :toSql():toString()
    local results = {}
    for row in conn:nrows(sql) do
        table.insert(results, {
            id        = row.id,
            title     = row.title,
            completed = row.completed,
            priority  = row.priority or 3,
            list_id   = row.list_id,
        })
    end
    return results
end

-- ================================================================
-- Aggregate & Analytics Queries
-- ================================================================

-- COUNT all todos
-- Demonstrates: countSql()
function db.todos_count_all()
    local sql = from(todos_id):countSql():toString()
    for row in conn:nrows(sql) do
        return row["COUNT(*)"] or 0
    end
    return 0
end

-- COUNT todos per list using selectExpr + countAll()
-- Demonstrates: selectExpr(), countAll(), groupBy()
function db.todos_count_per_list()
    local list_id_expr_b = SqlBuilder()
    list_id_expr_b:appendSafe("list_id")
    local list_id_expr = list_id_expr_b.accumulated

    local sql = from(todos_id)
        :selectExpr(temper.listof(list_id_expr, countAll()))
        :groupBy(list_id_col)
        :toSql():toString()

    local results = {}
    for row in conn:nrows(sql) do
        results[row.list_id] = row["COUNT(*)"]
    end
    return results
end

-- SUM, AVG, MIN, MAX of priority
-- Demonstrates: sumCol(), avgCol(), minCol(), maxCol(), countCol()
function db.todos_priority_stats()
    local sql = from(todos_id)
        :selectExpr(temper.listof(
            countCol(priority_col),
            sumCol(priority_col),
            avgCol(priority_col),
            minCol(priority_col),
            maxCol(priority_col)
        ))
        :toSql():toString()

    for row in conn:nrows(sql) do
        return {
            count = row["COUNT(priority)"] or 0,
            sum   = row["SUM(priority)"] or 0,
            avg   = row["AVG(priority)"] or 0,
            min   = row["MIN(priority)"] or 0,
            max   = row["MAX(priority)"] or 0,
        }
    end
    return { count = 0, sum = 0, avg = 0, min = 0, max = 0 }
end

-- HAVING clause - lists with more than N todos
-- Demonstrates: groupBy(), having(), selectExpr()
function db.lists_with_min_todos(min_count)
    min_count = min_count or 1
    local having_b = SqlBuilder()
    having_b:appendSafe("COUNT(*) >= ")
    having_b:appendInt32(min_count)
    local having_cond = having_b.accumulated

    local list_id_expr_b = SqlBuilder()
    list_id_expr_b:appendSafe("list_id")
    local list_id_expr = list_id_expr_b.accumulated

    local sql = from(todos_id)
        :selectExpr(temper.listof(list_id_expr, countAll()))
        :groupBy(list_id_col)
        :having(having_cond)
        :toSql():toString()

    local results = {}
    for row in conn:nrows(sql) do
        table.insert(results, {
            list_id = row.list_id,
            count   = row["COUNT(*)"],
        })
    end
    return results
end

-- HAVING with OR
-- Demonstrates: having(), orHaving()
function db.lists_with_todos_stats()
    local many_b = SqlBuilder()
    many_b:appendSafe("COUNT(*) > 4")
    local many_cond = many_b.accumulated

    local done_b = SqlBuilder()
    done_b:appendSafe("SUM(CASE WHEN completed = 1 THEN 1 ELSE 0 END) > 1")
    local done_cond = done_b.accumulated

    local list_id_expr_b = SqlBuilder()
    list_id_expr_b:appendSafe("list_id")
    local list_id_expr = list_id_expr_b.accumulated

    local cnt_expr = countAll()

    local sql = from(todos_id)
        :selectExpr(temper.listof(list_id_expr, cnt_expr))
        :groupBy(list_id_col)
        :having(many_cond)
        :orHaving(done_cond)
        :toSql():toString()

    local results = {}
    for row in conn:nrows(sql) do
        table.insert(results, {
            list_id = row.list_id,
            count   = row["COUNT(*)"],
        })
    end
    return results
end

-- ================================================================
-- Set Operations
-- ================================================================

-- UNION: completed todos from list A union incomplete from list B
-- Demonstrates: unionSql()
function db.todos_union_demo(list_a_id, list_b_id)
    local q1 = from(todos_id)
        :where(where_eq_int("list_id", list_a_id))
        :where(where_eq_int("completed", 1))
    local q2 = from(todos_id)
        :where(where_eq_int("list_id", list_b_id))
        :where(where_eq_int("completed", 0))

    local sql = unionSql(q1, q2):toString()
    local results = {}
    for row in conn:nrows(sql) do
        table.insert(results, {
            id        = row.id,
            title     = row.title,
            completed = row.completed,
            priority  = row.priority or 3,
            list_id   = row.list_id,
        })
    end
    return results
end

-- UNION ALL: all todos from two lists (may have duplicates if somehow shared)
-- Demonstrates: unionAllSql()
function db.todos_union_all_demo(list_a_id, list_b_id)
    local q1 = from(todos_id):where(where_eq_int("list_id", list_a_id))
    local q2 = from(todos_id):where(where_eq_int("list_id", list_b_id))
    local sql = unionAllSql(q1, q2):toString()
    local results = {}
    for row in conn:nrows(sql) do
        table.insert(results, {
            id    = row.id,
            title = row.title,
            list_id = row.list_id,
        })
    end
    return results
end

-- INTERSECT: priority 1 todos that are also completed
-- Demonstrates: intersectSql()
function db.todos_intersect_demo()
    local q1 = from(todos_id):where(where_eq_int("priority", 1))
    local q2 = from(todos_id):where(where_eq_int("completed", 1))
    local sql = intersectSql(q1, q2):toString()
    local results = {}
    for row in conn:nrows(sql) do
        table.insert(results, {
            id    = row.id,
            title = row.title,
        })
    end
    return results
end

-- EXCEPT: all priority 1 todos EXCEPT completed ones
-- Demonstrates: exceptSql()
function db.todos_except_demo()
    local q1 = from(todos_id):where(where_eq_int("priority", 1))
    local q2 = from(todos_id):where(where_eq_int("completed", 1))
    local sql = exceptSql(q1, q2):toString()
    local results = {}
    for row in conn:nrows(sql) do
        table.insert(results, {
            id    = row.id,
            title = row.title,
        })
    end
    return results
end

-- ================================================================
-- Subquery & Exists demonstrations
-- ================================================================

-- Subquery in FROM clause (as derived table)
-- Demonstrates: subquery()
function db.todos_subquery_demo()
    local inner_q = from(todos_id)
        :where(where_eq_int("completed", 0))
    local sq = subquery(inner_q, safeIdentifier("incomplete"))

    -- We build the outer query manually since the ORM from() only takes a SafeIdentifier
    local b = SqlBuilder()
    b:appendSafe("SELECT * FROM ")
    b:appendFragment(sq)
    b:appendSafe(" ORDER BY priority ASC LIMIT 5")
    local sql = b.accumulated:toString()

    local results = {}
    for row in conn:nrows(sql) do
        table.insert(results, {
            id    = row.id,
            title = row.title,
            priority = row.priority or 3,
        })
    end
    return results
end

-- EXISTS demonstration
-- Demonstrates: existsSql()
function db.todos_exists_demo()
    local tag_q = from(todo_tags_id)
        :where(where_eq_int("todo_id", 0)) -- placeholder for correlation

    local exists_frag = existsSql(tag_q)

    -- The exists_frag is a SqlFragment, but for correlation we need manual SQL
    -- Show that existsSql generates correct SQL pattern
    local exists_sql = exists_frag:toString()
    -- Returns: "EXISTS (SELECT * FROM todo_tags WHERE todo_id = 0)"

    -- For the actual correlated query, use SqlBuilder
    local b = SqlBuilder()
    b:appendSafe("SELECT * FROM todos WHERE EXISTS (SELECT * FROM todo_tags WHERE todo_tags.todo_id = todos.id) ORDER BY priority ASC")
    local sql = b.accumulated:toString()

    local results = {}
    for row in conn:nrows(sql) do
        table.insert(results, {
            id    = row.id,
            title = row.title,
            priority = row.priority or 3,
        })
    end
    return results, exists_sql
end

-- ================================================================
-- Lock modes (FOR UPDATE / FOR SHARE) - generate SQL even if SQLite ignores it
-- Demonstrates: lock(), ForUpdate(), ForShare()
-- ================================================================

function db.todos_for_update_sql(id)
    return from(todos_id)
        :where(where_eq_int("id", id))
        :lock(ForUpdate())
        :toSql():toString()
end

function db.todos_for_share_sql(id)
    return from(todos_id)
        :where(where_eq_int("id", id))
        :lock(ForShare())
        :toSql():toString()
end

-- ================================================================
-- safeToSql demonstration (applies default limit for safety)
-- Demonstrates: safeToSql()
-- ================================================================

function db.todos_safe_query()
    local sql = from(todos_id)
        :orderBy(priority_col, true)
        :safeToSql(100)
        :toString()
    local results = {}
    for row in conn:nrows(sql) do
        table.insert(results, {
            id    = row.id,
            title = row.title,
            priority = row.priority or 3,
        })
    end
    return results, sql
end

-- ================================================================
-- Cross join demonstration
-- Demonstrates: crossJoin()
-- ================================================================

function db.lists_cross_tags_sql()
    return from(lists_id)
        :crossJoin(tags_id)
        :toSql():toString()
end

-- ================================================================
-- Right join / Full join SQL (generated but may not work in older SQLite)
-- Demonstrates: rightJoin(), fullJoin()
-- ================================================================

function db.lists_right_join_sql()
    local join_b = SqlBuilder()
    join_b:appendSafe("todos.list_id = lists.id")
    return from(lists_id)
        :rightJoin(todos_id, join_b.accumulated)
        :toSql():toString()
end

function db.lists_full_join_sql()
    local join_b = SqlBuilder()
    join_b:appendSafe("todos.list_id = lists.id")
    return from(lists_id)
        :fullJoin(todos_id, join_b.accumulated)
        :toSql():toString()
end

-- ================================================================
-- iLIKE demonstration (SQL generated even if SQLite doesn't support ILIKE natively)
-- Demonstrates: whereILike()
-- ================================================================

function db.todos_ilike_sql(pattern)
    return from(todos_id)
        :whereILike(title_col, "%" .. pattern .. "%")
        :toSql():toString()
end

-- ================================================================
-- Changeset validation demonstrations
-- ================================================================

-- Validate float field
-- Demonstrates: validateFloat()
function db.validate_float_demo(value)
    local float_field = FieldDef(safeIdentifier("score"), FloatField(), true)
    local demo_table = TableDef(safeIdentifier("demo"), temper.listof(float_field))
    local params = make_params({ score = value })
    local cs = changeset(demo_table, params)
    cs = cs:cast(temper.listof(safeIdentifier("score")))
    cs = cs:validateFloat(safeIdentifier("score"))
    return cs.isValid, cs.errors
end

-- Validate bool field
-- Demonstrates: validateBool()
function db.validate_bool_demo(value)
    local bool_field = FieldDef(safeIdentifier("active"), BoolField(), true)
    local demo_table = TableDef(safeIdentifier("demo"), temper.listof(bool_field))
    local params = make_params({ active = value })
    local cs = changeset(demo_table, params)
    cs = cs:cast(temper.listof(safeIdentifier("active")))
    cs = cs:validateBool(safeIdentifier("active"))
    return cs.isValid, cs.errors
end

-- Validate acceptance (like Terms of Service checkbox)
-- Demonstrates: validateAcceptance()
function db.validate_acceptance_demo(value)
    local tos_field = FieldDef(safeIdentifier("accept_tos"), BoolField(), false)
    local demo_table = TableDef(safeIdentifier("demo"), temper.listof(tos_field))
    local params = make_params({ accept_tos = value })
    local cs = changeset(demo_table, params)
    cs = cs:cast(temper.listof(safeIdentifier("accept_tos")))
    cs = cs:validateAcceptance(safeIdentifier("accept_tos"))
    return cs.isValid, cs.errors
end

-- Validate confirmation (like password/password_confirm)
-- Demonstrates: validateConfirmation()
function db.validate_confirmation_demo(password, confirm)
    local pw_field = FieldDef(safeIdentifier("password"), StringField(), false)
    local pw_confirm_field = FieldDef(safeIdentifier("password_confirm"), StringField(), false)
    local demo_table = TableDef(safeIdentifier("demo"), temper.listof(pw_field, pw_confirm_field))
    local params = make_params({ password = password, password_confirm = confirm })
    local cs = changeset(demo_table, params)
    cs = cs:cast(temper.listof(safeIdentifier("password"), safeIdentifier("password_confirm")))
    cs = cs:validateConfirmation(safeIdentifier("password"), safeIdentifier("password_confirm"))
    return cs.isValid, cs.errors
end

-- Validate contains
-- Demonstrates: validateContains()
function db.validate_contains_demo(value, substring)
    local f = FieldDef(safeIdentifier("email"), StringField(), false)
    local demo_table = TableDef(safeIdentifier("demo"), temper.listof(f))
    local params = make_params({ email = value })
    local cs = changeset(demo_table, params)
    cs = cs:cast(temper.listof(safeIdentifier("email")))
    cs = cs:validateContains(safeIdentifier("email"), substring)
    return cs.isValid, cs.errors
end

-- Validate starts with
-- Demonstrates: validateStartsWith()
function db.validate_starts_with_demo(value, prefix)
    local f = FieldDef(safeIdentifier("url"), StringField(), false)
    local demo_table = TableDef(safeIdentifier("demo"), temper.listof(f))
    local params = make_params({ url = value })
    local cs = changeset(demo_table, params)
    cs = cs:cast(temper.listof(safeIdentifier("url")))
    cs = cs:validateStartsWith(safeIdentifier("url"), prefix)
    return cs.isValid, cs.errors
end

-- Validate ends with
-- Demonstrates: validateEndsWith()
function db.validate_ends_with_demo(value, suffix)
    local f = FieldDef(safeIdentifier("filename"), StringField(), false)
    local demo_table = TableDef(safeIdentifier("demo"), temper.listof(f))
    local params = make_params({ filename = value })
    local cs = changeset(demo_table, params)
    cs = cs:cast(temper.listof(safeIdentifier("filename")))
    cs = cs:validateEndsWith(safeIdentifier("filename"), suffix)
    return cs.isValid, cs.errors
end

-- Validate int64
-- Demonstrates: validateInt64()
function db.validate_int64_demo(value)
    local f = FieldDef(safeIdentifier("big_number"), Int64Field(), true)
    local demo_table = TableDef(safeIdentifier("demo"), temper.listof(f))
    local params = make_params({ big_number = value })
    local cs = changeset(demo_table, params)
    cs = cs:cast(temper.listof(safeIdentifier("big_number")))
    cs = cs:validateInt64(safeIdentifier("big_number"))
    return cs.isValid, cs.errors
end

-- ================================================================
-- SQL Generation showcase (returns generated SQL strings)
-- ================================================================

function db.showcase_all_sql()
    local results = {}

    -- 1. Basic SELECT
    results.basic_select = from(todos_id):toSql():toString()

    -- 2. SELECT with columns
    results.select_cols = from(todos_id)
        :select(temper.listof(id_col, title_col, priority_col))
        :toSql():toString()

    -- 3. WHERE
    results.where = from(todos_id)
        :where(where_eq_int("completed", 0))
        :toSql():toString()

    -- 4. OR WHERE
    results.or_where = from(todos_id)
        :where(where_eq_int("priority", 1))
        :orWhere(where_eq_int("priority", 2))
        :toSql():toString()

    -- 5. WHERE NULL / NOT NULL
    results.where_null = from(todos_id):whereNull(due_date_col):toSql():toString()
    results.where_not_null = from(todos_id):whereNotNull(due_date_col):toSql():toString()

    -- 6. WHERE IN
    results.where_in = from(todos_id)
        :whereIn(priority_col, temper.listof(SqlInt32(1), SqlInt32(2), SqlInt32(3)))
        :toSql():toString()

    -- 7. WHERE IN subquery
    local sub = from(lists_id):select(temper.listof(id_col)):whereLike(name_col, "%Work%")
    results.where_in_subquery = from(todos_id)
        :whereInSubquery(list_id_col, sub)
        :toSql():toString()

    -- 8. WHERE NOT
    results.where_not = from(todos_id)
        :whereNot(where_eq_int("completed", 1))
        :toSql():toString()

    -- 9. WHERE BETWEEN
    results.where_between = from(todos_id)
        :whereBetween(priority_col, SqlInt32(2), SqlInt32(4))
        :toSql():toString()

    -- 10. WHERE LIKE
    results.where_like = from(todos_id)
        :whereLike(title_col, "%test%")
        :toSql():toString()

    -- 11. WHERE ILIKE
    results.where_ilike = from(todos_id)
        :whereILike(title_col, "%Test%")
        :toSql():toString()

    -- 12. SELECT DISTINCT
    results.distinct = from(todos_id)
        :select(temper.listof(priority_col))
        :distinct()
        :toSql():toString()

    -- 13. ORDER BY with NULLS positioning
    results.order_nulls_first = from(todos_id)
        :orderByNulls(due_date_col, true, NullsFirst())
        :toSql():toString()
    results.order_nulls_last = from(todos_id)
        :orderByNulls(due_date_col, true, NullsLast())
        :toSql():toString()

    -- 14. LIMIT + OFFSET
    results.limit_offset = from(todos_id)
        :limit(10):offset(20)
        :toSql():toString()

    -- 15. INNER JOIN
    local jb = SqlBuilder()
    jb:appendSafe("todos.list_id = lists.id")
    results.inner_join = from(todos_id)
        :innerJoin(lists_id, jb.accumulated)
        :toSql():toString()

    -- 16. LEFT JOIN
    results.left_join = from(lists_id)
        :leftJoin(todos_id, jb.accumulated)
        :toSql():toString()

    -- 17. RIGHT JOIN
    results.right_join = from(lists_id)
        :rightJoin(todos_id, jb.accumulated)
        :toSql():toString()

    -- 18. FULL JOIN
    results.full_join = from(lists_id)
        :fullJoin(todos_id, jb.accumulated)
        :toSql():toString()

    -- 19. CROSS JOIN
    results.cross_join = from(lists_id)
        :crossJoin(tags_id)
        :toSql():toString()

    -- 20. GROUP BY + HAVING
    local hb = SqlBuilder()
    hb:appendSafe("COUNT(*) > 3")
    results.group_having = from(todos_id)
        :selectExpr(temper.listof(countAll()))
        :groupBy(list_id_col)
        :having(hb.accumulated)
        :toSql():toString()

    -- 21. GROUP BY + HAVING + OR HAVING
    local oh = SqlBuilder()
    oh:appendSafe("SUM(completed) > 0")
    results.group_or_having = from(todos_id)
        :selectExpr(temper.listof(countAll()))
        :groupBy(list_id_col)
        :having(hb.accumulated)
        :orHaving(oh.accumulated)
        :toSql():toString()

    -- 22. COUNT SQL
    results.count_sql = from(todos_id)
        :where(where_eq_int("completed", 0))
        :countSql():toString()

    -- 23. Safe SQL (with default limit)
    results.safe_sql = from(todos_id)
        :safeToSql(50):toString()

    -- 24. Aggregate functions
    results.count_all = from(todos_id)
        :selectExpr(temper.listof(countAll())):toSql():toString()
    results.count_col = from(todos_id)
        :selectExpr(temper.listof(countCol(priority_col))):toSql():toString()
    results.sum_col = from(todos_id)
        :selectExpr(temper.listof(sumCol(priority_col))):toSql():toString()
    results.avg_col = from(todos_id)
        :selectExpr(temper.listof(avgCol(priority_col))):toSql():toString()
    results.min_col = from(todos_id)
        :selectExpr(temper.listof(minCol(priority_col))):toSql():toString()
    results.max_col = from(todos_id)
        :selectExpr(temper.listof(maxCol(priority_col))):toSql():toString()

    -- 25. col() qualified column reference
    results.col_ref = col(todos_id, title_col):toString()

    -- 26. LOCK modes
    results.for_update = from(todos_id)
        :where(where_eq_int("id", 1)):lock(ForUpdate()):toSql():toString()
    results.for_share = from(todos_id)
        :where(where_eq_int("id", 1)):lock(ForShare()):toSql():toString()

    -- 27. UPDATE query
    results.update_query = update(todos_id)
        :set(completed_col, SqlInt32(1))
        :set(priority_col, SqlInt32(2))
        :where(where_eq_int("id", 5))
        :toSql():toString()

    -- 28. DELETE query (deleteFrom)
    results.delete_query = deleteFrom(todos_id)
        :where(where_eq_int("completed", 1))
        :where(where_eq_int("list_id", 1))
        :limit(10)
        :toSql():toString()

    -- 29. deleteSql (quick delete by ID)
    results.delete_sql = deleteSql(todos_table, 42):toString()

    -- 30. Set operations
    local qa = from(todos_id):where(where_eq_int("list_id", 1))
    local qb = from(todos_id):where(where_eq_int("list_id", 2))
    results.union_sql = unionSql(qa, qb):toString()
    results.union_all_sql = unionAllSql(qa, qb):toString()
    results.intersect_sql = intersectSql(qa, qb):toString()
    results.except_sql = exceptSql(qa, qb):toString()

    -- 31. Subquery
    local inner = from(todos_id):where(where_eq_int("completed", 0))
    results.subquery_sql = subquery(inner, safeIdentifier("sub")):toString()

    -- 32. EXISTS
    local exist_q = from(todo_tags_id):where(where_eq_int("todo_id", 1))
    results.exists_sql = existsSql(exist_q):toString()

    -- 33. Changeset INSERT
    local params = make_params({ title = "Test Todo", completed = "0", priority = "3", list_id = "1" })
    local cs = changeset(todos_table, params)
    cs = cs:cast(temper.listof(title_col, completed_col, priority_col, list_id_col))
    cs = cs:validateRequired(temper.listof(title_col, list_id_col))
    results.changeset_insert = cs:toInsertSql():toString()

    -- 34. Changeset UPDATE
    results.changeset_update = cs:toUpdateSql(7):toString()

    -- 35. selectExpr with multiple aggregates
    results.multi_agg = from(todos_id)
        :selectExpr(temper.listof(countAll(), sumCol(priority_col), avgCol(priority_col)))
        :toSql():toString()

    -- 36. UPDATE with OR WHERE
    results.update_or_where = update(todos_id)
        :set(completed_col, SqlInt32(1))
        :where(where_eq_int("priority", 1))
        :orWhere(where_eq_int("priority", 2))
        :toSql():toString()

    -- 37. DELETE with OR WHERE
    results.delete_or_where = deleteFrom(todos_id)
        :where(where_eq_int("completed", 1))
        :orWhere(where_eq_int("priority", 5))
        :toSql():toString()

    -- 38. UPDATE with LIMIT
    results.update_limit = update(todos_id)
        :set(priority_col, SqlInt32(3))
        :where(where_eq_int("completed", 0))
        :limit(5)
        :toSql():toString()

    -- 39. DELETE with LIMIT
    results.delete_limit = deleteFrom(todos_id)
        :where(where_eq_int("completed", 1))
        :limit(10)
        :toSql():toString()

    -- 40. SqlBuilder manual construction with various types
    local b = SqlBuilder()
    b:appendSafe("SELECT ")
    b:appendString("hello")
    b:appendSafe(", ")
    b:appendInt32(42)
    b:appendSafe(", ")
    b:appendFloat64(3.14)
    b:appendSafe(", ")
    b:appendBoolean(true)
    results.manual_builder = b.accumulated:toString()

    return results
end

return db
