#!/bin/bash
set -e

cd "$(dirname "$0")/extensions/vscode"

echo "Building..."
npm run esbuild

echo "Packaging..."
npm run package

echo "Installing..."
code --install-extension build/code-assistant-1.0.0.vsix

echo "Done. Reload VS Code with Ctrl+Shift+P → Reload Window"
