return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          root_markers = {
            "compile_commands.json",
            "compile_flags.txt",
            ".clangd",
            "CMakeLists.txt",
            "Makefile",
            ".git",
          },
          keys = {
            {
              "<leader>cb",
              function()
                require("config.workflow").make(false)
              end,
              desc = "Build Project (:make)",
              ft = "c",
            },
            {
              "<leader>cx",
              function()
                require("config.workflow").run_executable()
              end,
              desc = "Run Executable",
              ft = "c",
            },
            {
              "<leader>cB",
              function()
                require("config.workflow").make(true)
              end,
              desc = "Build and Run (:make)",
              ft = "c",
            },
          },
        },
      },
    },
  },
  {
    "Civitasv/cmake-tools.nvim",
    cmd = {
      "CMakeGenerate",
      "CMakeBuild",
      "CMakeRun",
      "CMakeDebug",
      "CMakeSelectBuildType",
      "CMakeSelectBuildTarget",
      "CMakeSelectLaunchTarget",
      "CMakeSelectConfigurePreset",
      "CMakeSelectBuildPreset",
      "CMakeSelectCwd",
      "CMakeSelectBuildDir",
      "CMakeRunTest",
    },
    opts = {
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" },
      cmake_regenerate_on_save = false,
      cmake_compile_commands_options = { action = "lsp" },
      cmake_dap_configuration = { type = "codelldb", request = "launch", name = "CMake Debug", stopOnEntry = false },
    },
    keys = {
      { "<leader>cMg", "<cmd>wall<cr><cmd>CMakeGenerate<cr>", desc = "CMake Configure" },
      { "<leader>cMb", "<cmd>wall<cr><cmd>CMakeBuild<cr>", desc = "CMake Build" },
      { "<leader>cMr", "<cmd>wall<cr><cmd>CMakeRun<cr>", desc = "CMake Build and Run" },
      {
        "<leader>cMd",
        function()
          vim.cmd("wall")
          require("lazy").load({ plugins = { "nvim-dap" } })
          vim.cmd("CMakeDebug")
        end,
        desc = "CMake Debug",
      },
      { "<leader>cMt", "<cmd>CMakeSelectLaunchTarget<cr>", desc = "CMake Launch Target" },
      { "<leader>cMv", "<cmd>CMakeSelectBuildType<cr>", desc = "CMake Build Type" },
    },
  },
}
