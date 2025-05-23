#!/bin/bash

PLAN_FILE=".github/instructions/PlanMode.instructions.md"
ACT_FILE=".github/instructions/ActMode.instructions.md"
PLAN_DISABLED="${PLAN_FILE}.disabled"
ACT_DISABLED="${ACT_FILE}.disabled"

# Determine current mode and switch
if [ -f "$PLAN_FILE" ] && [ -f "$ACT_DISABLED" ]; then
  # Currently in Plan mode, switch to Act mode
  mv "$PLAN_FILE" "$PLAN_DISABLED"
  mv "$ACT_DISABLED" "$ACT_FILE"
  echo "Switched to Act Mode"
elif [ -f "$ACT_FILE" ] && [ -f "$PLAN_DISABLED" ]; then
  # Currently in Act mode, switch to Plan mode
  mv "$ACT_FILE" "$ACT_DISABLED"
  mv "$PLAN_DISABLED" "$PLAN_FILE"
  echo "Switched to Plan Mode"
else
  # Initialize to Plan Mode (default)
  [ -f "$ACT_FILE" ] && mv "$ACT_FILE" "$ACT_DISABLED"
  [ -f "$PLAN_DISABLED" ] && mv "$PLAN_DISABLED" "$PLAN_FILE"
  [ ! -f "$PLAN_FILE" ] && [ -f "$PLAN_DISABLED" ] && mv "$PLAN_DISABLED" "$PLAN_FILE"
  echo "Reset to Plan Mode"
fi
