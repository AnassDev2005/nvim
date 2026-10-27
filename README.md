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

The leader key is **Space** and the local leader is **backslash** (`\`).
`<leader>cb` means press Space, then c, then b. Keys are case-sensitive:
`b` and `B` are different. `<C-x>` means Ctrl+x, `<A-x>` means Alt+x,
`<S-x>` means Shift+x, and `<CR>` means Enter.

Mappings below use **Normal mode** unless another mode is stated. They cover
this config, its enabled LazyVim extras, and the included plugin controls,
checked against the versions in `lazy-lock.json`. LSP actions appear when a
language server attaches and supports the action; Git actions need a Git repo,
and debugging/testing needs the appropriate adapter and project dependencies.
Standard Neovim editing commands are documented in `:help index`.

**Find a shortcut while editing:** press Space and wait for which-key,
use `<leader>?` for buffer mappings, or `<leader>sk` to search mappings.
Plugin panels also expose their own help as listed below.

- [Build, run, and languages](#build-run-and-languages)
- [Files and buffers](#files-and-buffers)
- [Windows, tabs, and terminals](#windows-tabs-and-terminals)
- [Search and navigation](#search-and-navigation)
- [Code, diagnostics, and formatting](#code-diagnostics-and-formatting)
- [Completion, snippets, and pairs](#completion-snippets-and-pairs)
- [Editing, text objects, and surrounds](#editing-text-objects-and-surrounds)
- [Git](#git)
- [Debugging](#debugging)
- [Tests](#tests)
- [UI, messages, and profiling](#ui-messages-and-profiling)
- [Sessions and quitting](#sessions-and-quitting)
- [Plugin panel controls](#plugin-panel-controls)

### Build, run, and languages

| Keys | Action / availability |
| --- | --- |
| `<leader>cb` | Save all files and build with `:make` (C, clangd attached) |
| `<leader>cx` | Choose and run an executable (C, clangd attached); save and run the current file (Python, Pyright attached) |
| `<leader>cB` | Save all files, build with `:make`, then choose an executable if the build succeeds (C, clangd attached) |
| `<leader>ch` | Switch between source and header (C/C++, clangd) |
| `<leader>cMg` | Save all files and configure CMake |
| `<leader>cMb` | Save all files and build with CMake |
| `<leader>cMr` | Save all files and run with CMake (builds first by default) |
| `<leader>cMd` | Save all files and debug with CMake/codelldb |
| `<leader>cMt` | Select the CMake launch target |
| `<leader>cMv` | Select the CMake build type |
| `<leader>cv` | Select a Python virtual environment |
| `<leader>dPp` | Save and debug the current Python file |
| `<leader>dPt` | Debug the current Python test method |
| `<leader>dPc` | Debug the current Python test class |
| `<localleader>r` | Run Lua in a Lua buffer (Normal or Visual mode) |

The custom `:make`/executable mappings are restricted to the `c` filetype.
C++ has the clangd, CMake, and debugger mappings. More CMake actions are
available as commands, including `:CMakeSelectBuildTarget`,
`:CMakeSelectConfigurePreset`, `:CMakeSelectBuildPreset`, `:CMakeSelectCwd`,
`:CMakeSelectBuildDir`, and `:CMakeRunTest`.

### Files and buffers

| Keys | Action |
| --- | --- |
| `<C-s>` | Save file (Normal, Insert, Visual, or Select mode) |
| `<leader>fn` | New file |
| `<leader><Space>` / `<leader>ff` | Find files in the project root |
| `<leader>fF` | Find files in the current working directory |
| `<leader>fg` | Find Git-tracked files |
| `<leader>fc` | Find a Neovim config file |
| `<leader>fr` / `<leader>fR` | Recent files / recent files in the current directory |
| `<leader>e` / `<leader>fe` | Open Snacks explorer at the project root |
| `<leader>E` / `<leader>fE` | Open Snacks explorer at the current directory |
| `<leader>,` | Switch buffer using Telescope |
| `<leader>fb` / `<leader>fB` | Find other buffers / all buffers |
| `<S-h>` / `[b` | Previous buffer |
| `<S-l>` / `]b` | Next buffer |
| `<leader>bb` / <code>&lt;leader&gt;`</code> | Switch to the alternate buffer |
| `[B` / `]B` | Move the buffer left / right in the bufferline |
| `<leader>bj` | Pick a buffer by its label |
| `<leader>bp` | Pin or unpin the buffer |
| `<leader>bP` | Close unpinned buffers |
| `<leader>bd` | Delete the buffer while preserving the window layout |
| `<leader>bD` | Delete the buffer and its window |
| `<leader>bo` | Delete other buffers |
| `<leader>bi` | Delete buffers that are not visible |
| `<leader>bl` / `<leader>br` | Close buffers to the left / right |
| `<leader>.` | Toggle a scratch buffer |
| `<leader>S` | Select a scratch buffer |

The project root is detected from the current file/project. The current working
directory is the directory shown by `:pwd`; it can differ from the project root.

### Windows, tabs, and terminals

| Keys | Action |
| --- | --- |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Focus the left / lower / upper / right window |
| `<C-Up>` / `<C-Down>` | Increase / decrease window height |
| `<C-Left>` / `<C-Right>` | Decrease / increase window width |
| `<leader>-` | Split below |
| `<leader>\|` | Split to the right |
| `<leader>wd` | Close the window |
| `<leader>wm` / `<leader>uZ` | Toggle window zoom |
| `<leader>uz` | Toggle Zen mode |
| `<C-w><Space>` | Show window shortcuts in a repeating which-key menu |
| `<leader>w` + a window command | Access the standard `<C-w>` window commands through which-key |
| `<leader><Tab><Tab>` | New tab |
| `<leader><Tab>]` / `<leader><Tab>[` | Next / previous tab |
| `<leader><Tab>f` / `<leader><Tab>l` | First / last tab |
| `<leader><Tab>d` | Close the tab |
| `<leader><Tab>o` | Close other tabs |
| `<leader>ft` / `<leader>fT` | Open a terminal at the project root / current directory |
| `<C-/>` / `<C-_>` | Show/focus the root terminal from the editor; hide it from terminal input mode |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Navigate out of a non-floating terminal in Terminal mode; floating terminals pass the key to the running program |
| `<Esc><Esc>` | Leave terminal input mode (press twice quickly) |
| `q` | Hide a Snacks terminal in Normal mode |
| `gf` | Open the file under the cursor from a Snacks terminal in Normal mode |
| `<C-\><C-n>` | Standard Neovim shortcut to leave terminal input mode |

### Search and navigation

| Keys | Action / mode |
| --- | --- |
| `<leader>/` / `<leader>sg` | Search project text with ripgrep |
| `<leader>sG` | Search text in the current directory |
| `<leader>sw` / `<leader>sW` | Search the current word in the project / current directory; search the selection in Visual mode |
| `<leader>sb` | Fuzzy search lines in the current buffer |
| `<leader>sr` | Open search and replace (Normal or Visual mode) |
| `<leader>:` / `<leader>sc` | Command history |
| `<leader>s/` | Search history |
| `<leader>sC` | Available commands |
| `<leader>sa` | Autocommands |
| `<leader>s"` | Registers |
| `<leader>sh` | Help tags |
| `<leader>sH` | Highlight groups |
| `<leader>sj` | Jump list |
| `<leader>sk` | Keymaps |
| `<leader>sl` / `<leader>sq` | Location list / quickfix list in Telescope |
| `<leader>sM` | Man pages |
| `<leader>sm` | Marks |
| `<leader>so` | Vim options |
| `<leader>sR` | Resume the last Telescope picker |
| `<leader>ss` / `<leader>sS` | Document symbols / workspace symbols |
| `<leader>st` / `<leader>sT` | Find TODO comments / only TODO, FIX, and FIXME |
| `]t` / `[t` | Next / previous TODO comment |
| `s` | Flash jump (Normal, Visual, or Operator-pending mode) |
| `S` | Select a syntax node with Flash Treesitter (Normal, Visual, or Operator-pending mode) |
| `r` | Remote Flash after an operator, for example `dr` |
| `R` | Flash Treesitter search (Visual or Operator-pending mode) |
| `<C-s>` | Toggle Flash during command-line search |
| `<C-Space>` | Start/expand Treesitter selection (Normal, Visual, or Operator-pending mode); `<BS>` shrinks it while selecting |
| `j` / `<Down>` / `k` / `<Up>` | Move by screen lines without a count, by actual lines with a count (Normal or Visual mode) |
| `n` / `N` | Next / previous search result in buffer order; Normal mode also opens folds |
| `<Esc>` | Clear search highlighting and stop an active snippet (Normal, Insert, or Select mode) |
| `]f` / `[f` | Next / previous function start |
| `]F` / `[F` | Next / previous function end |
| `]c` / `[c` | Next / previous class start; standard change navigation in diff windows |
| `]C` / `[C` | Next / previous class end; standard change navigation in diff windows |
| `]a` / `[a` | Next / previous parameter start |
| `]A` / `[A` | Next / previous parameter end |
| `[i` / `]i` | Top / bottom edge of the indentation scope |

Treesitter motions require a parser with text-object queries and also work in
Visual and Operator-pending modes. Indentation scope jumps work in Normal,
Visual, and Operator-pending modes.

### Code, diagnostics, and formatting

| Keys | Action / mode |
| --- | --- |
| `gd` | Go to definition (Telescope) |
| `gD` | Go to declaration |
| `gr` | Find references (Telescope) |
| `gI` | Go to implementation (Telescope) |
| `gy` | Go to type definition (Telescope) |
| `K` | Hover documentation |
| `gK` | Signature help |
| `<C-k>` | Signature help (Insert mode; completion can toggle its signature window) |
| `<leader>K` | Run the built-in keyword lookup (`keywordprg`) |
| `<leader>cl` | LSP configuration/info picker |
| `<leader>cm` | Open Mason to manage language servers, formatters, and debuggers |
| `<leader>ca` | Code action (Normal or Visual mode) |
| `<leader>cA` | Source code action |
| `<leader>co` | Organize imports, when the server advertises this action |
| `<leader>cr` | Rename symbol |
| `<leader>cR` | Rename file, when the server supports workspace file renames |
| `<leader>cc` | Run code lens (Normal or Visual mode, if supported) |
| `<leader>cC` | Refresh and display code lenses (if supported) |
| `<leader>cf` | Format buffer or selection (Normal or Visual mode) |
| `<leader>cF` | Format injected languages (Normal or Visual mode) |
| `<leader>cd` | Show diagnostics for the current line |
| `]d` / `[d` | Next / previous diagnostic |
| `]e` / `[e` | Next / previous error |
| `]w` / `[w` | Next / previous warning |
| `]]` / `[[` | Next / previous highlighted reference, when supported |
| `<A-n>` / `<A-p>` | Next / previous reference with the jump variant that cycles across the buffer |
| `<leader>sd` / `<leader>sD` | Workspace / current-buffer diagnostics in Telescope |
| `<leader>xx` / `<leader>xX` | Toggle workspace / current-buffer diagnostics in Trouble |
| `<leader>cs` | Toggle symbols in Trouble |
| `<leader>cS` | Toggle LSP definitions/references in Trouble |
| `<leader>xl` / `<leader>xq` | Toggle location list / quickfix list |
| `<leader>xL` / `<leader>xQ` | Toggle location list / quickfix list in Trouble |
| `[q` / `]q` | Previous / next Trouble item if Trouble is open, otherwise quickfix item |
| `<leader>xt` / `<leader>xT` | Toggle TODOs / TODO, FIX, and FIXME in Trouble |

### Completion, snippets, and pairs

Completion uses Blink's **enter** preset. These keys apply in Insert mode
(including snippet Select mode where supported); they fall back to normal
editing when the corresponding completion/snippet action is unavailable.

| Keys | Action |
| --- | --- |
| `<CR>` | Accept the selected completion; otherwise insert a newline |
| `<C-y>` | Select and accept a completion |
| `<C-Space>` | Open completion, then show/hide completion documentation |
| `<C-e>` | Cancel completion |
| `<C-n>` / `<Down>` | Next completion |
| `<C-p>` / `<Up>` | Previous completion |
| `<Tab>` / `<S-Tab>` | Next / previous snippet field; Tab otherwise keeps its normal behavior |
| `<C-f>` / `<C-b>` | Scroll documentation down / up; Noice also uses these for LSP popups in Normal, Insert, and Select modes |
| `<C-k>` | Show/hide the signature-help popup |
| `(` / `[` / `{` / `"` / `'` / <code>`</code> | Insert paired delimiters when the pairing rules allow it (Insert and Command-line modes) |
| `)` / `]` / `}` | Skip an existing paired closing delimiter (Insert and Command-line modes) |
| `<BS>` | Delete both sides of an empty automatic pair |
| `<CR>` | Expand an empty bracket pair onto separate lines when completion does not consume Enter |
| `<` / `>` | Pair/skip angle brackets in C/C++ `#include` lines (Insert mode) |

