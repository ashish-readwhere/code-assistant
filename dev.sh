#!/bin/bash

ROOT="$(cd "$(dirname "$0")" && pwd)"

# ── colors ──────────────────────────────────────────────
BOLD="\033[1m"
DIM="\033[2m"
RESET="\033[0m"
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"
RED="\033[31m"
WHITE="\033[97m"
BG_DARK="\033[48;5;234m"

ok()   { echo -e "${GREEN}✔ $1${RESET}"; }
err()  { echo -e "${RED}✘ $1${RESET}"; }
info() { echo -e "${CYAN}→ $1${RESET}"; }
step() { echo -e "\n${BOLD}${WHITE}$1${RESET}"; }

run() {
  echo -e "${DIM}$ $*${RESET}"
  eval "$@"
  local code=$?
  if [ $code -ne 0 ]; then
    err "Command failed (exit $code): $*"
    exit $code
  fi
}

# ── header ───────────────────────────────────────────────
print_header() {
  clear
  echo -e "${BOLD}${CYAN}"
  echo "  ╔══════════════════════════════════════╗"
  echo "  ║      Code Assistant — Dev CLI        ║"
  echo "  ║   Mediology Software Pvt Ltd         ║"
  echo "  ╚══════════════════════════════════════╝"
  echo -e "${RESET}"
}

# ── menu ─────────────────────────────────────────────────
print_menu() {
  echo -e "${BOLD}  Select an option:${RESET}\n"
  echo -e "  ${CYAN}1${RESET}  Rebuild & Install  ${DIM}(esbuild → package → install)${RESET}"
  echo -e "  ${CYAN}2${RESET}  Full Setup         ${DIM}(packages → core → gui → extension)${RESET}"
  echo -e "  ${CYAN}3${RESET}  Rebuild GUI only   ${DIM}(vite build)${RESET}"
  echo -e "  ${CYAN}4${RESET}  Build packages     ${DIM}(workspace packages in order)${RESET}"
  echo -e "  ${CYAN}5${RESET}  Package only       ${DIM}(create .vsix without rebuilding)${RESET}"
  echo -e "  ${CYAN}6${RESET}  Install only       ${DIM}(install existing .vsix)${RESET}"
  echo -e "  ${CYAN}7${RESET}  Watch mode         ${DIM}(esbuild-watch + gui dev in parallel)${RESET}"
  echo -e "  ${CYAN}8${RESET}  Run tests          ${DIM}(extension unit tests)${RESET}"
  echo -e "  ${CYAN}9${RESET}  Show version       ${DIM}(current package.json version)${RESET}"
  echo -e "  ${CYAN}s${RESET}  Share info         ${DIM}(file path + install command for teammates)${RESET}"
  echo -e "  ${CYAN}0${RESET}  Exit"
  echo ""
  echo -ne "  ${BOLD}Enter choice [0-9/s]:${RESET} "
}

# ── tasks ────────────────────────────────────────────────

do_rebuild_install() {
  step "Rebuild & Install"
  cd "$ROOT/extensions/vscode"
  info "Building extension..."
  run npm run esbuild
  info "Packaging..."
  run npm run package
  info "Installing..."
  run code --install-extension build/code-assistant-1.0.0.vsix
  ok "Done — reload VS Code with Ctrl+Shift+P → Reload Window"
}

do_full_setup() {
  step "Full Setup"

  info "Installing root dependencies..."
  cd "$ROOT" && run npm install

  info "Installing Vite globally..."
  run npm install -g vite

  info "Building workspace packages..."
  for pkg in config-types llm-info terminal-security fetch config-yaml openai-adapters; do
    info "  → $pkg"
    cd "$ROOT/packages/$pkg" && run npm install && run npm run build
  done

  info "Installing core dependencies..."
  cd "$ROOT/core" && run npm install

  info "Building GUI..."
  cd "$ROOT/gui" && run npm install && run npm run build

  info "Building & packaging extension..."
  cd "$ROOT/extensions/vscode" && run npm install && run npm run esbuild && run npm run package

  info "Installing..."
  cd "$ROOT/extensions/vscode" && run code --install-extension build/code-assistant-1.0.0.vsix

  ok "Full setup complete — reload VS Code with Ctrl+Shift+P → Reload Window"
}

