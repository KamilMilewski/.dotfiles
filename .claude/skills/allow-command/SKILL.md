---
name: allow-command
description: >
  Diagnose why a Bash command triggered a Claude Code permission prompt and add
  the missing command(s) to the user allowlist in dotfiles, then commit & push.
  Use when the user asks to "allow" a command, "stop prompting" for something,
  "add a permission", "allowlist X", or asks why a command prompted for approval.
---

# allow-command

Stop a Bash command from triggering permission prompts by adding it to the
user-level allowlist, which lives in the dotfiles repo.

## How Claude Code permission matching works

A compound command (sub-commands joined by `&&`, `||`, `;`, `|`, or newlines) is
split into its constituent sub-commands. **Every** sub-command must match an
allow rule, or the whole block prompts. One unmatched sub-command forces the
entire command to ask — even if everything else is allowlisted and read-only.

Allow rules are glob patterns like `Bash(find *)` or `Bash(git commit *)`. They
are read from three scopes, all of which count:

- Project: `<repo>/.claude/settings.json`
- Project-local: `<repo>/.claude/settings.local.json`
- User: `~/.claude/settings.json`

Special case: a **leading `cd` in a compound command** triggers a prompt even
when the path is fine — it needs its own `Bash(cd *)` rule (or just drop the
`cd`, since Claude is invoked with the project as cwd).

## Workflow

1. **Identify the prompting command.** It's usually quoted in the conversation.
   Split it into sub-commands on `&&`, `||`, `;`, `|`, and newlines.

2. **Read all three allowlist scopes** (use absolute paths):
   - `cat <repo>/.claude/settings.json`
   - `cat <repo>/.claude/settings.local.json`
   - `cat ~/.claude/settings.json`

3. **Find the unmatched sub-command(s).** For each sub-command, check whether any
   `allow` entry's glob covers it. Report which ones fail — those are the cause.

4. **Choose the rule + scope.**
   - Pattern: prefer a tool-level glob like `Bash(<cmd> *)` (e.g. `Bash(find *)`).
     Add a bare `Bash(<cmd>)` too only if the command is sometimes run with no args.
   - Scope: **default to the user settings (dotfiles)** — that's the whole point
     here. Only use project `.claude/settings.local.json` if the command is
     clearly project-specific (e.g. `bin/rails db:migrate:with_data`).

5. **Edit the real dotfiles file, not the symlink.** `~/.claude/settings.json` is
   a symlink and the harness refuses to write through symlinks. Resolve it first:
   ```
   readlink -f ~/.claude/settings.json
   # → /home/kamil/Misc/dotfiles/.claude/settings.json
   ```
   Read that real path, then Edit it to add the new entry to `permissions.allow`.
   Keep entries grouped sensibly (read-only tools near each other).

6. **Commit and push to dotfiles.** The user wants these tracked in dotfiles:
   ```
   cd /home/kamil/Misc/dotfiles
   git add .claude/settings.json
   git commit -m "Allow <cmd> in Claude Code without permission prompt

   <why it was prompting>"
   git push
   ```
   Committing directly to `main` is the normal flow for this personal repo.
   End the commit message with the standard Co-Authored-By trailer.

## Notes

- This skill itself lives in `~/.claude/skills/` → symlinked into
  `/home/kamil/Misc/dotfiles/.claude/skills/`, so it's private to the user
  (tracked only in dotfiles) and never committed to any project repo.
- Don't allowlist genuinely destructive commands (`rm -rf`, `git push --force`,
  etc.) just to silence a prompt — flag those instead.