In Command-line mode, Blink uses a separate preset:

| Keys | Action |
| --- | --- |
| `<Tab>` / `<S-Tab>` | Show/insert completion and cycle forward / backward |
| `<C-Space>` | Show completion |
| `<C-n>` / `<C-p>` | Next / previous completion |
| `<C-y>` | Select and accept completion |
| `<C-e>` | Cancel completion |
| `<End>` | Hide completion, then fall back to the usual End key |

### Editing, text objects, and surrounds

| Keys | Action / mode |
| --- | --- |
| `<A-j>` / `<A-k>` | Move line/selection down / up (Normal, Insert, or Visual mode) |
| `<` / `>` | Indent left / right and keep the selection (Visual mode) |
| `,` / `.` / `;` | Add an undo break after punctuation (Insert mode) |
| `gcc` | Toggle the current line's comment (Neovim built-in) |
| `gc` + a motion | Toggle comments over a motion; `gc` comments the selection in Visual mode |
| `gco` / `gcO` | Add a comment line below / above |
| `gsa` + motion + delimiter | Add surrounding characters; use `gsa` + delimiter on a Visual selection |
| `gsd` + delimiter | Delete surrounding characters |
| `gsr` + old delimiter + new delimiter | Replace surrounding characters |
| `gsf` / `gsF` + delimiter | Find the right / left surrounding delimiter |
| `gsh` + delimiter | Highlight surrounding characters |
| `gsn` | Change how many lines surround searches inspect |
| `a` / `i` + object | Select around / inside an object (Visual or Operator-pending mode) |
| `an` / `in` + object | Select around / inside the next object |
| `al` / `il` + object | Select around / inside the previous object |
| `g[` / `g]` + object | Go to the left / right edge of an around-object |
| `ii` / `ai` | Inner / full indentation scope (Visual or Operator-pending mode) |

