# Global instructions

- Never ask whether to run `standardrb` (or `standardrb --fix`). Just run it after editing Ruby and report the result. Don't ask for permission — it's allowlisted.
- Whenever you create a GitHub PR (via `gh`), always assign me to it in the same turn: `gh pr edit <number> --add-assignee @me` (my GitHub login is `KamilMilewski`). Applies to draft PRs too.
- For code searches, prefer the Grep tool over `grep | grep | head` in Bash — it runs on ripgrep, never touches the shell, and so never triggers a permission prompt. When Bash grep is genuinely needed, keep `|` out of quoted patterns (use repeated `-e` flags, not `grep "a|b"` or `grep -E "a|b"` — both embed a pipe in quotes and mis-parse the permission split, forcing a prompt on an otherwise-allowlisted command).
