# Anass's Neovim config

My [LazyVim](https://www.lazyvim.org/) setup for C, C++, CMake, and Python,
with a dark Gruvbox theme, completion, formatting, debugging, and Python tests.

## Install with one command

On Linux or macOS, with the requirements below already installed, run:

```sh
curl -fsSL https://raw.githubusercontent.com/AnassDev2005/nvim/main/install.sh | bash
```

Then open `nvim`. The first launch downloads the plugins and starts installing
the configured editor tools. Let those installations finish before using the
language features. Use `:Mason` and `:checkhealth` to inspect their status.

The installer clones the config into `~/.config/nvim` and respects the standard
`XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_STATE_HOME`, and `XDG_CACHE_HOME`
variables. Existing Neovim config, data, state, and cache directories are moved
to adjacent `.backup.<timestamp>.<process-id>` paths before installation. Their
paths are printed so you can restore them. Close Neovim before installing.

The installer downloads this configuration; it does not install system packages
or require `sudo`.

### Requirements

- Neovim **0.11.2 or newer**, built with LuaJIT.
- Git **2.19 or newer**, Bash, and `curl`.
- A C compiler and Make for Treesitter parsers and Telescope's native extension.
- `ripgrep` and `fd` for searching files; `fzf` for the Python environment picker.
- Python 3 with `pip` for the Python tools, and CMake for CMake projects.
- `unzip` and `tar` for tool downloads. A Nerd Font is recommended for icons.

Install these with your operating system's package manager first. Your projects
still need their own compiler/build dependencies or Python environment. Install
`pytest` in the project environment to run Python tests.

## Keybindings

The leader key is **Space**. For example, `<leader>cb` means Space, then c, then b.

| Keys | Action |
| --- | --- |
| `<leader>cb` | Build the C project with `:make` |
| `<leader>cx` | Run a selected C executable or the current Python file |
| `<leader>cB` | Build the C project, then choose an executable to run |
| `<leader>cMg` | Configure CMake |
| `<leader>cMb` | Build with CMake |
| `<leader>cMr` | Build and run with CMake |
| `<leader>cMd` | Debug with CMake |
| `<leader>cMv` | Select the CMake build type |
| `<leader>cMt` | Select the CMake launch target |
| `<leader>cv` | Select the Python environment |
| `<leader>dPp` | Debug the current Python file |
| `<leader>tt` / `<leader>tr` / `<leader>td` | Run file tests / nearest test / debug a test |
| `<leader>cr` / `<leader>ca` / `<leader>cf` | Rename / code actions / format |
| `<leader>db` / `<leader>dc` | Toggle a breakpoint / continue debugging |
| `<leader>dO` / `<leader>di` / `<leader>do` | Step over / into / out |
| `<leader>dt` | Terminate debugging |
| `<leader>uh` | Toggle inlay hints |

Open Neovim from your project root. C build flags belong in the project's
Makefile or CMake presets. Supply `compile_commands.json` or `compile_flags.txt`
for clangd; it also runs clang-tidy checks. Project `.clang-format` and
`pyproject.toml` files control formatting and lint policy.

Python uses Pyright for types, Ruff for linting/formatting/imports, and debugpy
for debugging. The runner uses the selected environment, then `VIRTUAL_ENV`,
then a project `.venv` or `venv`, and finally `python3`.

## Update and customize

```sh
git -C "${XDG_CONFIG_HOME:-$HOME/.config}/nvim" pull --ff-only
```

Restart Neovim and run `:Lazy restore` to use the plugin versions recorded in
`lazy-lock.json`. To update plugins instead, use `:Lazy update`; that changes
the lockfile. Commit or save your own config changes before pulling updates.

| Path | Purpose |
| --- | --- |
| `init.lua`, `lua/config/lazy.lua` | lazy.nvim and LazyVim bootstrap |
| `lazyvim.json` | Enabled LazyVim extras |
| `lua/config/options.lua` | Editor options |
| `lua/config/autocmds.lua` | Language indentation and C include pairing |
| `lua/config/workflow.lua` | Build/run helpers and Python environment selection |
| `lua/plugins/` | Language, theme, completion, formatting, and pairing settings |
| `lazy-lock.json` | Recorded plugin versions |

Based on the [LazyVim starter](https://github.com/LazyVim/starter).
See [LICENSE](LICENSE) for the Apache 2.0 license.
