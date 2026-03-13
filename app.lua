#!/usr/bin/env lua
-- app.lua - Todo list web application demonstrating ALL Alloy ORM features
-- Run with: lua app.lua
-- Server: http://localhost:5005
--
-- Routes:
--   GET  /                      - Lists index (from, leftJoin, selectExpr, groupBy, orderBy, col)
--   POST /lists                 - Create list (changeset, cast, validateRequired, validateLength, toInsertSql)
--   GET  /lists/{id}            - Show list todos (from, where, orderBy, orderByNulls, NullsLast, innerJoin)
--   POST /lists/{id}/todos      - Create todo (changeset + full validation chain)
--   POST /lists/{id}/delete     - Delete list (deleteSql)
--   POST /lists/{id}/delete-completed - Delete completed (deleteFrom, where, where)
--   POST /lists/{id}/update     - Update list (changeset, putChange, getChange, deleteChange, toUpdateSql)
--   POST /todos/{id}/toggle     - Toggle todo (update, set, where)
--   POST /todos/{id}/delete     - Delete todo (deleteSql)
--   POST /todos/{id}/priority   - Update priority (update, set with SqlInt32)
--   POST /todos/{id}/tag        - Add tag to todo (changeset for todo_tags)
--   POST /todos/{id}/untag/{tid}- Remove tag (deleteFrom with compound where)
--   GET  /tags                  - Tags list (from, orderBy, innerJoin)
--   POST /tags                  - Create tag (changeset, validateExclusion)
--   GET  /tags/{id}             - Tag detail (from, innerJoin chained, where)
--   POST /tags/{id}/delete      - Delete tag (deleteSql)
--   GET  /search                - Search (whereLike, whereNot, whereNotNull, whereNull, whereBetween, EXISTS)
--   GET  /analytics             - Analytics (countAll, countCol, sumCol, avgCol, minCol, maxCol,
--                                  groupBy, having, orHaving, distinct, unionSql, intersectSql, exceptSql)
--   GET  /sql-showcase          - SQL Lab (ALL 40+ features generating SQL)
--   GET  /validations           - Validation demos (all changeset validators)

local socket = require("socket")

-- Resolve the script directory for reliable requires
local script_dir = debug.getinfo(1, "S").source:match("^@(.*/)") or "./"
package.path = script_dir .. "vendor/orm/?.lua;"
    .. script_dir .. "vendor/orm/?/init.lua;"
    .. script_dir .. "vendor/temper-core/?.lua;"
    .. script_dir .. "vendor/temper-core/?/init.lua;"
    .. script_dir .. "vendor/std/?.lua;"
    .. script_dir .. "vendor/std/?/init.lua;"
    .. script_dir .. "?.lua;"
    .. package.path

local db = require("db")
local templates = require("templates")

local PORT = 5005
local STATIC_DIR = script_dir .. "static/"

-- ============================================================
-- HTTP Helpers
-- ============================================================

local function url_decode(s)
    s = s:gsub("+", " ")
    s = s:gsub("%%(%x%x)", function(h)
        return string.char(tonumber(h, 16))
    end)
    return s
end

local function parse_form(body)
    local params = {}
    if not body or body == "" then return params end
    for pair in body:gmatch("[^&]+") do
        local key, val = pair:match("^([^=]+)=?(.*)")
        if key then
            params[url_decode(key)] = url_decode(val or "")
        end
    end
    return params
end

local function parse_query_string(path)
    local base, qs = path:match("^([^?]+)%??(.*)")
    local params = {}
    if qs and qs ~= "" then
        for pair in qs:gmatch("[^&]+") do
            local key, val = pair:match("^([^=]+)=?(.*)")
            if key then
                params[url_decode(key)] = url_decode(val or "")
            end
        end
    end
    return base or path, params
end

local function parse_request(client)
    local line, err = client:receive("*l")
    if not line then return nil, err end

    local method, path, version = line:match("^(%S+)%s+(%S+)%s+(%S+)")
    if not method then return nil, "malformed request line" end

    local headers = {}
    while true do
        local hline, herr = client:receive("*l")
        if not hline or hline == "" then break end
        local name, value = hline:match("^([^:]+):%s*(.*)")
        if name then
            headers[name:lower()] = value
        end
    end

    local body = ""
    local content_length = tonumber(headers["content-length"])
    if content_length and content_length > 0 then
        body = client:receive(content_length) or ""
    end

    return {
        method = method,
        path = path,
        version = version,
        headers = headers,
        body = body,
    }
