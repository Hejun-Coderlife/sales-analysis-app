#!/usr/bin/env bash
set -euo pipefail

# 将本目录（temp-test-site）符号链接到「运行 server.js 的那份仓库」的 frontend/temp-test-site，
# 以便通过 http://localhost:PORT/frontend/temp-test-site/ 同源访问。
#
# 用法:
#   ./link-into-frontend.sh /path/to/sales-analysis-app-<hash>/frontend

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_FRONTEND="${1:-}"

if [[ -z "$TARGET_FRONTEND" ]]; then
  echo "用法: $0 /path/to/repo/frontend" >&2
  echo "示例: $0 /Users/hejun/Desktop/sales-analysis-app-f43ce144d73b134ae5cf2ae8f2bcf5b628167a9b/frontend" >&2
  exit 1
fi

if [[ ! -d "$TARGET_FRONTEND" ]]; then
  echo "错误: 目录不存在: $TARGET_FRONTEND" >&2
  exit 1
fi

LINK_PATH="${TARGET_FRONTEND%/}/temp-test-site"

if [[ -e "$LINK_PATH" || -L "$LINK_PATH" ]]; then
  rm -rf "$LINK_PATH"
fi

ln -sfn "$SCRIPT_DIR" "$LINK_PATH"
echo "已创建符号链接:"
echo "  $LINK_PATH -> $SCRIPT_DIR"
