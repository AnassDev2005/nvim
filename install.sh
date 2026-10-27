#!/usr/bin/env bash
set -Eeuo pipefail

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

command -v git >/dev/null 2>&1 || die 'Install Git 2.19 or newer first.'
command -v nvim >/dev/null 2>&1 || die 'Install Neovim 0.11.2 or newer first.'

nvim_version=$(nvim --version)
if [[ $nvim_version =~ NVIM[[:space:]]v([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
  major=${BASH_REMATCH[1]}
  minor=${BASH_REMATCH[2]}
  patch=${BASH_REMATCH[3]}
  (( major > 0 || minor > 11 || (minor == 11 && patch >= 2) )) ||
    die 'Neovim 0.11.2 or newer is required.'
else
  die 'Could not determine the Neovim version.'
fi
[[ $nvim_version == *LuaJIT* ]] || die 'Neovim must be built with LuaJIT.'

: "${HOME:?HOME must be set}"
config_root=${XDG_CONFIG_HOME:-$HOME/.config}
data_root=${XDG_DATA_HOME:-$HOME/.local/share}
state_root=${XDG_STATE_HOME:-$HOME/.local/state}
cache_root=${XDG_CACHE_HOME:-$HOME/.cache}
for root in "$config_root" "$data_root" "$state_root" "$cache_root"; do
  [[ $root == /* ]] || die 'HOME and XDG directories must use absolute paths.'
done

config_dir=$config_root/nvim
mkdir -p -- "$config_root"
workdir=$(mktemp -d "$config_root/.anass-nvim.XXXXXXXX")
originals=()
backups=()
backup_count=0
installed=false

cleanup() {
  local status=$?
  trap - EXIT HUP INT TERM
  if [[ $installed == false ]]; then
    local index
    for ((index=backup_count-1; index>=0; index--)); do
      if ! mv -- "${backups[$index]}" "${originals[$index]}"; then
        printf 'Could not restore %s; your backup is at %s\n' \
          "${originals[$index]}" "${backups[$index]}" >&2
        status=1
      fi
    done
  fi
  rm -rf -- "$workdir"
  exit "$status"
}
trap cleanup EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

printf 'Downloading AnassDev2005/nvim...\n'
git clone --depth 1 --branch main \
  https://github.com/AnassDev2005/nvim.git "$workdir/nvim"
[[ -f $workdir/nvim/init.lua && -f $workdir/nvim/lua/config/lazy.lua ]] ||
  die 'The downloaded repository is missing the Neovim config.'
[[ -f $workdir/nvim/scripts/setup-42-tools.sh ]] ||
  die 'The downloaded repository is missing the 42 tools installer.'
command -v python3 >/dev/null 2>&1 || die 'Install Python 3.10+ with venv support first.'
python3 -c 'import sys; sys.exit(sys.version_info < (3, 10))' ||
  die 'Python 3.10+ is required for the 42 formatter and Norminette.'

stamp=$(date -u +%Y%m%dT%H%M%SZ).$$
for path in "$config_dir" "$data_root/nvim" "$state_root/nvim" "$cache_root/nvim"; do
  if [[ -e $path || -L $path ]]; then
    backup=$path.backup.$stamp
    [[ ! -e $backup && ! -L $backup ]] || die "Backup path already exists: $backup"
    mv -- "$path" "$backup"
    originals+=("$path")
    backups+=("$backup")
    backup_count=$((backup_count + 1))
    printf 'Backup: %s\n' "$backup"
  fi
done

mv -- "$workdir/nvim" "$config_dir"
installed=true

printf '\nInstalled in %s\n' "$config_dir"
if ! bash "$config_dir/scripts/setup-42-tools.sh"; then
  die "Config installed, but 42 tools setup failed. Retry: bash $config_dir/scripts/setup-42-tools.sh"
fi
printf 'Open nvim and let plugins and editor tools finish installing.\n'
