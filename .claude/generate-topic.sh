#!/bin/sh
#
# Stop-hook script: generate a short "topic" title for the current Claude Code
# session and write it to ~/.claude/session-topics/<session_id>. The statusline
# reads that file as a fallback when no explicit /rename name is set.
#
# Why: there is no native auto-title feature. This summarizes the transcript
# with Haiku (cheap, fast) so the statusline shows what the session is *about*
# instead of just the git branch.
#
# Design notes:
#   - Runs the LLM call DETACHED (&) so it never blocks the Stop event.
#   - Throttled: regenerates only when the topic is missing or every
#     REFRESH_EVERY assistant turns, so cost stays negligible.
#   - Recursion guard: the `claude -p` call we spawn would itself fire this
#     same Stop hook -> fork bomb. CLAUDE_TOPIC_GEN=1 makes the nested run
#     exit immediately.

# --- recursion guard: don't run inside the topic-generation subprocess ---
[ -n "$CLAUDE_TOPIC_GEN" ] && exit 0

REFRESH_EVERY=3
MODEL="claude-haiku-4-5-20251001"
DIR="$HOME/.claude/session-topics"

input=$(cat)
session_id=$(printf '%s' "$input" | jq -r '.session_id // empty')
transcript=$(printf '%s' "$input" | jq -r '.transcript_path // empty')

[ -z "$session_id" ] && exit 0
[ -z "$transcript" ] || [ ! -f "$transcript" ] && exit 0

mkdir -p "$DIR"
topic_file="$DIR/$session_id"
count_file="$DIR/$session_id.n"

# prune topic files untouched for 7+ days so the dir doesn't grow forever
find "$DIR" -type f -mtime +7 -delete 2>/dev/null

# --- throttle: regenerate only if missing or REFRESH_EVERY turns elapsed ---
current=$(jq -rs '[.[] | select(.type == "assistant")] | length' "$transcript" 2>/dev/null)
[ -z "$current" ] && current=0
last=$(cat "$count_file" 2>/dev/null || echo 0)
elapsed=$((current - last))

if [ -s "$topic_file" ] && [ "$elapsed" -lt "$REFRESH_EVERY" ]; then
  exit 0
fi

# claim this generation now so rapid Stop events don't spawn duplicates
printf '%s' "$current" >"$count_file"

# --- extract recent conversation text (last 20 text blocks) ---
convo=$(jq -rs '
  [ .[]
    | select(.type == "user" or .type == "assistant")
    | .message.content
    | if type == "string" then .
      elif type == "array" then ([.[] | select(.type == "text") | .text] | join(" "))
      else empty end
    | select(. != null and . != "")
  ] | .[-20:] | join("\n")
' "$transcript" 2>/dev/null | tail -c 4000)

[ -z "$convo" ] && exit 0

# --- generate the title in the background so we never block the Stop event ---
(
  # NOTE: the transcript MUST be embedded in the prompt, not piped via stdin.
  # `claude -p` run inside the repo largely ignores piped stdin and instead
  # introspects the working dir (branch, files) to answer "what is this
  # session about" -> topics came out as branch-name echoes / garbage. Putting
  # the text in the prompt and forbidding file inspection makes it summarize
  # exactly the transcript we hand it.
  prompt="Below is a transcript of a Claude Code session. Summarize ONLY what this transcript is about in 3 to 5 words, as a short lowercase title. Do not inspect any files or run commands. Output ONLY the title: no quotes, no punctuation, no trailing period, no preamble.

Transcript:
$convo"
  topic=$(CLAUDE_TOPIC_GEN=1 claude -p --model "$MODEL" "$prompt" 2>/dev/null \
    | head -n1 \
    | tr -d '"' \
    | sed 's/[[:space:]]*$//' \
    | cut -c1-48)
  if [ -n "$topic" ]; then
    printf '%s' "$topic" >"$topic_file.tmp" && mv "$topic_file.tmp" "$topic_file"
  fi
) </dev/null >/dev/null 2>&1 &

exit 0
