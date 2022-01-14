local M = {}

M.merge = function(t1, t2)
    for k, v in pairs(t2) do
        t1[k] = v
    end
    return t1
end

M.concat = function(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end

M.map = function(modes, key, result, options)
    options = M.merge({
        noremap = true,
        silent = false,
        expr = false,
        nowait = false,
    }, options or {})
    if type(modes) ~= "table" then
        modes = { modes }
    end

    for i = 1, #modes do
        vim.api.nvim_set_keymap(modes[i], key, result, options)
    end
end

M.bmap = function(buf, modes, key, result, options)
    options = M.merge({
        noremap = true,
        silent = false,
        expr = false,
        nowait = false,
    }, options or {})
    if type(modes) ~= "table" then
        modes = { modes }
    end

    for i = 1, #modes do
        vim.api.nvim_buf_set_keymap(buf, modes[i], key, result, options)
    end
end

M.grep = function()
    local t_builtin = require("telescope.builtin")
    local t_config = require("telescope.config")

    vim.ui.input({ prompt = "Input: ", default = vim.fn.expand("<cword>") }, function(search)
        search = vim.trim(search or "")
        if search == "" then
            return
        end
        vim.ui.input({ prompt = "Dir: ", default = "./", completion = "dir" }, function(dir)
            dir = vim.trim(dir or "")
            if dir == "" then
                return
            end

            vim.ui.input({ prompt = "File pattern: ", default = "*" }, function(pattern)
                pattern = vim.trim(pattern or "")
                if pattern == "" then
                    return
                end

                local args = require("telescope.config").values.vimgrep_arguments
                if pattern ~= "*" then
                    args = M.concat(args, { "-g", pattern })
                end

                require("telescope.builtin").grep_string({
                    search = search,
                    search_dirs = { dir },
                    vimgrep_arguments = args,
                })
            end)
        end)
    end)
end

M.node_at_cursor = function()
    local ts_utils = require("nvim-treesitter.ts_utils")
    local expr = ts_utils.get_node_at_cursor()

    local func
    local class

    while expr do
        if expr:type() == "function_definition" then
            func = (ts_utils.get_node_text(expr:child(1)))[1]
        end
        if expr:type() == "class_definition" then
            class = (ts_utils.get_node_text(expr:child(1)))[1]
        end
        expr = expr:parent()
    end

    return {
        func = func,
        class = class,
    }
end

M.find_cmd = function(cmd, prefixes, start_from, stop_at)
    local path = require("lspconfig/util").path

    if type(prefixes) == "string" then
        prefixes = { prefixes }
    end

    local found
    for _, prefix in ipairs(prefixes) do
        local full_cmd = prefix and path.join(prefix, cmd) or cmd
        local possibility

        -- if start_from is a dir, test it first since transverse will start from its parent
        if start_from and path.is_dir(start_from) then
            possibility = path.join(start_from, full_cmd)
            if vim.fn.executable(possibility) > 0 then
                found = possibility
                break
            end
        end

        path.traverse_parents(start_from, function(dir)
            possibility = path.join(dir, full_cmd)
            if vim.fn.executable(possibility) > 0 then
                found = possibility
                return true
            end
            -- use cwd as a stopping point to avoid scanning the entire file system
            if stop_at and dir == stop_at then
                return true
            end
        end)

        if found ~= nil then
            break
        end
    end

    return found or cmd
end

M.toggle_qf = function()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            qf_exists = true
        end
    end
   if qf_exists == true then
        vim.cmd("cclose")
        return
    end
    if not vim.tbl_isempty(vim.fn.getqflist()) then
        vim.cmd("copen")
    end
end

-- From ibhagwan
---API for key mapping.
---
---@param lhs string
---@param modes string|table
---@param rhs string|function
---@param opts string|table
--- opts.buffer: current buffer only
--- opts.cmd: command (format to <cmd>%s<cr>)
M.remap = function(modes, lhs, rhs, opts)
  modes = type(modes) == "string" and { modes } or modes
  opts = opts or {}
  opts = type(opts) == "string" and { opts } or opts

  local fallback = function()
    return vim.api.nvim_feedkeys(M.t(lhs), "n", true)
  end

  local _rhs = (function()
    if type(rhs) == "function" then
      opts.noremap = true
      opts.cmd = true
      return func2str(function()
        rhs(fallback)
      end)
    else
      return rhs
    end
  end)()

  for key, opt in ipairs(opts) do
    opts[opt] = true
    opts[key] = nil
  end

  local buffer = (function()
    if opts.buffer then
      opts.buffer = nil
      return true
    end
  end)()

  _rhs = (function()
    if opts.cmd then
      opts.cmd = nil
      return ("<cmd>%s<cr>"):format(_rhs)
    else
      return _rhs
    end
  end)()

  for _, mode in ipairs(modes) do
    if buffer then
      vim.api.nvim_buf_set_keymap(0, mode, lhs, _rhs, opts)
    else
      vim.api.nvim_set_keymap(mode, lhs, _rhs, opts)
    end
  end
end

-- mjlbach/nvim-lspconfig

local vim = vim
local validate = vim.validate
local api = vim.api
local lsp = vim.lsp
local uv = vim.loop
local fn = vim.fn
-- -- Some path utilities
M.path = (function()
  local function exists(filename)
    local stat = uv.fs_stat(filename)
    return stat and stat.type or false
  end

  local function is_dir(filename)
    return exists(filename) == 'directory'
  end

  local function is_file(filename)
    return exists(filename) == 'file'
  end

  local is_windows = uv.os_uname().version:match("Windows")
  local path_sep = is_windows and "\\" or "/"

  local is_fs_root
  if is_windows then
    is_fs_root = function(path)
      return path:match("^%a:$")
    end
  else
    is_fs_root = function(path)
      return path == "/"
    end
  end

  local function is_absolute(filename)
    if is_windows then
      return filename:match("^%a:") or filename:match("^\\\\")
    else
      return filename:match("^/")
    end
  end

  local dirname
  do
    local strip_dir_pat = path_sep.."([^"..path_sep.."]+)$"
    local strip_sep_pat = path_sep.."$"
    dirname = function(path)
      if not path then return end
      local result = path:gsub(strip_sep_pat, ""):gsub(strip_dir_pat, "")
      if #result == 0 then
        return "/"
      end
      return result
    end
  end

  local function path_join(...)
    local result =
      table.concat(
        vim.tbl_flatten {...}, path_sep):gsub(path_sep.."+", path_sep)
    return result
  end

  -- Traverse the path calling cb along the way.
  local function traverse_parents(path, cb)
    path = uv.fs_realpath(path)
    local dir = path
    -- Just in case our algo is buggy, don't infinite loop.
    for _ = 1, 100 do
      dir = dirname(dir)
      if not dir then return end
      -- If we can't ascend further, then stop looking.
      if cb(dir, path) then
        return dir, path
      end
      if is_fs_root(dir) then
        break
      end
    end
  end

  -- Iterate the path until we find the rootdir.
  local function iterate_parents(path)
    path = uv.fs_realpath(path)
    local function it(s, v)
      if not v then return end
      if is_fs_root(v) then return end
      return dirname(v), path
    end
    return it, path, path
  end

  local function is_descendant(root, path)
    if (not path) then
      return false;
    end

    local function cb(dir, _)
      return dir == root;
    end

    local dir, _ = traverse_parents(path, cb);

    return dir == root;
  end

  return {
    is_dir = is_dir;
    is_file = is_file;
    is_absolute = is_absolute;
    exists = exists;
    sep = path_sep;
    dirname = dirname;
    join = path_join;
    traverse_parents = traverse_parents;
    iterate_parents = iterate_parents;
    is_descendant = is_descendant;
  }
end)()
function M.search_ancestors(startpath, func)
  validate { func = {func, 'f'} }
  if func(startpath) then return startpath end
  for path in M.path.iterate_parents(startpath) do
    if func(path) then return path end
  end
end

function M.root_pattern(...)
  local patterns = vim.tbl_flatten {...}
  local function matcher(path)
    for _, pattern in ipairs(patterns) do
      if M.path.exists(vim.fn.glob(M.path.join(path, pattern))) then
        return path
      end
    end
  end
  return function(startpath)
    return M.search_ancestors(startpath, matcher)
  end
end
return M
