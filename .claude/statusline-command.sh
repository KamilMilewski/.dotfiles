#!/bin/sh

# Build a fixed-width progress bar.
# Usage: make_bar <percentage_0_to_100> <width>
make_bar() {
  pct="$1"
  width="$2"
  filled=$(awk "BEGIN { printf \"%d\", ($pct * $width / 100 + 0.5) }")
  empty=$((width - filled))
  bar=""
  i=0
  while [ $i -lt $filled ]; do bar="${bar}="; i=$((i + 1)); done
  i=0
  while [ $i -lt $empty ]; do bar="${bar}-"; i=$((i + 1)); done
  printf "%s" "$bar"
}

input=$(cat)

# --- directory & git ---
cwd=$(echo "$input" | jq -r '.cwd')
display_cwd=$(echo "$cwd" | sed "s|^$HOME|~|")

# Topic precedence: explicit /rename name > auto-generated topic > git branch.
# The auto topic is written by the Stop hook (generate-topic.sh) per session_id.
session_name=$(echo "$input" | jq -r '.session_name // empty')
session_id=$(echo "$input" | jq -r '.session_id // empty')
topic_file="$HOME/.claude/session-topics/$session_id"
is_auto=0
if [ -n "$session_name" ]; then
  git_info=" $session_name"
elif [ -n "$session_id" ] && [ -s "$topic_file" ]; then
  git_info=" $(cat "$topic_file")"
  is_auto=1
else
  branch=$(git -C "$cwd" --git-dir="$(git -C "$cwd" rev-parse --git-dir 2>/dev/null)" -c core.fsmonitor=false rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    unstaged=$(git -C "$cwd" status --porcelain 2>/dev/null | grep -c "^.[^ ]" || true)
    staged=$(git -C "$cwd" status --porcelain 2>/dev/null | grep -c "^[^ ]" || true)
    flags=""
    [ "$unstaged" -gt 0 ] && flags="${flags}?"
    [ "$staged" -gt 0 ] && flags="${flags}+"
    git_info=" $branch$flags"
  else
    git_info=""
  fi
fi

# --- model ---
model=$(echo "$input" | jq -r '.model.display_name // empty')

# --- context progress bar ---
ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$ctx_used" ]; then
  ctx_bar=$(make_bar "$ctx_used" 10)
  ctx_pct=$(awk "BEGIN { printf \"%.0f\", $ctx_used }")
  ctx_section=" ctx:[${ctx_bar}]${ctx_pct}%"
else
  ctx_section=""
fi

# --- session (5-hour rate limit) progress bar ---
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
if [ -n "$five_pct" ]; then
  five_bar=$(make_bar "$five_pct" 10)
  five_int=$(awk "BEGIN { printf \"%.0f\", $five_pct }")
  session_section=" 5h:[${five_bar}]${five_int}%"
else
  session_section=""
fi

# --- render ---
# cwd in bold blue, model in dim magenta, bars in dim cyan.
# The topic position always stands out in bold bright amber so the session
# title is unmistakable regardless of source. Auto-generated topics additionally
# get a ✦ marker to distinguish them from an explicit /rename name or the
# git-branch fallback.
printf "\033[1;34m%s\033[0m" "$display_cwd"
if [ "$is_auto" = 1 ]; then
  printf "\033[1;38;5;214m ✦%s\033[0m" "$git_info"
else
  printf "\033[1;38;5;214m%s\033[0m" "$git_info"
fi
if [ -n "$model" ]; then
  printf "\033[38;5;243m | \033[0m\033[38;5;139m%s\033[0m" "$model"
fi
if [ -n "$ctx_section" ]; then
  printf "\033[38;5;73m%s\033[0m" "$ctx_section"
fi
if [ -n "$session_section" ]; then
  printf "\033[38;5;73m%s\033[0m" "$session_section"
fi
