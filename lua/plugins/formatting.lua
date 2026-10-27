return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "clang-format", "ruff", "debugpy", "codelldb" } },
    config = function(_, opts)
      require("mason").setup(opts)
      local registry = require("mason-registry")
      registry:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      registry.refresh(function()
        for _, tool in ipairs(opts.ensure_installed or {}) do
          local package = registry.get_package(tool)
          -- LSP and DAP integrations may already have started this install.
          if not package:is_installed() and not package:is_installing() then
            package:install()
          end
        end
      end)
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "c_formatter_42" },
        cpp = { "clang_format" },
        python = { "ruff_organize_imports", "ruff_format" },
        cmake = { "cmake_format" },
      },
      formatters = {
        c_formatter_42 = {
          command = function()
            return require("config.fortytwo").tool("c_formatter_42") or "c_formatter_42"
          end,
          stdin = true,
        },
      },
    },
  },
}
