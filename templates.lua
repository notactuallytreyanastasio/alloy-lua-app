-- templates.lua - HTML template functions for the Alloy ORM demo app
local templates = {}

-- HTML-escape a string
local function esc(s)
    if not s then return "" end
    s = tostring(s)
    s = s:gsub("&", "&amp;")
    s = s:gsub("<", "&lt;")
    s = s:gsub(">", "&gt;")
    s = s:gsub('"', "&quot;")
    s = s:gsub("'", "&#39;")
    return s
end

-- Priority label
local function priority_label(p)
    local labels = { "Critical", "High", "Medium", "Low", "Minimal" }
    return labels[p] or "Medium"
end

local function priority_color(p)
    local colors = { "#cc0000", "#ff6600", "#0066cc", "#008800", "#888888" }
    return colors[p] or "#0066cc"
end

-- Base template: Mac menubar + Win95 window chrome
function templates.base(title, content, status_text)
    status_text = status_text or "Ready"
    return [[<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>]] .. esc(title) .. [[ - Alloy ORM Demo</title>
    <link rel="stylesheet" href="/static/retro.css">
    <style>
        .list-card {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 6px 8px;
            border-bottom: 1px solid #e0e0e0;
            cursor: default;
        }
        .list-card:last-child { border-bottom: none; }
        .list-card:hover {
            background: var(--win95-selection);
            color: var(--win95-selection-text);
        }
        .list-card:hover .list-meta { color: var(--win95-selection-text); }
        .list-card:hover .win95-btn.danger { color: #ff9999; }
        .list-card a {
            text-decoration: none;
            color: inherit;
            flex: 1;
        }
        .list-meta {
            font-size: 13px;
            color: var(--win95-btn-shadow);
        }
        .empty-state {
            padding: 24px;
            text-align: center;
            color: var(--win95-btn-shadow);
            font-size: 15px;
        }
        .back-link {
            display: inline-block;
            margin-bottom: 8px;
            color: var(--win95-title);
            text-decoration: none;
            font-size: 14px;
        }
        .back-link:hover { text-decoration: underline; }
        .progress-bar {
            width: 100%;
            height: 16px;
            border: 2px solid;
            border-color: var(--win95-btn-shadow) var(--win95-btn-highlight) var(--win95-btn-highlight) var(--win95-btn-shadow);
            box-shadow: inset 1px 1px 0 var(--win95-btn-dark-shadow);
            background: var(--win95-field-bg);
        }
        .progress-fill {
            height: 100%;
            background: var(--win95-title);
            transition: width 0.3s;
        }
        .priority-badge {
            display: inline-block;
            padding: 1px 6px;
            font-size: 12px;
            border: 1px solid;
            margin-right: 4px;
            min-width: 50px;
            text-align: center;
        }
        .tag-badge {
            display: inline-block;
            padding: 1px 6px;
            font-size: 11px;
            background: #e0e0e0;
            border: 1px solid #999;
            margin: 1px 2px;
        }
        .due-date { font-size: 12px; color: #666; }
        .due-date.overdue { color: #cc0000; font-weight: bold; }
        .sql-block {
            background: #1a1a2e;
            color: #00ff00;
            font-family: 'Courier New', monospace;
            padding: 8px;
            margin: 4px 0;
            font-size: 13px;
            border: 2px solid;
            border-color: var(--win95-btn-shadow) var(--win95-btn-highlight) var(--win95-btn-highlight) var(--win95-btn-shadow);
            white-space: pre-wrap;
            word-break: break-all;
            overflow-x: auto;
        }
        .feature-label {
            font-size: 12px;
            font-weight: bold;
            color: var(--win95-title);
            margin-top: 8px;
            margin-bottom: 2px;
        }
        .stat-box {
            display: inline-block;
            padding: 4px 12px;
            margin: 2px;
            border: 2px solid;
            border-color: var(--win95-btn-highlight) var(--win95-btn-dark-shadow) var(--win95-btn-dark-shadow) var(--win95-btn-highlight);
            background: var(--win95-field-bg);
            text-align: center;
        }
        .stat-value { font-size: 18px; font-weight: bold; }
        .stat-label { font-size: 11px; color: #666; }
        .nav-links {
            display: flex;
            gap: 8px;
            padding: 4px;
            border-bottom: 1px solid var(--win95-btn-shadow);
            margin-bottom: 8px;
            flex-wrap: wrap;
        }
        .nav-links a {
            font-size: 13px;
            color: var(--win95-title);
            text-decoration: none;
            padding: 2px 8px;
            border: 1px solid transparent;
        }
        .nav-links a:hover {
            background: var(--win95-selection);
            color: var(--win95-selection-text);
        }
        .nav-links a.active {
            background: var(--win95-title);
            color: var(--win95-title-text);
        }
        .validation-result {
            padding: 4px 8px;
            margin: 2px 0;
            font-size: 13px;
        }
        .validation-pass { background: #d4edda; border-left: 3px solid #28a745; }
        .validation-fail { background: #f8d7da; border-left: 3px solid #dc3545; }
    </style>
</head>
<body>
    <div class="mac-menubar">
        <span class="apple-logo">&#63743;</span>
        <span class="menu-item app-name">Alloy ORM</span>
        <span class="menu-item"><a href="/" style="text-decoration:none;color:inherit">Lists</a></span>
        <span class="menu-item"><a href="/tags" style="text-decoration:none;color:inherit">Tags</a></span>
        <span class="menu-item"><a href="/analytics" style="text-decoration:none;color:inherit">Analytics</a></span>
        <span class="menu-item"><a href="/search" style="text-decoration:none;color:inherit">Search</a></span>
        <span class="menu-item"><a href="/sql-showcase" style="text-decoration:none;color:inherit">SQL Lab</a></span>
        <span class="menu-item"><a href="/validations" style="text-decoration:none;color:inherit">Validations</a></span>
        <span style="flex:1"></span>
        <span class="menu-item" style="font-weight:normal">Lua 5.4</span>
    </div>
    <div class="desktop">
        <div class="win95-window">
            <div class="win95-titlebar">
                <span class="title-text">]] .. esc(title) .. [[</span>
                <div class="win95-titlebar-buttons">
                    <button class="win95-titlebar-btn">_</button>
                    <button class="win95-titlebar-btn">&#9633;</button>
                    <button class="win95-titlebar-btn">X</button>
                </div>
            </div>
            <div class="win95-body">
                ]] .. content .. [[
            </div>
            <div class="win95-statusbar">
                <div class="status-section">]] .. esc(status_text) .. [[</div>
                <div class="status-section" style="flex:0;white-space:nowrap">
                    <span class="lang-badge">Lua</span>
                    <span class="lang-badge">Alloy ORM</span>
                </div>
            </div>
        </div>
    </div>
</body>
</html>]]
end

-- ================================================================
-- Lists page
-- ================================================================
function templates.lists_page(lists)
    local parts = {}

    -- New list form
    table.insert(parts, [[
        <div class="win95-toolbar">
            <form method="POST" action="/lists" style="display:flex;gap:4px;width:100%">
                <input type="text" name="name" class="win95-input" placeholder="List name..." required style="flex:2">
                <input type="text" name="description" class="win95-input" placeholder="Description..." style="flex:3">
                <button type="submit" class="win95-btn primary">New List</button>
            </form>
        </div>
    ]])

    table.insert(parts, '<div class="win95-sunken" style="min-height:200px;margin-top:8px">')

    if #lists == 0 then
        table.insert(parts, '<div class="empty-state">No lists yet. Create one above!</div>')
    else
        for _, list in ipairs(lists) do
            local pct = 0
            if list.total > 0 then
                pct = math.floor((list.done / list.total) * 100)
            end
            local desc_txt = ""
            if list.description and list.description ~= "" then
                desc_txt = string.format('<div class="list-meta">%s</div>', esc(list.description))
            end
            table.insert(parts, string.format([[
                <div class="list-card">
                    <a href="/lists/%d">
                        <div style="font-size:15px;font-weight:bold">%s</div>
                        %s
                        <div class="list-meta">%d/%d tasks done (%d%%)</div>
                    </a>
                    <form method="POST" action="/lists/%d/delete" style="margin:0"
                          onsubmit="return confirm('Delete list and all its todos?')">
                        <button type="submit" class="win95-btn danger" title="Delete list">X</button>
                    </form>
                </div>
            ]], list.id, esc(list.name), desc_txt, list.done, list.total, pct, list.id))
        end
    end

    table.insert(parts, '</div>')

    local total_lists = #lists
    local total_todos = 0
    for _, l in ipairs(lists) do total_todos = total_todos + l.total end

    local status = string.format("%d list(s), %d total todo(s) | ORM: from(), leftJoin(), selectExpr(), groupBy()", total_lists, total_todos)
    return templates.base("My Todo Lists", table.concat(parts), status)
end

-- ================================================================
-- Single list page (with tags, priority, due dates)
-- ================================================================
function templates.list_page(list, todos, all_tags, todo_tags_map)
    todo_tags_map = todo_tags_map or {}
    all_tags = all_tags or {}
    local parts = {}

    -- Back link
    table.insert(parts, '<a href="/" class="back-link">&laquo; Back to Lists</a>')

    -- Progress bar
    local done = 0
    for _, t in ipairs(todos) do
        if t.completed == 1 then done = done + 1 end
    end
    local pct = 0
    if #todos > 0 then
        pct = math.floor((done / #todos) * 100)
    end

    table.insert(parts, string.format([[
        <div style="margin-bottom:8px">
            <div style="display:flex;justify-content:space-between;margin-bottom:2px">
                <span style="font-size:13px">Progress</span>
                <span style="font-size:13px">%d/%d (%d%%)</span>
            </div>
            <div class="progress-bar"><div class="progress-fill" style="width:%d%%"></div></div>
        </div>
    ]], done, #todos, pct, pct))

    -- Description
    if list.description and list.description ~= "" then
        table.insert(parts, string.format(
            '<div style="font-size:13px;color:#666;margin-bottom:8px;padding:4px;background:#f0f0f0">%s</div>',
            esc(list.description)))
    end

    -- Add todo form with priority and due date
    table.insert(parts, string.format([[
        <div class="win95-toolbar">
            <form method="POST" action="/lists/%d/todos" style="display:flex;gap:4px;width:100%%">
                <input type="text" name="title" class="win95-input" placeholder="Add todo..." required style="flex:3">
                <select name="priority" class="win95-select" style="flex:1;width:auto">
                    <option value="1">P1 Critical</option>
                    <option value="2">P2 High</option>
                    <option value="3" selected>P3 Medium</option>
                    <option value="4">P4 Low</option>
                    <option value="5">P5 Minimal</option>
                </select>
                <input type="date" name="due_date" class="win95-input" style="flex:1" placeholder="Due date">
                <button type="submit" class="win95-btn primary">Add</button>
            </form>
        </div>
    ]], list.id))

    -- Delete completed button
    if done > 0 then
        table.insert(parts, string.format([[
            <div style="padding:4px;text-align:right">
                <form method="POST" action="/lists/%d/delete-completed" style="display:inline"
                      onsubmit="return confirm('Delete all completed todos?')">
                    <button type="submit" class="win95-btn danger" style="min-width:auto;padding:2px 8px;font-size:12px">
                        Clear %d completed
                    </button>
                </form>
            </div>
        ]], list.id, done))
    end

    -- Todo list
    table.insert(parts, '<div class="win95-sunken" style="min-height:200px;margin-top:4px">')

    if #todos == 0 then
        table.insert(parts, '<div class="empty-state">No todos yet. Add one above!</div>')
    else
        local today = os.date("%Y-%m-%d")
        for _, todo in ipairs(todos) do
            local completed_class = ""
            if todo.completed == 1 then
                completed_class = " completed"
            end

            -- Priority badge
            local pbadge = string.format(
                '<span class="priority-badge" style="color:%s;border-color:%s">P%d</span>',
                priority_color(todo.priority), priority_color(todo.priority), todo.priority)

            -- Due date
            local due_html = ""
            if todo.due_date then
                local overdue_class = ""
                if todo.due_date < today and todo.completed ~= 1 then
                    overdue_class = " overdue"
                end
                due_html = string.format('<span class="due-date%s">%s</span>', overdue_class, esc(todo.due_date))
            end

            -- Tags
            local tags_html = ""
            local todo_tag_list = todo_tags_map[todo.id]
            if todo_tag_list and #todo_tag_list > 0 then
                local tag_parts = {}
                for _, tg in ipairs(todo_tag_list) do
                    tag_parts[#tag_parts + 1] = string.format('<span class="tag-badge">%s</span>', esc(tg.name))
                end
                tags_html = table.concat(tag_parts)
            end

            -- Tag add form (inline)
            local tag_form = ""
            if #all_tags > 0 then
                local opts = {}
                for _, tg in ipairs(all_tags) do
                    opts[#opts + 1] = string.format('<option value="%d">%s</option>', tg.id, esc(tg.name))
                end
                tag_form = string.format([[
                    <form method="POST" action="/todos/%d/tag" style="display:inline;margin:0">
                        <select name="tag_id" class="win95-select" style="width:auto;font-size:11px;padding:0 2px">
                            %s
                        </select>
                        <button type="submit" class="win95-btn" style="min-width:auto;padding:0 4px;font-size:11px">+tag</button>
                    </form>
                ]], todo.id, table.concat(opts))
            end

            table.insert(parts, string.format([[
                <div class="todo-item%s">
                    <form method="POST" action="/todos/%d/toggle" style="margin:0;display:inline">
                        <input type="checkbox" class="win95-checkbox" %s
                               onchange="this.form.submit()">
                    </form>
                    %s
                    <span class="todo-text">%s</span>
                    %s
                    <div>%s</div>
                    <div>%s</div>
                    <div class="todo-actions">
                        <form method="POST" action="/todos/%d/delete" style="margin:0"
                              onsubmit="return confirm('Delete this todo?')">
                            <button type="submit" class="win95-btn danger" title="Delete">X</button>
                        </form>
                    </div>
                </div>
            ]], completed_class, todo.id,
                todo.completed == 1 and 'checked="checked"' or '',
                pbadge, esc(todo.title),
                due_html, tags_html, tag_form, todo.id))
        end
    end

    table.insert(parts, '</div>')

    local status = string.format("List: %s | %d todo(s), %d done | ORM: from(), where(), orderBy(), orderByNulls(), NullsLast()", list.name, #todos, done)
    return templates.base(esc(list.name), table.concat(parts), status)
end

-- ================================================================
-- Tags page
-- ================================================================
function templates.tags_page(tags, tag_todo_counts)
    tag_todo_counts = tag_todo_counts or {}
    local parts = {}

    table.insert(parts, [[
        <div class="win95-toolbar">
            <form method="POST" action="/tags" style="display:flex;gap:4px;width:100%">
                <input type="text" name="name" class="win95-input" placeholder="New tag name..." required>
                <button type="submit" class="win95-btn primary">Add Tag</button>
            </form>
        </div>
        <p style="font-size:12px;color:#666;padding:4px">
            ORM features: changeset(), validateExclusion(), validateLength(), from(), innerJoin(), orderBy()
        </p>
    ]])

    table.insert(parts, '<div class="win95-sunken" style="min-height:150px;margin-top:4px">')
    if #tags == 0 then
        table.insert(parts, '<div class="empty-state">No tags yet.</div>')
    else
        for _, tag in ipairs(tags) do
            local count = tag_todo_counts[tag.id] or 0
            table.insert(parts, string.format([[
                <div class="list-card">
                    <a href="/tags/%d">
                        <span class="tag-badge" style="font-size:14px">%s</span>
                        <span class="list-meta" style="margin-left:8px">%d todo(s)</span>
                    </a>
                    <form method="POST" action="/tags/%d/delete" style="margin:0"
                          onsubmit="return confirm('Delete tag?')">
                        <button type="submit" class="win95-btn danger" title="Delete">X</button>
                    </form>
                </div>
            ]], tag.id, esc(tag.name), count, tag.id))
        end
    end
    table.insert(parts, '</div>')

    return templates.base("Tags", table.concat(parts), string.format("%d tag(s)", #tags))
end

-- ================================================================
-- Tag detail page (todos with this tag)
-- ================================================================
function templates.tag_detail_page(tag, todos)
    local parts = {}
    table.insert(parts, '<a href="/tags" class="back-link">&laquo; Back to Tags</a>')
    table.insert(parts, string.format('<h3 style="margin:4px 0">Todos tagged: <span class="tag-badge" style="font-size:16px">%s</span></h3>', esc(tag.name)))
    table.insert(parts, '<p style="font-size:12px;color:#666">ORM: from(), innerJoin() (chained), where(), orderBy()</p>')

    table.insert(parts, '<div class="win95-sunken" style="min-height:100px;margin-top:8px">')
    if #todos == 0 then
        table.insert(parts, '<div class="empty-state">No todos with this tag.</div>')
    else
        for _, todo in ipairs(todos) do
            local pbadge = string.format('<span class="priority-badge" style="color:%s;border-color:%s">P%d</span>',
                priority_color(todo.priority), priority_color(todo.priority), todo.priority)
            local check = todo.completed == 1 and "[x]" or "[ ]"
            table.insert(parts, string.format([[
                <div class="todo-item%s">
                    <span>%s</span> %s <span class="todo-text">%s</span>
                </div>
            ]], todo.completed == 1 and " completed" or "", check, pbadge, esc(todo.title)))
        end
    end
    table.insert(parts, '</div>')

    return templates.base("Tag: " .. tag.name, table.concat(parts),
        string.format("Tag: %s | %d todo(s)", tag.name, #todos))
end

-- ================================================================
-- Search page
-- ================================================================
function templates.search_page(query, results, overdue, no_due_date, high_priority, with_tags)
    local parts = {}

    -- Search form
    table.insert(parts, [[
        <div class="win95-toolbar">
            <form method="GET" action="/search" style="display:flex;gap:4px;width:100%">
                <input type="text" name="q" class="win95-input" placeholder="Search todos..." value="]] .. esc(query or "") .. [[">
                <button type="submit" class="win95-btn primary">Search</button>
            </form>
        </div>
        <p style="font-size:12px;color:#666;padding:4px">
            ORM: whereLike(), whereNot(), whereNotNull(), whereBetween(), whereNull(), EXISTS subquery, NullsLast(), offset()
        </p>
    ]])

    -- Search results
    if query and query ~= "" then
        table.insert(parts, string.format('<div class="feature-label">Search: "%s" (whereLike)</div>', esc(query)))
        table.insert(parts, '<div class="win95-sunken" style="max-height:150px;overflow-y:auto;margin-bottom:8px">')
        if #results == 0 then
            table.insert(parts, '<div class="empty-state">No results.</div>')
        else
            for _, r in ipairs(results) do
                table.insert(parts, string.format('<div class="todo-item"><span class="priority-badge" style="color:%s;border-color:%s">P%d</span><span class="todo-text">%s</span></div>',
                    priority_color(r.priority), priority_color(r.priority), r.priority, esc(r.title)))
            end
        end
        table.insert(parts, '</div>')
    end

    -- Overdue todos
    table.insert(parts, '<div class="feature-label">Overdue Todos (whereNotNull + where + whereNot)</div>')
    table.insert(parts, '<div class="win95-sunken" style="max-height:120px;overflow-y:auto;margin-bottom:8px">')
    if #overdue == 0 then
        table.insert(parts, '<div class="empty-state">No overdue todos.</div>')
    else
        for _, r in ipairs(overdue) do
            table.insert(parts, string.format('<div class="todo-item"><span class="due-date overdue">%s</span> <span class="todo-text">%s</span></div>',
                esc(r.due_date), esc(r.title)))
        end
    end
    table.insert(parts, '</div>')

    -- No due date
    table.insert(parts, '<div class="feature-label">Todos Without Due Date (whereNull)</div>')
    table.insert(parts, '<div class="win95-sunken" style="max-height:120px;overflow-y:auto;margin-bottom:8px">')
    if #no_due_date == 0 then
        table.insert(parts, '<div class="empty-state">All todos have due dates.</div>')
    else
        for _, r in ipairs(no_due_date) do
            table.insert(parts, string.format('<div class="todo-item"><span class="todo-text">%s</span></div>', esc(r.title)))
        end
    end
    table.insert(parts, '</div>')

    -- High priority
    table.insert(parts, '<div class="feature-label">High Priority Incomplete (whereNot + whereBetween + offset)</div>')
    table.insert(parts, '<div class="win95-sunken" style="max-height:120px;overflow-y:auto;margin-bottom:8px">')
    if #high_priority == 0 then
        table.insert(parts, '<div class="empty-state">No high priority incomplete todos.</div>')
    else
        for _, r in ipairs(high_priority) do
            table.insert(parts, string.format('<div class="todo-item"><span class="priority-badge" style="color:%s;border-color:%s">P%d</span><span class="todo-text">%s</span></div>',
                priority_color(r.priority), priority_color(r.priority), r.priority, esc(r.title)))
        end
    end
    table.insert(parts, '</div>')

    -- Todos with tags (EXISTS)
    table.insert(parts, '<div class="feature-label">Todos With Tags (EXISTS subquery)</div>')
    table.insert(parts, '<div class="win95-sunken" style="max-height:120px;overflow-y:auto">')
    if #with_tags == 0 then
        table.insert(parts, '<div class="empty-state">No tagged todos.</div>')
    else
        for _, r in ipairs(with_tags) do
            table.insert(parts, string.format('<div class="todo-item"><span class="todo-text">%s</span></div>', esc(r.title)))
        end
    end
    table.insert(parts, '</div>')

    return templates.base("Search & Filter", table.concat(parts), "ORM: whereLike, whereNull, whereNotNull, whereNot, whereBetween, EXISTS")
end

-- ================================================================
-- Analytics page
-- ================================================================
function templates.analytics_page(stats, count_per_list, lists_with_min, union_demo, intersect_demo, except_demo, distinct_prios, completed_or_urgent)
    local parts = {}

    -- Priority stats
    table.insert(parts, '<div class="feature-label">Priority Statistics (countCol, sumCol, avgCol, minCol, maxCol)</div>')
    table.insert(parts, '<div style="display:flex;flex-wrap:wrap;margin-bottom:8px">')
    table.insert(parts, string.format('<div class="stat-box"><div class="stat-value">%s</div><div class="stat-label">COUNT</div></div>', stats.count))
    table.insert(parts, string.format('<div class="stat-box"><div class="stat-value">%s</div><div class="stat-label">SUM</div></div>', stats.sum))
    table.insert(parts, string.format('<div class="stat-box"><div class="stat-value">%.1f</div><div class="stat-label">AVG</div></div>', stats.avg))
    table.insert(parts, string.format('<div class="stat-box"><div class="stat-value">%s</div><div class="stat-label">MIN</div></div>', stats.min))
    table.insert(parts, string.format('<div class="stat-box"><div class="stat-value">%s</div><div class="stat-label">MAX</div></div>', stats.max))
    table.insert(parts, '</div>')

    -- Count per list
    table.insert(parts, '<div class="feature-label">Todos Per List (selectExpr + countAll + groupBy)</div>')
    table.insert(parts, '<div class="win95-sunken" style="margin-bottom:8px;max-height:80px">')
    for list_id, cnt in pairs(count_per_list) do
        table.insert(parts, string.format('<div class="todo-item">List #%d: %d todo(s)</div>', list_id, cnt))
    end
    table.insert(parts, '</div>')

    -- Lists with min todos (HAVING)
    table.insert(parts, '<div class="feature-label">Lists With 3+ Todos (groupBy + having)</div>')
    table.insert(parts, '<div class="win95-sunken" style="margin-bottom:8px;max-height:80px">')
    if #lists_with_min == 0 then
        table.insert(parts, '<div class="empty-state">None meet threshold.</div>')
    else
        for _, r in ipairs(lists_with_min) do
            table.insert(parts, string.format('<div class="todo-item">List #%d: %d todo(s)</div>', r.list_id, r.count))
        end
    end
    table.insert(parts, '</div>')

    -- Distinct priorities
    table.insert(parts, '<div class="feature-label">Distinct Priorities In Use (distinct + select)</div>')
    table.insert(parts, '<div style="margin-bottom:8px">')
    for _, p in ipairs(distinct_prios) do
        table.insert(parts, string.format('<span class="priority-badge" style="color:%s;border-color:%s">P%d %s</span>',
            priority_color(p), priority_color(p), p, priority_label(p)))
    end
    table.insert(parts, '</div>')

    -- Completed or urgent (OR WHERE)
    table.insert(parts, '<div class="feature-label">Completed OR Urgent (where + orWhere)</div>')
    table.insert(parts, '<div class="win95-sunken" style="margin-bottom:8px;max-height:100px;overflow-y:auto">')
    for _, r in ipairs(completed_or_urgent) do
        local check = r.completed == 1 and "[x]" or "[ ]"
        table.insert(parts, string.format('<div class="todo-item">%s <span class="priority-badge" style="color:%s;border-color:%s">P%d</span> %s</div>',
            check, priority_color(r.priority), priority_color(r.priority), r.priority, esc(r.title)))
    end
    table.insert(parts, '</div>')

    -- Set operations
    table.insert(parts, '<div class="feature-label">INTERSECT: P1 AND Completed (intersectSql)</div>')
    table.insert(parts, '<div class="win95-sunken" style="margin-bottom:8px;max-height:80px">')
    if #intersect_demo == 0 then
        table.insert(parts, '<div class="empty-state">No matching rows.</div>')
    else
        for _, r in ipairs(intersect_demo) do
            table.insert(parts, string.format('<div class="todo-item">%s</div>', esc(r.title)))
        end
    end
    table.insert(parts, '</div>')

    table.insert(parts, '<div class="feature-label">EXCEPT: P1 Minus Completed (exceptSql)</div>')
    table.insert(parts, '<div class="win95-sunken" style="margin-bottom:8px;max-height:80px">')
    if #except_demo == 0 then
        table.insert(parts, '<div class="empty-state">No rows remain after EXCEPT.</div>')
    else
        for _, r in ipairs(except_demo) do
            table.insert(parts, string.format('<div class="todo-item">%s</div>', esc(r.title)))
        end
    end
    table.insert(parts, '</div>')

    return templates.base("Analytics", table.concat(parts),
        "ORM: countAll, countCol, sumCol, avgCol, minCol, maxCol, groupBy, having, distinct, unionSql, intersectSql, exceptSql")
end

-- ================================================================
-- SQL Showcase page
-- ================================================================
function templates.sql_showcase_page(sqls)
    local parts = {}

    table.insert(parts, [[<p style="font-size:13px;margin-bottom:8px">
        Every SQL query below was generated entirely by the Alloy ORM.
        This page demonstrates all 40+ ORM features.
    </p>]])

    -- Ordered list of all features
    local features = {
        { "basic_select",       "1. Basic SELECT",                          "from()" },
        { "select_cols",        "2. SELECT Specific Columns",               "select()" },
        { "where",              "3. WHERE",                                 "where()" },
        { "or_where",           "4. OR WHERE",                              "orWhere()" },
        { "where_null",         "5. WHERE NULL",                            "whereNull()" },
        { "where_not_null",     "6. WHERE NOT NULL",                        "whereNotNull()" },
        { "where_in",           "7. WHERE IN",                              "whereIn()" },
        { "where_in_subquery",  "8. WHERE IN (subquery)",                   "whereInSubquery()" },
        { "where_not",          "9. WHERE NOT",                             "whereNot()" },
        { "where_between",      "10. WHERE BETWEEN",                        "whereBetween()" },
        { "where_like",         "11. WHERE LIKE",                           "whereLike()" },
        { "where_ilike",        "12. WHERE ILIKE",                          "whereILike()" },
        { "distinct",           "13. SELECT DISTINCT",                      "distinct()" },
        { "order_nulls_first",  "14a. ORDER BY ... NULLS FIRST",           "orderByNulls() + NullsFirst()" },
        { "order_nulls_last",   "14b. ORDER BY ... NULLS LAST",            "orderByNulls() + NullsLast()" },
        { "limit_offset",       "15. LIMIT + OFFSET",                       "limit() + offset()" },
        { "inner_join",         "16. INNER JOIN",                           "innerJoin()" },
        { "left_join",          "17. LEFT JOIN",                            "leftJoin()" },
        { "right_join",         "18. RIGHT JOIN",                           "rightJoin()" },
        { "full_join",          "19. FULL JOIN",                            "fullJoin()" },
        { "cross_join",         "20. CROSS JOIN",                           "crossJoin()" },
        { "group_having",       "21. GROUP BY + HAVING",                    "groupBy() + having()" },
        { "group_or_having",    "22. GROUP BY + HAVING + OR HAVING",        "having() + orHaving()" },
        { "count_sql",          "23. COUNT query",                          "countSql()" },
        { "safe_sql",           "24. Safe SQL (default limit)",             "safeToSql()" },
        { "count_all",          "25a. COUNT(*)",                            "countAll()" },
        { "count_col",          "25b. COUNT(col)",                          "countCol()" },
        { "sum_col",            "25c. SUM(col)",                            "sumCol()" },
        { "avg_col",            "25d. AVG(col)",                            "avgCol()" },
        { "min_col",            "25e. MIN(col)",                            "minCol()" },
        { "max_col",            "25f. MAX(col)",                            "maxCol()" },
        { "col_ref",            "26. Qualified Column (table.col)",         "col()" },
        { "for_update",         "27a. FOR UPDATE lock",                     "lock() + ForUpdate()" },
        { "for_share",          "27b. FOR SHARE lock",                      "lock() + ForShare()" },
        { "update_query",       "28. UPDATE query",                         "update() + set() + where()" },
        { "delete_query",       "29. DELETE query (deleteFrom)",            "deleteFrom() + where() + limit()" },
        { "delete_sql",         "30. Quick DELETE by ID",                   "deleteSql()" },
        { "union_sql",          "31a. UNION",                               "unionSql()" },
        { "union_all_sql",      "31b. UNION ALL",                           "unionAllSql()" },
        { "intersect_sql",      "31c. INTERSECT",                           "intersectSql()" },
        { "except_sql",         "31d. EXCEPT",                              "exceptSql()" },
        { "subquery_sql",       "32. Subquery (derived table)",             "subquery()" },
        { "exists_sql",         "33. EXISTS",                               "existsSql()" },
        { "changeset_insert",   "34. Changeset INSERT",                     "changeset() + toInsertSql()" },
        { "changeset_update",   "35. Changeset UPDATE",                     "changeset() + toUpdateSql()" },
        { "multi_agg",          "36. Multiple Aggregates",                  "selectExpr() + multiple aggs" },
        { "update_or_where",    "37. UPDATE with OR WHERE",                 "update() + orWhere()" },
        { "delete_or_where",    "38. DELETE with OR WHERE",                 "deleteFrom() + orWhere()" },
        { "update_limit",       "39. UPDATE with LIMIT",                    "update() + limit()" },
        { "delete_limit",       "40. DELETE with LIMIT",                    "deleteFrom() + limit()" },
        { "manual_builder",     "41. SqlBuilder Manual Types",              "SqlBuilder + SqlString + SqlInt32 + SqlFloat64 + SqlBoolean" },
    }

    for _, feat in ipairs(features) do
        local key, label, api = feat[1], feat[2], feat[3]
        local sql_val = sqls[key] or "(N/A)"
        table.insert(parts, string.format([[
            <div class="feature-label">%s <span style="font-weight:normal;color:#666">- %s</span></div>
            <div class="sql-block">%s</div>
        ]], esc(label), esc(api), esc(sql_val)))
    end

    return templates.base("SQL Lab - All ORM Features", table.concat(parts),
        string.format("%d SQL features demonstrated", #features))
end

-- ================================================================
-- Validations demo page
-- ================================================================
function templates.validations_page(results)
    local parts = {}

    table.insert(parts, [[
        <p style="font-size:13px;margin-bottom:8px">
            All changeset validation methods demonstrated below.
            Each validates data against type and business rules before SQL generation.
        </p>
    ]])

    for _, r in ipairs(results) do
        local css_class = r.valid and "validation-pass" or "validation-fail"
        local icon = r.valid and "PASS" or "FAIL"
        table.insert(parts, string.format([[
            <div class="validation-result %s">
                <strong>[%s]</strong> %s
                <span style="color:#666;font-size:12px"> - %s</span>
            </div>
        ]], css_class, icon, esc(r.label), esc(r.api)))
    end

    return templates.base("Changeset Validations", table.concat(parts),
        "ORM: cast, validateRequired, validateLength, validateInt, validateInt64, validateFloat, validateBool, validateNumber, validateInclusion, validateExclusion, validateAcceptance, validateConfirmation, validateContains, validateStartsWith, validateEndsWith, putChange, getChange, deleteChange")
end

return templates
