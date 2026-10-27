local M = {}
local namespace = vim.api.nvim_create_namespace("fortytwo_norm")
local checks = {}
local border = "/* ************************************************************************** */"

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "42 tools" })
end

local function is_c(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  return vim.bo[buf].filetype == "c" and name:match("%.[ch]$") ~= nil
end

function M.tool(name)
  local directory = vim.g.fortytwo_tools_dir or (vim.fn.stdpath("data") .. "/42-tools")
  local bundled = directory .. "/bin/" .. name
  if vim.fn.executable(bundled) == 1 then
    return bundled
  end
  local external = vim.fn.exepath(name)
  return external ~= "" and external or nil
end

local function has_header(lines)
  return lines[1] == border
    and lines[11] == border
    and lines[3]:find(":::      ::::::::", 1, true) ~= nil
end

local function row(left, suffix)
  local width = 80 - 5 - #suffix
  left = left:sub(1, width - 1)
  return "/*   " .. left .. string.rep(" ", width - #left) .. suffix
end

function M.header(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  if not is_c(buf) or not vim.bo[buf].modifiable then
    notify("Open a named C source or header (.c/.h) first.", vim.log.levels.WARN)
    return false
  end
  local old = vim.api.nvim_buf_get_lines(buf, 0, 12, false)
  local existing = has_header(old)
  local login = vim.g.user42 or vim.env.USER42 or "anes-sal"
  local email = vim.g.mail42 or vim.env.MAIL42 or "marvin@42.fr"
  local timestamp = os.date("%Y/%m/%d %H:%M:%S")
  local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
  local header = {
    border,
    "/*                                                                            */",
    "/*                                                        :::      ::::::::   */",
    row(name, ":+:      :+:    :+:   */"),
    "/*                                                    +:+ +:+         +:+     */",
    row("By: " .. login .. " <" .. email .. ">", "+#+  +:+       +#+        */"),
    "/*                                                +#+#+#+#+#+   +#+           */",
    row("Created: " .. timestamp .. " by " .. login, "#+#    #+#             */"),
    row("Updated: " .. timestamp .. " by " .. login, "###   ########.fr       */"),
    "/*                                                                            */",
    border,
  }
  if existing then
    header[6], header[8] = old[6], old[8]
  end
  local replaced = existing and 11 or 0
  if old[replaced + 1] ~= "" then
    header[#header + 1] = ""
  end
  if not vim.deep_equal(vim.list_slice(old, 1, replaced), header) then
    vim.api.nvim_buf_set_lines(buf, 0, replaced, false, header)
  end
  return true
end

function M.check(buf, opts)
  buf = buf or vim.api.nvim_get_current_buf()
  opts = opts or {}
  if not is_c(buf) then
    notify("Norminette checks C sources and headers (.c/.h).", vim.log.levels.WARN)
    return
  end
  local command = M.tool("norminette")
  if not command then
    notify("Run bash " .. vim.fn.stdpath("config") .. "/scripts/setup-42-tools.sh", vim.log.levels.ERROR)
    return
  end
  local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
  local directory = vim.fn.tempname()
  vim.fn.mkdir(directory, "p")
  local temporary = directory .. "/" .. name
  vim.fn.writefile(vim.api.nvim_buf_get_lines(buf, 0, -1, false), temporary)
  local tick = vim.api.nvim_buf_get_changedtick(buf)
  checks[buf] = (checks[buf] or 0) + 1
  local serial = checks[buf]
  return vim.system({ command, "--no-colors", "--format", "json", temporary }, { text = true }, function(result)
    vim.schedule(function()
      vim.fn.delete(directory, "rf")
      if not vim.api.nvim_buf_is_valid(buf) or checks[buf] ~= serial or vim.api.nvim_buf_get_changedtick(buf) ~= tick then
        return
      end
      local ok, data = pcall(vim.json.decode, result.stdout or "")
      if not ok or type(data) ~= "table" or type(data.files) ~= "table" or (result.code ~= 0 and result.code ~= 1) then
        notify("Norminette failed: " .. (result.stderr or result.stdout or "unknown error"), vim.log.levels.ERROR)
        return
      end
      local diagnostics, items = {}, {}
      local count = vim.api.nvim_buf_line_count(buf)
      for _, file in ipairs(data.files) do
        for _, issue in ipairs(file.errors or {}) do
          local location = (issue.highlights or {})[1] or {}
          local row_number = type(location.lineno) == "number" and location.lineno or 1
          local col_number = type(location.column) == "number" and location.column or 1
          local length = type(location.length) == "number" and location.length or 1
          local line = math.min(count - 1, math.max(0, row_number - 1))
          local text = vim.api.nvim_buf_get_lines(buf, line, line + 1, false)[1] or ""
          local column = math.min(#text, math.max(0, col_number - 1))
          local message = issue.name .. ": " .. issue.text
          diagnostics[#diagnostics + 1] = {
            lnum = line,
            col = column,
            end_col = math.min(#text, column + length),
            severity = vim.diagnostic.severity.ERROR,
            source = "norminette",
            message = message,
          }
          items[#items + 1] = { bufnr = buf, lnum = line + 1, col = column + 1, text = message, type = "E" }
        end
      end
      vim.diagnostic.set(namespace, buf, diagnostics)
      if #items > 0 then
        if opts.open ~= false and vim.api.nvim_get_current_buf() == buf then
          vim.fn.setqflist({}, " ", { title = "42 Norm: " .. name, items = items, context = { fortytwo_bufnr = buf } })
          vim.cmd("copen")
        end
        notify(name .. ": " .. #items .. " Norm issue(s) remain. Some need code changes.", vim.log.levels.WARN)
      else
        local context = vim.fn.getqflist({ context = 0 }).context
        if type(context) == "table" and context.fortytwo_bufnr == buf then
          vim.fn.setqflist({}, "r", { title = "42 Norm: " .. name, items = {}, context = context })
          vim.cmd("cclose")
        end
        notify(name .. ": Norminette OK.")
      end
    end)
  end)
end

function M.format()
  local buf = vim.api.nvim_get_current_buf()
  if not is_c(buf) or not vim.bo[buf].modifiable then
    notify("F2 formats named C sources and headers (.c/.h).", vim.log.levels.WARN)
    return
  end
  if not M.tool("c_formatter_42") then
    notify("Run bash " .. vim.fn.stdpath("config") .. "/scripts/setup-42-tools.sh", vim.log.levels.ERROR)
    return
  end
  require("conform").format({
    bufnr = buf,
    formatters = { "c_formatter_42" },
    lsp_format = "never",
    async = false,
    timeout_ms = 5000,
  }, function(err, edited)
    if err then
      notify("42 formatting failed: " .. err, vim.log.levels.ERROR)
      return
    end
    if edited then
      vim.api.nvim_buf_call(buf, function()
        pcall(vim.cmd, "undojoin")
      end)
    end
    M.header(buf)
    M.check(buf)
  end)
end

function M.setup()
  vim.keymap.set({ "n", "i" }, "<F2>", M.format, { desc = "42 Format, Header, and Norm Check" })
  vim.api.nvim_create_user_command("Header42", function() M.header() end, { desc = "Add or update the 42 header" })
  vim.api.nvim_create_user_command("Norm42", function() M.check() end, { desc = "Check the current C buffer with Norminette" })
  local group = vim.api.nvim_create_augroup("fortytwo_header", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    pattern = { "*.c", "*.h" },
    callback = function(event)
      if is_c(event.buf) and has_header(vim.api.nvim_buf_get_lines(event.buf, 0, 11, false)) then
        M.header(event.buf)
      end
    end,
  })
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    callback = function(event) checks[event.buf] = nil end,
  })
end

return M