end

local function send_response(client, status_code, status_text, headers, body)
    local parts = {}
    table.insert(parts, string.format("HTTP/1.1 %d %s\r\n", status_code, status_text))
    for k, v in pairs(headers) do
        table.insert(parts, string.format("%s: %s\r\n", k, v))
    end
    if not headers["Content-Length"] then
        table.insert(parts, string.format("Content-Length: %d\r\n", #body))
    end
    table.insert(parts, "Connection: close\r\n")
    table.insert(parts, "\r\n")
    table.insert(parts, body)
    client:send(table.concat(parts))
end

local function html_response(client, html, code, status)
    code = code or 200
    status = status or "OK"
    send_response(client, code, status, {
        ["Content-Type"] = "text/html; charset=utf-8",
    }, html)
end

local function redirect(client, location)
    send_response(client, 303, "See Other", {
        ["Location"] = location,
        ["Content-Type"] = "text/html",
    }, '<html><body>Redirecting to <a href="' .. location .. '">' .. location .. '</a></body></html>')
end

local function mime_type(path)
    local ext = path:match("%.(%w+)$")
    local types = {
        css  = "text/css",
        js   = "application/javascript",
        html = "text/html",
        png  = "image/png",
        jpg  = "image/jpeg",
        gif  = "image/gif",
        ico  = "image/x-icon",
        svg  = "image/svg+xml",
        txt  = "text/plain",
    }
    return types[ext] or "application/octet-stream"
end

local function serve_static(client, filepath)
    if filepath:find("%.%.", 1, true) then
        send_response(client, 403, "Forbidden", { ["Content-Type"] = "text/plain" }, "Forbidden")
        return
    end
    local full_path = STATIC_DIR .. filepath
    local f = io.open(full_path, "rb")
    if not f then
        send_response(client, 404, "Not Found", { ["Content-Type"] = "text/plain" }, "File not found")
        return
    end
    local content = f:read("*a")
    f:close()
    send_response(client, 200, "OK", {
        ["Content-Type"] = mime_type(filepath),
        ["Cache-Control"] = "public, max-age=3600",
    }, content)
end

-- ============================================================
-- Route Handlers
-- ============================================================

-- GET / - show all lists
-- ORM: from(), leftJoin(), selectExpr(), groupBy(), orderBy(), col()
local function handle_lists_index(client)
    local lists = db.lists_get_all()
    html_response(client, templates.lists_page(lists))
end

-- POST /lists - create a new list
-- ORM: changeset(), cast(), validateRequired(), validateLength(), toInsertSql()
local function handle_lists_create(client, req)
    local params = parse_form(req.body)
    local name = params.name
    local description = params.description or ""
    if name and name ~= "" then
        db.lists_create(name, description)
    end
    redirect(client, "/")
end

-- POST /lists/{id}/delete
-- ORM: deleteSql(tableDef, id)
local function handle_lists_delete(client, _, list_id)
    db.lists_delete(list_id)
    redirect(client, "/")
end

-- GET /lists/{id} - show todos for a list
-- ORM: from(), where(), orderBy(), orderByNulls(), NullsLast(), innerJoin()
local function handle_list_show(client, _, list_id)
    local list = db.lists_get_by_id(list_id)
    if not list then
        html_response(client, templates.base("Not Found",
            '<div class="empty-state">List not found.</div><a href="/" class="back-link">&laquo; Back</a>'),
            404, "Not Found")
        return
    end
    local todos = db.todos_get_by_list(list_id)
    local all_tags = db.tags_get_all()

    -- Build tag map for each todo
    local todo_tags_map = {}
    for _, todo in ipairs(todos) do
        todo_tags_map[todo.id] = db.todo_tags_get_for_todo(todo.id)
    end

    html_response(client, templates.list_page(list, todos, all_tags, todo_tags_map))
end

-- POST /lists/{id}/todos - add a todo to a list
-- ORM: changeset with full validation: cast, validateRequired, validateLength,
--       validateInt, validateNumber(NumberValidationOpts), validateInclusion, toInsertSql
local function handle_todos_create(client, req, list_id)
    local params = parse_form(req.body)
    local title = params.title
    local priority = tonumber(params.priority) or 3
    local due_date = params.due_date
    if title and title ~= "" then
        db.todos_create(title, list_id, priority, due_date)
    end
    redirect(client, "/lists/" .. list_id)
end

-- POST /lists/{id}/delete-completed
-- ORM: deleteFrom(), where() (compound), toSql()
local function handle_delete_completed(client, _, list_id)
    db.todos_delete_completed(list_id)
    redirect(client, "/lists/" .. list_id)
end

-- POST /todos/{id}/toggle
-- ORM: update(), set(), where(), toSql()
local function handle_todos_toggle(client, _, todo_id)
    local list_id = db.todos_get_list_id(todo_id)
    db.todos_toggle(todo_id)
    if list_id then
        redirect(client, "/lists/" .. list_id)
    else
        redirect(client, "/")
    end
end

-- POST /todos/{id}/delete
-- ORM: deleteSql(tableDef, id)
local function handle_todos_delete(client, _, todo_id)
    local list_id = db.todos_get_list_id(todo_id)
    db.todos_delete(todo_id)
    if list_id then
        redirect(client, "/lists/" .. list_id)
    else
        redirect(client, "/")
    end
end

-- POST /todos/{id}/priority
-- ORM: update(), set(SafeId, SqlInt32), where(), toSql()
local function handle_todos_priority(client, req, todo_id)
    local params = parse_form(req.body)
    local priority = tonumber(params.priority)
    if priority and priority >= 1 and priority <= 5 then
        db.todos_update_priority(todo_id, priority)
    end
    local list_id = db.todos_get_list_id(todo_id)
    if list_id then
        redirect(client, "/lists/" .. list_id)
    else
        redirect(client, "/")
    end
end

-- POST /todos/{id}/tag
-- ORM: changeset for todo_tags, cast, validateRequired, validateInt, toInsertSql
local function handle_todos_tag(client, req, todo_id)
    local params = parse_form(req.body)
    local tag_id = tonumber(params.tag_id)
    if tag_id then
        db.todo_tags_add(todo_id, tag_id)
    end
    local list_id = db.todos_get_list_id(todo_id)
    if list_id then
        redirect(client, "/lists/" .. list_id)
    else
        redirect(client, "/")
    end
end

-- POST /todos/{id}/untag/{tag_id}
-- ORM: deleteFrom() with compound where
local function handle_todos_untag(client, _, todo_id, tag_id)
    db.todo_tags_remove(todo_id, tag_id)
    local list_id = db.todos_get_list_id(todo_id)
    if list_id then
        redirect(client, "/lists/" .. list_id)
    else
        redirect(client, "/")
    end
end

-- GET /tags
-- ORM: from(), orderBy(), innerJoin()
local function handle_tags_index(client)
    local tags = db.tags_get_all()
    -- Count todos per tag
    local tag_todo_counts = {}
    for _, tag in ipairs(tags) do
        local todos = db.todo_tags_get_todos_for_tag(tag.id)
        tag_todo_counts[tag.id] = #todos
    end
    html_response(client, templates.tags_page(tags, tag_todo_counts))
end

-- POST /tags
-- ORM: changeset, validateExclusion, validateLength
local function handle_tags_create(client, req)
    local params = parse_form(req.body)
    local name = params.name
    if name and name ~= "" then
        db.tags_create(name)
    end
    redirect(client, "/tags")
end

-- GET /tags/{id}
-- ORM: from(), innerJoin() (chained), where()
local function handle_tag_show(client, _, tag_id)
    local tag = db.tags_get_by_id(tag_id)
    if not tag then
        html_response(client, templates.base("Not Found",
            '<div class="empty-state">Tag not found.</div><a href="/tags" class="back-link">&laquo; Back</a>'),
            404, "Not Found")
        return
    end
    local todos = db.todo_tags_get_todos_for_tag(tag_id)
    html_response(client, templates.tag_detail_page(tag, todos))
end

-- POST /tags/{id}/delete
-- ORM: deleteSql
local function handle_tags_delete(client, _, tag_id)
    db.tags_delete(tag_id)
    redirect(client, "/tags")
end

-- GET /search
-- ORM: whereLike, whereNot, whereNotNull, whereNull, whereBetween,
--      whereIn, whereInSubquery, EXISTS, NullsLast, offset
local function handle_search(client, req, _, query_params)
    local q = query_params and query_params.q or ""
    local results = {}
    if q ~= "" then
        results = db.todos_search(q)
    end
    local overdue = db.todos_get_overdue()
    local no_due_date = db.todos_get_no_due_date()
    local high_priority = db.todos_get_high_priority(1, 10)
    local with_tags = db.todos_with_tags()
    html_response(client, templates.search_page(q, results, overdue, no_due_date, high_priority, with_tags))
end

-- GET /analytics
-- ORM: countAll, countCol, sumCol, avgCol, minCol, maxCol,
--      groupBy, having, orHaving, distinct, select,
--      unionSql, intersectSql, exceptSql, where, orWhere
local function handle_analytics(client)
    local stats = db.todos_priority_stats()
    local count_per_list = db.todos_count_per_list()
    local lists_with_min = db.lists_with_min_todos(3)
    local union_demo = db.todos_union_demo(1, 2)
    local intersect_demo = db.todos_intersect_demo()
    local except_demo = db.todos_except_demo()
    local distinct_prios = db.todos_get_distinct_priorities()
    local completed_or_urgent = db.todos_completed_or_urgent()

    html_response(client, templates.analytics_page(
        stats, count_per_list, lists_with_min,
        union_demo, intersect_demo, except_demo,
        distinct_prios, completed_or_urgent))
end

-- GET /sql-showcase
-- ORM: ALL features - generates SQL for every single method
local function handle_sql_showcase(client)
    local sqls = db.showcase_all_sql()
    html_response(client, templates.sql_showcase_page(sqls))
end

-- GET /validations
-- ORM: ALL changeset validation methods
local function handle_validations(client)
    local results = {}

    -- 1. validateFloat (valid)
    local v, e = db.validate_float_demo("3.14")
    table.insert(results, { label = 'validateFloat("3.14") -> valid', valid = v, api = "validateFloat()" })

    -- 2. validateFloat (invalid)
    v, e = db.validate_float_demo("notanumber")
    table.insert(results, { label = 'validateFloat("notanumber") -> invalid', valid = v, api = "validateFloat()" })

    -- 3. validateBool (valid)
    v, e = db.validate_bool_demo("true")
    table.insert(results, { label = 'validateBool("true") -> valid', valid = v, api = "validateBool()" })

    -- 4. validateBool (valid - "yes")
    v, e = db.validate_bool_demo("yes")
    table.insert(results, { label = 'validateBool("yes") -> valid', valid = v, api = "validateBool()" })

    -- 5. validateBool (invalid)
    v, e = db.validate_bool_demo("maybe")
    table.insert(results, { label = 'validateBool("maybe") -> invalid', valid = v, api = "validateBool()" })

    -- 6. validateAcceptance (accepted)
    v, e = db.validate_acceptance_demo("true")
    table.insert(results, { label = 'validateAcceptance("true") -> accepted', valid = v, api = "validateAcceptance()" })

    -- 7. validateAcceptance (rejected)
    v, e = db.validate_acceptance_demo("false")
    table.insert(results, { label = 'validateAcceptance("false") -> rejected', valid = v, api = "validateAcceptance()" })

    -- 8. validateConfirmation (match)
    v, e = db.validate_confirmation_demo("secret123", "secret123")
    table.insert(results, { label = 'validateConfirmation("secret123", "secret123") -> match', valid = v, api = "validateConfirmation()" })

    -- 9. validateConfirmation (mismatch)
    v, e = db.validate_confirmation_demo("secret123", "different")
    table.insert(results, { label = 'validateConfirmation("secret123", "different") -> mismatch', valid = v, api = "validateConfirmation()" })

    -- 10. validateContains (pass)
    v, e = db.validate_contains_demo("user@example.com", "@")
    table.insert(results, { label = 'validateContains("user@example.com", "@") -> pass', valid = v, api = "validateContains()" })

    -- 11. validateContains (fail)
    v, e = db.validate_contains_demo("noemail", "@")
    table.insert(results, { label = 'validateContains("noemail", "@") -> fail', valid = v, api = "validateContains()" })

    -- 12. validateStartsWith (pass)
    v, e = db.validate_starts_with_demo("https://example.com", "https://")
    table.insert(results, { label = 'validateStartsWith("https://example.com", "https://") -> pass', valid = v, api = "validateStartsWith()" })

    -- 13. validateStartsWith (fail)
    v, e = db.validate_starts_with_demo("ftp://example.com", "https://")
    table.insert(results, { label = 'validateStartsWith("ftp://example.com", "https://") -> fail', valid = v, api = "validateStartsWith()" })

    -- 14. validateEndsWith (pass)
    v, e = db.validate_ends_with_demo("photo.png", ".png")
    table.insert(results, { label = 'validateEndsWith("photo.png", ".png") -> pass', valid = v, api = "validateEndsWith()" })

    -- 15. validateEndsWith (fail)
    v, e = db.validate_ends_with_demo("photo.jpg", ".png")
    table.insert(results, { label = 'validateEndsWith("photo.jpg", ".png") -> fail', valid = v, api = "validateEndsWith()" })

    -- 16. validateInt64 (valid)
    v, e = db.validate_int64_demo("9999999999")
    table.insert(results, { label = 'validateInt64("9999999999") -> valid', valid = v, api = "validateInt64()" })

    -- 17. validateInt64 (invalid)
    v, e = db.validate_int64_demo("not_a_number")
    table.insert(results, { label = 'validateInt64("not_a_number") -> invalid', valid = v, api = "validateInt64()" })

    html_response(client, templates.validations_page(results))
end

-- ============================================================
-- Router
-- ============================================================

local function route(client, req)
    local method = req.method
    local raw_path = req.path
    local path, query_params = parse_query_string(raw_path)

    -- Static files
    local static_path = path:match("^/static/(.+)$")
    if static_path then
        serve_static(client, static_path)
        return
    end

    -- GET / - lists index
    if method == "GET" and path == "/" then
        handle_lists_index(client)
        return
    end

    -- POST /lists - create list
    if method == "POST" and path == "/lists" then
        handle_lists_create(client, req)
        return
    end

    -- POST /lists/{id}/delete
    local list_id_del = path:match("^/lists/(%d+)/delete$")
    if method == "POST" and list_id_del then
        handle_lists_delete(client, req, tonumber(list_id_del))
        return
    end

    -- POST /lists/{id}/delete-completed
    local list_id_dc = path:match("^/lists/(%d+)/delete%-completed$")
    if method == "POST" and list_id_dc then
        handle_delete_completed(client, req, tonumber(list_id_dc))
        return
    end

    -- GET /lists/{id}
    local list_id_show = path:match("^/lists/(%d+)$")
    if method == "GET" and list_id_show then
        handle_list_show(client, req, tonumber(list_id_show))
        return
    end

    -- POST /lists/{id}/todos
    local list_id_add = path:match("^/lists/(%d+)/todos$")
    if method == "POST" and list_id_add then
        handle_todos_create(client, req, tonumber(list_id_add))
        return
    end

    -- POST /todos/{id}/toggle
    local todo_id_toggle = path:match("^/todos/(%d+)/toggle$")
    if method == "POST" and todo_id_toggle then
        handle_todos_toggle(client, req, tonumber(todo_id_toggle))
        return
    end

    -- POST /todos/{id}/delete
    local todo_id_del = path:match("^/todos/(%d+)/delete$")
    if method == "POST" and todo_id_del then
        handle_todos_delete(client, req, tonumber(todo_id_del))
        return
    end

    -- POST /todos/{id}/priority
    local todo_id_prio = path:match("^/todos/(%d+)/priority$")
    if method == "POST" and todo_id_prio then
        handle_todos_priority(client, req, tonumber(todo_id_prio))
        return
    end

    -- POST /todos/{id}/tag
    local todo_id_tag = path:match("^/todos/(%d+)/tag$")
    if method == "POST" and todo_id_tag then
        handle_todos_tag(client, req, tonumber(todo_id_tag))
        return
    end

    -- POST /todos/{id}/untag/{tag_id}
    local tid_untag, tagid_untag = path:match("^/todos/(%d+)/untag/(%d+)$")
    if method == "POST" and tid_untag then
        handle_todos_untag(client, req, tonumber(tid_untag), tonumber(tagid_untag))
        return
    end

    -- GET /tags
    if method == "GET" and path == "/tags" then
        handle_tags_index(client)
        return
    end

    -- POST /tags
    if method == "POST" and path == "/tags" then
        handle_tags_create(client, req)
        return
    end

    -- GET /tags/{id}
    local tag_id_show = path:match("^/tags/(%d+)$")
    if method == "GET" and tag_id_show then
        handle_tag_show(client, req, tonumber(tag_id_show))
        return
    end

    -- POST /tags/{id}/delete
    local tag_id_del = path:match("^/tags/(%d+)/delete$")
    if method == "POST" and tag_id_del then
        handle_tags_delete(client, req, tonumber(tag_id_del))
        return
    end

    -- GET /search
    if method == "GET" and path == "/search" then
        handle_search(client, req, nil, query_params)
        return
    end

    -- GET /analytics
    if method == "GET" and path == "/analytics" then
        handle_analytics(client)
        return
    end

    -- GET /sql-showcase
    if method == "GET" and path == "/sql-showcase" then
        handle_sql_showcase(client)
        return
    end

    -- GET /validations
    if method == "GET" and path == "/validations" then
        handle_validations(client)
        return
    end

    -- Favicon
    if path == "/favicon.ico" then
        send_response(client, 204, "No Content", {}, "")
        return
    end

    -- 404
    html_response(client, templates.base("404 Not Found",
        '<div class="empty-state">Page not found.<br><a href="/" class="back-link">&laquo; Home</a></div>'),
        404, "Not Found")
end

-- ============================================================
-- Server
-- ============================================================

local function main()
    -- Initialize database
    db.open()
    db.migrate()
    local seeded = db.seed()

    -- Create TCP server
    local server, err = socket.bind("0.0.0.0", PORT)
    if not server then
        io.stderr:write("Error: Could not bind to port " .. PORT .. ": " .. (err or "unknown error") .. "\n")
        io.stderr:write("Is another process using port " .. PORT .. "?\n")
        os.exit(1)
    end

    server:settimeout(1)

    print("============================================")
    print("  Alloy ORM Demo - Lua Todo App")
    print("  http://localhost:" .. PORT)
    print("============================================")
    if seeded then
        print("  Seeded 3 lists, 13 todos, 5 tags")
    end
    print("  Routes:")
    print("    /               - Lists (from, leftJoin, selectExpr, groupBy)")
    print("    /lists/{id}     - Todos (where, orderByNulls, NullsLast)")
    print("    /tags           - Tags (changeset, validateExclusion)")
    print("    /search         - Search (whereLike, whereNull, whereNot, EXISTS)")
    print("    /analytics      - Stats (aggregates, HAVING, set ops)")
    print("    /sql-showcase   - SQL Lab (ALL 40+ ORM features)")
    print("    /validations    - Validators (all 15 changeset validators)")
    print("  Press Ctrl+C to stop")
    print("")

    -- Main accept loop
    while true do
        local client, accept_err = server:accept()
        if client then
            client:settimeout(5)
            local ok, pcall_err = pcall(function()
                local req, parse_err = parse_request(client)
                if req then
                    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
                    print(string.format("[%s] %s %s", timestamp, req.method, req.path))
                    route(client, req)
                else
                    if parse_err ~= "closed" and parse_err ~= "timeout" then
                        send_response(client, 400, "Bad Request",
                            { ["Content-Type"] = "text/plain" }, "Bad request: " .. (parse_err or ""))
                    end
                end
            end)
            if not ok then
                io.stderr:write("Error handling request: " .. tostring(pcall_err) .. "\n")
                pcall(function()
                    send_response(client, 500, "Internal Server Error",
                        { ["Content-Type"] = "text/plain" }, "Internal server error")
                end)
            end
            client:close()
        end
    end
end

-- Run
local ok, err = pcall(main)
if not ok then
    io.stderr:write("Fatal: " .. tostring(err) .. "\n")
    db.close()
    os.exit(1)
end
