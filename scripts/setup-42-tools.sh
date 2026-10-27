#!/usr/bin/env bash
set -euo pipefail

command -v python3 >/dev/null 2>&1 || { printf 'Install Python 3.10+ with venv support first.\n' >&2; exit 1; }
python3 -c 'import sys; sys.exit(sys.version_info < (3, 10))' || {
  printf 'Python 3.10+ is required by Norminette.\n' >&2
  exit 1
}

tools_dir="${XDG_DATA_HOME:-$HOME/.local/share}/${NVIM_APPNAME:-nvim}/42-tools"
[[ "$tools_dir" == /* ]] || { printf 'XDG_DATA_HOME must be an absolute path.\n' >&2; exit 1; }
python3 -m venv "$tools_dir"
"$tools_dir/bin/python" -m pip install --disable-pip-version-check \
  'c-formatter-42==0.2.8' 'norminette==3.3.60'
"$tools_dir/bin/c_formatter_42" --help >/dev/null
"$tools_dir/bin/norminette" --version
printf '42 formatter and Norminette installed in %s\n' "$tools_dir"
