#!/usr/bin/env bash
# Scheduled "query current time" task.
#
# Purpose: invoke Claude headlessly so it runs a tiny task and consumes a few
# tokens (keeps the rolling usage window warm). Designed to be driven by cron.
#
# Cron has a minimal PATH, so we locate the claude binary explicitly.
set -euo pipefail

CLAUDE_BIN="${CLAUDE_BIN:-/opt/node22/bin/claude}"
LOG_DIR="${LOG_DIR:-$HOME/.xskill-cron}"
LOG_FILE="$LOG_DIR/query_time.log"

mkdir -p "$LOG_DIR"

{
  echo "----- $(date '+%Y-%m-%d %H:%M:%S %Z') : invoking claude -----"
  "$CLAUDE_BIN" -p "查询当前时间：运行 date 命令并告诉我现在的日期和时间（含时区）。" \
    --allowed-tools "Bash(date)" 2>&1
  echo
} >> "$LOG_FILE" 2>&1
