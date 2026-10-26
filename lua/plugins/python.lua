return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          before_init = function(params, config)
            config.settings = config.settings or {}
            config.settings.python = config.settings.python or {}
            local root = params.rootUri and vim.uri_to_fname(params.rootUri) or vim.fn.getcwd()
            config.settings.python.pythonPath = require("config.workflow").python(root)
          end,
          settings = { python = { analysis = { typeCheckingMode = "basic", diagnosticMode = "openFiles" } } },
          keys = {
            {
              "<leader>cx",
              function()
                require("config.workflow").run_python()
              end,
              desc = "Run Python File",
              ft = "python",
            },
          },
        },
      },
    },
  },
  {
    "nvim-neotest/neotest",
    opts = { adapters = { ["neotest-python"] = { runner = "pytest" } } },
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      require("dap-python").resolve_python = function()
        return require("config.workflow").python()
      end
    end,
    keys = {
      {
        "<leader>dPp",
        function()
          local file = vim.api.nvim_buf_get_name(0)
          if file == "" then
            return vim.notify("Save the Python file first", vim.log.levels.WARN)
          end
          vim.cmd("write")
          local workflow = require("config.workflow")
          require("dap").run({
            type = "python",
            request = "launch",
            name = "Debug Current Python File",
            program = file,
            cwd = workflow.root(file),
            pythonPath = workflow.python(file),
            console = "integratedTerminal",
            justMyCode = true,
          })
        end,
        desc = "Debug Python File",
        ft = "python",
      },
    },
  },
}