do_rebuild_gui() {
  step "Rebuild GUI"
  cd "$ROOT/gui"
  info "Running vite build..."
  run npm run build
  ok "GUI rebuilt — run option 1 to repackage and install"
}

do_build_packages() {
  step "Build Workspace Packages"
  for pkg in config-types llm-info terminal-security fetch config-yaml openai-adapters; do
    info "Building $pkg..."
    cd "$ROOT/packages/$pkg" && run npm install && run npm run build
  done
  ok "All packages built"
}

do_package_only() {
  step "Package Extension"
  cd "$ROOT/extensions/vscode"
  run npm run package
  ok "Packaged → build/code-assistant-1.0.0.vsix"
}

do_install_only() {
  step "Install Extension"
  local vsix="$ROOT/extensions/vscode/build/code-assistant-1.0.0.vsix"
  if [ ! -f "$vsix" ]; then
    err ".vsix not found at $vsix — run option 1 or 5 first"
    return 1
  fi
  run code --install-extension "$vsix"
  ok "Installed — reload VS Code with Ctrl+Shift+P → Reload Window"
}

do_watch_mode() {
  step "Watch Mode"
  info "Starting esbuild-watch and gui dev server in parallel..."
  info "Press Ctrl+C to stop both"
  echo ""
  trap 'kill 0' INT
  (cd "$ROOT/extensions/vscode" && npm run esbuild-watch) &
  (cd "$ROOT/gui" && npm run dev) &
  wait
}

do_tests() {
  step "Run Tests"
  cd "$ROOT/extensions/vscode"
  run npm run test
  ok "Tests complete"
}

do_share_info() {
  step "Share Info"
  local version
  version=$(node -p "require('$ROOT/extensions/vscode/package.json').version")
  local vsix="$ROOT/extensions/vscode/build/code-assistant-${version}.vsix"

  if [ ! -f "$vsix" ]; then
    err ".vsix not found — run option 1 or 5 first to build it"
    return 1
  fi

  local size
  size=$(du -sh "$vsix" | cut -f1)

  echo -e "  ${BOLD}File path:${RESET}"
  echo -e "  ${YELLOW}$vsix${RESET}"
  echo -e "  ${DIM}Size: $size${RESET}"
  echo ""
  echo -e "  ${BOLD}Install command (share this with teammates):${RESET}"
  echo -e "  ${GREEN}code --install-extension code-assistant-${version}.vsix${RESET}"
  echo ""
  echo -e "  ${DIM}After installing, reload VS Code:${RESET}"
  echo -e "  ${DIM}Ctrl+Shift+P → Reload Window${RESET}"
}

do_show_version() {
  step "Current Version"
  local version
  version=$(node -p "require('$ROOT/extensions/vscode/package.json').version")
  local name
  name=$(node -p "require('$ROOT/extensions/vscode/package.json').displayName")
  echo -e "  ${BOLD}$name${RESET} — v${YELLOW}$version${RESET}"
  echo ""
  echo -ne "  ${BOLD}Enter new version (or press Enter to keep v$version):${RESET} "
  read -r new_version
  if [ -n "$new_version" ]; then
    cd "$ROOT/extensions/vscode"
    node -e "
      const fs = require('fs');
      const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
      pkg.version = '$new_version';
      fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\n');
      console.log('Version updated to $new_version');
    "
    ok "Version bumped to $new_version — run option 1 to rebuild"
  fi
}

# ── main loop ────────────────────────────────────────────
while true; do
  print_header
  print_menu
  read -r choice

  case $choice in
    1) do_rebuild_install ;;
    2) do_full_setup ;;
    3) do_rebuild_gui ;;
    4) do_build_packages ;;
    5) do_package_only ;;
    6) do_install_only ;;
    7) do_watch_mode ;;
    8) do_tests ;;
    9) do_show_version ;;
    s|S) do_share_info ;;
    0) echo -e "\n${DIM}Bye.${RESET}\n"; exit 0 ;;
    *) err "Invalid option. Enter a number between 0-9." ;;
  esac

  echo ""
  echo -ne "${DIM}Press Enter to return to menu...${RESET}"
  read -r
done