Examples: `gsa iw "` surrounds a word with double quotes; `gsr " '` changes
double quotes to single quotes; `dif` deletes inside a function; `vaf` selects
a function including its outer range.

| Object | Meaning after `a` / `i` (or the next/previous prefixes) |
| --- | --- |
| `(` / `)` | Parentheses |
| `[` / `]` | Square brackets |
| `{` / `}` / `B` | Braces |
| `<` / `>` | Angle brackets |
| `"` / `'` / <code>`</code> / `q` | A specific quote / any quote |
| `?` | Prompt for a custom text object |
| `b` | Nearest parentheses, square brackets, or braces |
| `<Space>` / `_` | Whitespace / underscore-delimited text |
| `a` | Argument |
| `f` | Function (Treesitter) |
| `c` | Class (Treesitter) |
| `o` | Block, conditional, or loop (Treesitter) |
| `t` | HTML/XML tag |
| `d` | Digits |
| `e` | Word part respecting case boundaries |
| `g` | Entire buffer |
| `u` / `U` | Function call / function call without a dotted name |

Opening versus closing bracket objects differ in whitespace handling. Standard
objects such as `iw`, `aw`, `ip`, and `ap` remain available. See `:help MiniAi`
and `:help MiniSurround` for delimiter input and repeated selections.

### Git

| Keys | Action / availability |
| --- | --- |
| `<leader>gg` / `<leader>gG` | Lazygit at the Git root / current directory (requires `lazygit`) |
| `<leader>gc` / `<leader>gl` | Commit history in Telescope |
| `<leader>gs` | Git status in Telescope |
| `<leader>gS` | Git stashes in Telescope |
| `<leader>gL` | Git log for the current directory in Snacks |
| `<leader>gb` | Git log for the current line in Snacks |
| `<leader>gf` | Git history for the current file in Snacks |
| `<leader>gB` | Open the repository/file/selection in a browser (Normal or Visual mode) |
| `<leader>gY` | Copy the repository/file/selection URL (Normal or Visual mode) |
| `]h` / `[h` | Next / previous hunk; native change navigation in diff windows |
| `]H` / `[H` | Last / first hunk |
| `<leader>ghs` | Stage hunk or selected lines (Normal or Visual mode) |
| `<leader>ghr` | Reset hunk or selected lines (Normal or Visual mode) |
| `<leader>ghS` | Stage the buffer |
| `<leader>ghu` | Undo staging the hunk |
| `<leader>ghR` | Reset the buffer |
| `<leader>ghp` | Preview the hunk inline |
| `<leader>ghb` | Show full blame for the current line |
| `<leader>ghB` | Show blame for the buffer |
| `<leader>ghd` | Diff against the index |
| `<leader>ghD` | Diff against the previous commit (`~`) |
| `ih` | Select a Git hunk (Visual or Operator-pending mode) |

Hunk mappings are buffer-local and appear after Gitsigns attaches.

### Debugging

| Keys | Action |
| --- | --- |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Set a conditional breakpoint |
| `<leader>dc` | Start/continue debugging |
| `<leader>da` | Start debugging with arguments |
| `<leader>dC` | Run to cursor |
| `<leader>dg` | Go to a line without executing it |
| `<leader>di` | Step into |
| `<leader>dO` | Step over |
| `<leader>do` | Step out |
| `<leader>dj` / `<leader>dk` | Move down / up the call stack |
| `<leader>dl` | Run the last debug configuration |
| `<leader>dP` | Pause |
| `<leader>dr` | Toggle debug REPL |
| `<leader>ds` | Access the current debug session |
| `<leader>dt` | Terminate debugging |
| `<leader>dw` | Show debugger widgets/hover |
| `<leader>du` | Toggle the debugger UI |
| `<leader>de` | Evaluate an expression/selection (Normal or Visual mode) |

Python file/method/class debugging and CMake debugging are listed under
[Build, run, and languages](#build-run-and-languages). C/C++ debug configurations
offer launching an executable or attaching to a process.

### Tests

These use Neotest; this config includes the Python pytest adapter.

| Keys | Action |
| --- | --- |
| `<leader>tt` | Run tests in the current file |
| `<leader>tT` | Run all tests under the current working directory |
| `<leader>tr` | Run the nearest test |
| `<leader>tl` | Run the last test again |
| `<leader>td` | Debug the nearest test |
| `<leader>ta` | Attach to a running test |
| `<leader>ts` | Toggle test summary |
| `<leader>to` | Open test output |
| `<leader>tO` | Toggle the output panel |
| `<leader>tS` | Stop a running test |
| `<leader>tw` | Toggle watch mode for the current test file |

### UI, messages, and profiling

| Keys | Action |
| --- | --- |
| `<leader>uf` / `<leader>uF` | Toggle autoformat globally / for the buffer |
| `<leader>us` | Toggle spelling |
| `<leader>uw` | Toggle line wrapping |
| `<leader>ul` / `<leader>uL` | Toggle line numbers / relative numbers |
| `<leader>ud` | Toggle diagnostics |
| `<leader>uc` | Toggle conceal level |
| `<leader>uA` | Toggle the tabline |
| `<leader>uT` | Toggle Treesitter highlighting |
| `<leader>ub` | Toggle dark/light background |
| `<leader>uD` | Toggle dimming inactive scopes |
| `<leader>ua` | Toggle animations |
| `<leader>ug` | Toggle indentation guides |
| `<leader>uS` | Toggle smooth scrolling |
| `<leader>uh` | Toggle LSP inlay hints, when supported |
| `<leader>uG` | Toggle Git signs |
| `<leader>up` | Toggle automatic pairs |
| `<leader>uC` | Preview/select a colorscheme |
| `<leader>ur` | Clear search highlighting, update diffs, and redraw |
| `<leader>ui` / `<leader>uI` | Inspect the cursor position / syntax tree |
| `<leader>n` | Notification history |
| `<leader>un` | Dismiss notifications |
| `<leader>snl` | Last Noice message |
| `<leader>snh` / `<leader>sna` | Noice message history / all messages |
| `<leader>snd` | Dismiss Noice messages |
| `<leader>snt` | Noice message picker |
| `<S-Enter>` | Redirect command-line output through Noice (Command-line mode) |
| `<C-f>` / `<C-b>` | Scroll an LSP popup forward / backward (Normal, Insert, or Select mode) |
| `<leader>dpp` | Toggle the profiler |
| `<leader>dph` | Toggle profiler highlights |
| `<leader>dps` | Open a profiler scratch buffer |
| `<leader>l` | Open the Lazy plugin manager |
| `<leader>L` | Open the LazyVim changelog |
| `<leader>?` | Show buffer keymaps with which-key |

### Sessions and quitting

| Keys | Action |
| --- | --- |
| `<leader>qs` | Restore the session for the current directory |
| `<leader>qS` | Select a saved session |
| `<leader>ql` | Restore the last session |
| `<leader>qd` | Stop saving the current session |
| `<leader>qq` | Quit all windows |

### Plugin panel controls

These keys are local to the named panel and take precedence over editor
shortcuts while it is focused. Each panel's help shows its live mappings.

#### Telescope pickers

Pickers start in Insert mode. Press `<Esc>` to enter Normal mode; press it again
to close the picker.

| Keys | Action / picker mode |
| --- | --- |
| `<CR>` / double-click | Open the selected result (Insert or Normal) |
| `<C-n>` / `<C-p>` | Next / previous result (Insert) |
| `<Down>` / `<Up>` | Next / previous result (Insert or Normal) |
| `j` / `k` | Next / previous result (Normal) |
| `H` / `M` / `L` | Top / middle / bottom of the result list (Normal) |
| `gg` / `G` | First / last result (Normal) |
| `<C-x>` / `<C-v>` | Open in a horizontal / vertical split (Insert or Normal) |
| `<C-t>` | Open results in Trouble (Insert); open in a new tab (Normal) |
| `<A-t>` | Open results in Trouble (Insert) |
| `<Tab>` / `<S-Tab>` | Toggle selection and move to the next / previous result (Insert or Normal) |
| `<C-q>` / `<A-q>` | Send all / selected results to quickfix (Insert or Normal) |
| `<C-u>` / `<C-d>` | Scroll preview up / down (Insert or Normal) |
| `<C-f>` / `<C-b>` | Scroll preview down / up (Insert) |
| `<C-f>` / `<C-k>` | Scroll preview left / right (Normal); `<C-k>` also scrolls right in Insert mode |
| `<PageUp>` / `<PageDown>` | Scroll results up / down (Insert or Normal) |
| `<A-f>` / `<A-k>` | Scroll results left / right (Insert or Normal) |
| `<C-Up>` / `<C-Down>` | Previous / next prompt history (Insert) |
| `<A-i>` | Find files without ignore rules (Insert) |
| `<A-h>` | Find files including hidden files (Insert) |
| `<A-c>` | Reopen a root-based picker at the current directory (Insert; when root and current directory differ) |
| `<C-r>` | Refresh environment search in the Python virtual-environment picker (Insert); this picker disables Tab multi-selection |
| `<C-s>` / `s` | Flash-select a result (Insert / Normal) |
| `<C-l>` | Complete a tag (Insert) |
| `<C-w>` | Delete the previous word (Insert) |
| `<C-r><C-w>` / `<C-r><C-a>` | Insert the original word / WORD (Insert) |
| `<C-r><C-f>` / `<C-r><C-l>` | Insert the original file / line under the cursor (Insert) |
| `<C-/>` / `<C-_>` | Show picker key help (Insert) |
| `?` | Show picker key help (Normal) |
| `<C-c>` | Close the picker (Insert) |
| `q` / `<Esc>` | Close the picker (Normal) |

#### Snacks explorer and pickers

The explorer starts in the list in Normal mode. These file actions apply there:

| Keys | Action |
| --- | --- |
| `l` / `<CR>` / double-click | Open a file or expand a directory |
| `h` / `<BS>` | Close a directory / go up a directory |
| `a` / `d` / `r` | Add / delete / rename a file or directory |
| `c` / `m` | Copy / move files |
| `y` / `p` | Yank / paste paths (y also works in Visual mode) |
| `o` | Open with the system application |
| `u` | Refresh the explorer |
| `.` | Focus the current item as the explorer root |
| `Z` | Close all directories |
| `H` / `I` | Toggle hidden / ignored files |
| `P` | Toggle preview |
| `<C-c>` | Set the tab's working directory |
| `<leader>/` | Search text in the selected directory |
| `<C-t>` | Open a terminal at the selected directory |
| `]g` / `[g` | Next / previous Git change |
| `]d` / `[d` | Next / previous diagnostic |
| `]e` / `[e` | Next / previous error |
| `]w` / `[w` | Next / previous warning |

Shared Snacks picker controls also apply to Git history and LSP-info pickers.
Explorer actions above override shared list keys such as `<C-t>`.

| Keys | Action / context |
| --- | --- |
| `?` | Show help for the focused list/input (Normal) |
| `/` | Switch between input and list (Normal) |
| `i` | Focus input from the list/preview |
| `<CR>` | Confirm result (input Insert/Normal or list) |
| `<S-CR>` | Choose a window and open the result |
| `j` / `k`, `<Down>` / `<Up>`, `<C-j>` / `<C-k>`, `<C-n>` / `<C-p>` | Next / previous result (`j`/`k` are Normal-mode only) |
| `gg` / `G` | First / last result (Normal) |
| `<Tab>` / `<S-Tab>` | Toggle selection and move down / up (also list Visual mode) |
| `<C-a>` | Select all results |
| `<C-d>` / `<C-u>` | Scroll the result list down / up |
| `<C-f>` / `<C-b>` | Scroll preview down / up |
| `<C-s>` / `<C-v>` | Open in a horizontal / vertical split |
| `<C-t>` | Open in a tab (overridden by terminal in the explorer list) |
| `<C-q>` | Send results to quickfix |
| `<C-g>` | Toggle live search in input; print the path in the list |
| `<C-Up>` / `<C-Down>` | Previous / next search history (input) |
| `<C-w>` | Delete the previous word (input Insert mode) |
| `<C-r>#` / `<C-r>%` | Insert alternate / current filename (input Insert mode) |
| `<C-r><C-a>` / `<C-r><C-w>` | Insert original WORD / word (input Insert mode) |
| `<C-r><C-f>` / `<C-r><C-p>` | Insert file / full file path (input Insert mode) |
| `<C-r><C-l>` | Insert original line (input Insert mode) |
| `<A-d>` | Inspect picker state |
| `<A-f>` | Toggle following links |
| `<A-h>` / `<A-i>` | Toggle hidden / ignored files |
| `<A-r>` | Toggle regex (input) |
| `<A-m>` / `<A-p>` | Toggle maximize / preview |
| `<A-w>` | Cycle picker windows |
| `<C-w>H` / `<C-w>J` / `<C-w>K` / `<C-w>L` | Move layout left / bottom / top / right (Normal) |
| `zb` / `zt` / `zz` | Scroll the selected result to bottom / top / center (list) |
| `q` / `<Esc>` | Close (Normal; Escape in input Insert mode first leaves Insert mode) |
| `<C-c>` | Cancel (input Insert mode; explorer list uses this to change directory) |

#### Search and replace (grug-far)

These are Normal-mode mappings inside the search/replace buffer.

| Keys | Action |
| --- | --- |
| `<localleader>r` | Replace matches |
| `<localleader>q` | Send matches to quickfix |
| `<localleader>s` / `<localleader>l` / `<localleader>v` | Sync edited matches to source files: all / current line / current file |
| `<localleader>j` / `<localleader>k` | Apply next / previous replacement |
| `<localleader>n` / `<localleader>p` | Sync next / previous match |
| `<localleader>o` / `<CR>` | Open / go to the match; Enter selects an entry in history |
| `<Down>` / `<Up>` | Open the next / previous match |
| `<localleader>i` | Preview the match |
| `<localleader>f` | Refresh results |
| `<localleader>b` | Abort the operation |
| `<localleader>t` / `<localleader>a` | Open history / add an entry to history |
| `<localleader>w` | Toggle showing the underlying command |
| `<localleader>e` / `<localleader>x` | Change search engine / replacement interpreter |
| `<Tab>` / `<S-Tab>` | Next / previous input field |
| `<localleader>c` | Close the panel |
| `g?` | Show help |

#### Trouble

| Keys | Action |
| --- | --- |
| `?` | Help |
| `<CR>` / double-click | Jump to an item |
| `o` | Jump and close |
| `<C-s>` / `<C-v>` | Jump in a horizontal / vertical split |
| `}` / `]]` and `{` / `[[` | Next / previous item |
| `r` / `R` | Refresh / toggle automatic refresh |
| `p` / `P` | Preview / toggle automatic preview |
| `gb` / `s` | Toggle current-buffer filter / cycle severity filter |
| `dd` | Remove an item; `d` removes a Visual selection |
| `i` | Inspect an item |
| `zo` / `zO` | Open a fold / open recursively |
| `zc` / `zC` | Close a fold / close recursively |
| `za` / `zA` | Toggle a fold / toggle recursively |
| `zm` / `zr` | Fold more / fold less |
| `zM` / `zR` | Close / open all folds |
| `zx` / `zX` | Update folds / update all folds |
| `zn` / `zN` / `zi` | Disable / enable / toggle folding |
| `q` / `<Esc>` | Close / cancel |

#### Neotest summary

| Keys | Action |
| --- | --- |
| `<CR>` / double-click | Expand/collapse a node |
| `e` | Expand all |
| `P` / `<` / `>` | Parent / previous sibling / next sibling |
| `r` / `d` | Run / debug a test |
| `a` / `u` | Attach / stop |
| `o` / `O` | Output / short output |
| `i` | Jump to the test |
| `m` / `M` | Mark a test / clear marked tests |
| `R` / `D` | Run / debug marked tests |
| `t` / `T` | Set / clear the target |
| `J` / `K` | Next / previous failed test |
| `w` | Watch |
| `?` | Help |

#### Debugger UI

Actions depend on the focused scopes, watches, breakpoints, or stacks panel.

| Keys | Action |
| --- | --- |
| `<CR>` / double-click | Expand an item |
| `o` | Open the item |
| `d` / `e` | Remove / edit the item |
| `r` | Send the item to the REPL |
| `t` | Toggle the item |
| `w` | Add a watch |
| `q` / `<Esc>` | Close a floating debugger window |

#### Dashboard

These keys apply only on the startup dashboard.

| Keys | Action |
| --- | --- |
| `f` / `n` | Find a file / new file |
| `g` / `r` | Search text / recent files |
| `c` / `s` | Find a config file / restore session |
| `x` / `l` | Lazy extras / Lazy plugin manager |
| `q` | Quit |

#### Lazy plugin manager

Open with `<leader>l`. Uppercase actions generally operate on all relevant
plugins; the corresponding lowercase action operates on the selected plugin.

| Keys | Action |
| --- | --- |
| `H` / `?` | Plugin list / help |
| `<CR>` | Toggle plugin details |
| `I` / `i` | Install missing plugins / selected plugin |
| `U` / `u` | Update all / selected plugin (also updates the lockfile) |
| `S` | Sync: install, clean, and update |
| `X` / `x` | Clean unused plugins / delete the selected plugin |
| `C` / `c` | Check all / selected plugin for updates |
| `L` / `gl` | Recent updates for all / selected plugin |
| `R` / `r` | Restore all / selected plugin from the lockfile |
| `gb` | Rebuild selected plugin |
| `P` / `D` | Profiling / debug information |
| `<C-s>` / `<C-f>` | Change profiler sorting / filter |
| `]]` / `[[` | Next / previous plugin |
| `K` / `d` | Hover/browser information / diff |
| `<localleader>l` | Open the plugin's Lazygit log (requires `lazygit`) |
| `<localleader>i` | Inspect the selected plugin |
| `<localleader>t` | Open a terminal in the plugin directory |
| `<C-c>` | Abort running tasks |
| `q` | Close |

#### Mason tool manager

Open with `<leader>cm` or `:Mason`.

| Keys | Action |
| --- | --- |
| `<CR>` | Expand a package / toggle its installation log |
| `i` / `u` / `X` | Install / update or reinstall / uninstall the package |
| `c` / `C` | Check package version / check all installed tools for updates |
| `U` | Update all installed packages |
| `<C-c>` | Cancel installation |
| `<C-f>` | Apply a language filter |
| `g?` | Help |
| `1` / `2` / `3` / `4` / `5` | Show all packages / language servers / debuggers / linters / formatters |
| `q` / `<Esc>` | Close; Escape first clears an active language filter or search |

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
