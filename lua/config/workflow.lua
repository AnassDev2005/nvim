local M = {}

function M.root(file)
  return vim.fs.root(file or vim.api.nvim_buf_get_name(0), {
    "pyproject.toml",
    "pytest.ini",
    "requirements.txt",
    ".venv",
    "venv",
    "Makefile",
    ".git",
  }) or vim.fn.getcwd()
end

function M.python(file)
  local selector = package.loaded["venv-selector"]
  local selected = selector and selector.python()
  if selected then
    return selected
  end
  if vim.env.VIRTUAL_ENV and vim.fn.executable(vim.env.VIRTUAL_ENV .. "/bin/python") == 1 then
    return vim.env.VIRTUAL_ENV .. "/bin/python"
  end
  local root = M.root(file)
  for _, name in ipairs({ ".venv", "venv" }) do
    local python = root .. "/" .. name .. "/bin/python"
    if vim.fn.executable(python) == 1 then
      return python
    end
  end
  return vim.fn.exepath("python3")
end

function M.run_python()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return vim.notify("Save the Python file first", vim.log.levels.WARN)
  end
  vim.cmd("write")
  Snacks.terminal({ M.python(file), file }, { cwd = M.root(file) })
end

function M.run_executable()
  local cwd = vim.fn.getcwd()
  vim.ui.input({ prompt = "Executable path: ", default = cwd .. "/", completion = "file" }, function(path)
    if path and path ~= "" then
      path = vim.fn.fnamemodify(path, ":p")
      if vim.fn.executable(path) ~= 1 then
        return vim.notify("Not an executable: " .. path, vim.log.levels.ERROR)
      end
      Snacks.terminal({ path }, { cwd = cwd })
    end
  end)
end

function M.make(run)
  -- Use project build rules and Neovim's quickfix error parsing.
  vim.cmd("wall")
  -- Avoid tee masking the build exit status in shells without pipefail.
  local shellpipe = vim.o.shellpipe
  vim.o.shellpipe = ">%s 2>&1"
  local ok, err = pcall(vim.cmd, "make")
  local status = vim.v.shell_error
  vim.o.shellpipe = shellpipe
  if not ok then
    return vim.notify(tostring(err), vim.log.levels.ERROR)
  end
  if status ~= 0 then
    vim.cmd("copen")
  elseif run then
    M.run_executable()
  end
end

return M
