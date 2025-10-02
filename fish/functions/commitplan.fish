function commitplan
    echo "🔍 Checking if inside a git repository..."
    if not git rev-parse --show-toplevel >/dev/null 2>&1
        echo "❌ Not in a git repo" >&2
        return 1
    end
    set -l repo_root (git rev-parse --show-toplevel)
    echo "✅ Git repo detected at $repo_root"

    # Collect unstaged status + lists
    echo "📋 Collecting unstaged changes (modified/deleted/untracked)..."
    set -l modified_files (git diff --name-only)
    set -l deleted_files  (git diff --name-only --diff-filter=D)
    set -l untracked_files (git ls-files --others --exclude-standard)

    if test (count $modified_files) -eq 0 -a (count $untracked_files) -eq 0
        echo "ℹ️  No unstaged changes found."
        return 0
    end

    echo "🧾 Building a concise diff summary (name-status)..."
    set -l name_status (git diff --name-status)

    # Collect per-file unified=0 diffs for modified/deleted files
    echo "🧩 Capturing per-file patches for modified/deleted files..."
    set -l per_file_patches ""
    for f in $modified_files
        set -l patch (git diff --unified=0 --no-color -- "$f")
        if test -n "$patch"
            set per_file_patches "$per_file_patches\n### FILE: $f\n```diff\n$patch\n```"
        end
    end

    # For untracked files, include a small header + first lines (no color)
    set -l untracked_snippets ""
    if test (count $untracked_files) -gt 0
        echo "🆕 Sampling content from untracked files (first ~200 lines each)..."
        for uf in $untracked_files
            if test -f "$uf"
                set -l headtxt (command head -n 200 -- "$uf" 2>/dev/null)
                set untracked_snippets "$untracked_snippets\n### UNTRACKED: $uf\n\`\`\`\n$headtxt\n\`\`\`"
            else if test -d "$uf"
                set untracked_snippets "$untracked_snippets\n### UNTRACKED DIR: $uf (directory)\n"
            end
        end
    end

    # Current branch for context
    set -l current_branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)

    # Optional style hint (set CONVENTIONAL_COMMITS=1 to enforce)
    set -l style_hint ""
    if test "$CONVENTIONAL_COMMITS" = "1"
        set style_hint "- Use Conventional Commits style for titles (feat:, fix:, chore:, refactor:, test:, docs:)."
    end

    echo "📝 Building request for Claude..."
    set -l prompt "You are a senior engineer who writes **excellent commit plans** from *unstaged* changes.

Goals:
- Decide if the current work should be split into multiple commits.
- For each suggested commit, list the files to include and provide:
  - A short, specific title (max 72 chars).
  - A concise body (wrap to ~72 cols, bullets allowed).
  - Exact git commands to stage and commit.
- Keep language direct. No filler or marketing tone.
$style_hint

Repository:
- Current branch: $current_branch

Unstaged summary (name-status):
\`\`\`
$name_status
\`\`\`

Modified/Deleted file patches (unified=0):
$per_file_patches

Untracked files (first ~200 lines shown, if applicable):
$untracked_snippets

Output format (strict):
1) Overall recommendation: Single commit or split (and why).
2) Commit Plan:
   - Commit N:
     - Title: <one line>
     - Body:
       <short bullets or 1–3 short paragraphs>
     - Files:
       <paths list>
     - Commands:
       \`\`\`bash
       git add <paths...>
       git commit -m \"<title>\" -m \"<body lines>\"
       \`\`\`
3) Notes: any ordering or cross-file dependency considerations.

Constraints:
- Only refer to files present above.
- Keep it short and objective.
- If a file’s content isn’t shown (dir/untracked large), still place it based on path/context and note assumptions.
- Do not add that was generated or co-authored by an AI."

    echo "🤖 Asking Claude for a commit plan..."
    claude -p "$prompt"
    echo "✅ Done."
end
function commitplan
    echo "🔍 Checking if inside a git repository..."
    if not git rev-parse --show-toplevel >/dev/null 2>&1
        echo "❌ Not in a git repo" >&2
        return 1
    end
    set -l repo_root (git rev-parse --show-toplevel)
    echo "✅ Git repo detected at $repo_root"

    # Collect unstaged status + lists
    echo "📋 Collecting unstaged changes (modified/deleted/untracked)..."
    set -l modified_files (git diff --name-only)
    set -l deleted_files  (git diff --name-only --diff-filter=D)
    set -l untracked_files (git ls-files --others --exclude-standard)

    if test (count $modified_files) -eq 0 -a (count $untracked_files) -eq 0
        echo "ℹ️  No unstaged changes found."
        return 0
    end

    echo "🧾 Building a concise diff summary (name-status)..."
    set -l name_status (git diff --name-status)

    # Collect per-file unified=0 diffs for modified/deleted files
    echo "🧩 Capturing per-file patches for modified/deleted files..."
    set -l per_file_patches ""
    for f in $modified_files
        set -l patch (git diff --unified=0 --no-color -- "$f")
        if test -n "$patch"
            set per_file_patches "$per_file_patches\n### FILE: $f\n```diff\n$patch\n```"
        end
    end

    # For untracked files, include a small header + first lines (no color)
    set -l untracked_snippets ""
    if test (count $untracked_files) -gt 0
        echo "🆕 Sampling content from untracked files (first ~200 lines each)..."
        for uf in $untracked_files
            if test -f "$uf"
                set -l headtxt (command head -n 200 -- "$uf" 2>/dev/null)
                set untracked_snippets "$untracked_snippets\n### UNTRACKED: $uf\n\`\`\`\n$headtxt\n\`\`\`"
            else if test -d "$uf"
                set untracked_snippets "$untracked_snippets\n### UNTRACKED DIR: $uf (directory)\n"
            end
        end
    end

    # Current branch for context
    set -l current_branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)

    # Optional style hint (set CONVENTIONAL_COMMITS=1 to enforce)
    set -l style_hint ""
    if test "$CONVENTIONAL_COMMITS" = "1"
        set style_hint "- Use Conventional Commits style for titles (feat:, fix:, chore:, refactor:, test:, docs:)."
    end

    echo "📝 Building request for Claude..."
    set -l prompt "You are a senior engineer who writes **excellent commit plans** from *unstaged* changes.

Goals:
- Decide if the current work should be split into multiple commits.
- For each suggested commit, list the files to include and provide:
  - A short, specific title (max 72 chars).
  - A concise body (wrap to ~72 cols, bullets allowed).
  - Exact git commands to stage and commit.
- Keep language direct. No filler or marketing tone.
$style_hint

Repository:
- Current branch: $current_branch

Unstaged summary (name-status):
\`\`\`
$name_status
\`\`\`

Modified/Deleted file patches (unified=0):
$per_file_patches

Untracked files (first ~200 lines shown, if applicable):
$untracked_snippets

Output format (strict):
1) Overall recommendation: Single commit or split (and why).
2) Commit Plan:
   - Commit N:
     - Title: <one line>
     - Body:
       <short bullets or 1–3 short paragraphs>
     - Files:
       <paths list>
     - Commands:
       \`\`\`bash
       git add <paths...>
       git commit -m \"<title>\" -m \"<body lines>\"
       \`\`\`
3) Notes: any ordering or cross-file dependency considerations.

Constraints:
- Only refer to files present above.
- Keep it short and objective.
- If a file’s content isn’t shown (dir/untracked large), still place it based on path/context and note assumptions."

    echo "🤖 Asking Claude for a commit plan..."
    claude -p "$prompt"
    echo "✅ Done."
end

