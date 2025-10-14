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
  - Ideally split commits between services/models/controllers changes even tough they are related
  - always agroup respective specs from each file in the same commit
  - you must keep commits small and focused
  - avoid mixing refactors with feature or bugfix changes
- For each suggested commit, list the files to include and provide:
  - A short, specific title (max 72 chars).
  - A concise body (wrap to ~72 cols, bullets allowed).
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

Output format (CRITICAL - STRICT ENFORCEMENT):
You MUST return ONLY a raw JSON object starting with { and ending with }.
NO markdown code fences (no \`\`\`json or \`\`\`).
NO explanatory text before or after the JSON.
NO additional formatting.
JUST the raw JSON object.

Required JSON structure:
{
  \"recommendation\": \"Brief explanation of single vs split commits\",
  \"commits\": [
    {
      \"title\": \"Commit title (max 72 chars)\",
      \"body\": \"Commit body (can use \\n for line breaks)\",
      \"files\": [\"path/to/file1\", \"path/to/file2\"]
    }
  ],
  \"notes\": \"Any ordering or dependency notes (optional)\"
}

Your response must start with { and end with }. Nothing else.

Constraints:
- Only refer to files present above.
- Keep it short and objective.
- If a file's content isn't shown (dir/untracked large), still place it based on path/context and note assumptions.
- Do not add that was generated or co-authored by an AI.
- Dont use backslashes in commit messages. like this: \`:attribute\`, do it like this: `attribute` instead."

    echo "🤖 Asking Claude for a commit plan..."
    set -l response (claude -p "$prompt")

    # Validate JSON response
    if not echo "$response" | jq empty 2>/dev/null
        echo "❌ Failed to get valid JSON response from Claude"
        echo "Response was:"
        echo "$response"
        return 1
    end

    set -l json_response "$response"

    echo "📋 Commit plan received. Parsing commits..."

    # Check if jq is available
    if not command -v jq >/dev/null 2>&1
        echo "❌ 'jq' is required but not installed. Please install it first."
        return 1
    end

    # Get commit count
    set -l commit_count (echo "$json_response" | jq -r '.commits | length')

    if test "$commit_count" -eq 0
        echo "ℹ️  No commits suggested."
        return 0
    end

    echo "✅ Found $commit_count commit(s) to process"
    echo ""

    # Show recommendation
    set -l recommendation (echo "$json_response" | jq -r '.recommendation')
    echo "💡 Recommendation: $recommendation"
    echo ""

    # Iterate through each commit
    for i in (seq 0 (math $commit_count - 1))
        set -l commit_title (echo "$json_response" | jq -r ".commits[$i].title")
        set -l commit_body (echo "$json_response" | jq -r ".commits[$i].body")
        set -l commit_files (echo "$json_response" | jq -r ".commits[$i].files[]")

        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "📝 Commit "(math $i + 1)" of $commit_count"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Title: $commit_title"
        echo ""
        echo "Files to stage:"
        for file in $commit_files
            echo "  - $file"
        end
        echo ""

        read -P "Stage files and open editor for this commit? [Y/n/q] " -n 1 confirm
        echo ""

        switch $confirm
            case q Q
                echo "⏸️  Aborted by user."
                return 0
            case n N
                echo "⏭️  Skipping this commit."
                continue
            case '*'
                # Proceed with commit (default is yes)
        end

        # Stage files
        echo "📦 Staging files..."
        for file in $commit_files
            if test -e "$file"
                git add "$file"
                echo "  ✓ $file"
            else
                echo "  ⚠️  $file (not found, skipping)"
            end
        end

        # Create temp file with commit message
        set -l temp_msg (mktemp)
        echo "$commit_title" > "$temp_msg"
        echo "" >> "$temp_msg"
        echo "$commit_body" >> "$temp_msg"

        # Open editor
        echo "✏️  Opening editor..."
        set -l editor $EDITOR
        if test -z "$editor"
            set editor (git config core.editor)
        end
        if test -z "$editor"
            set editor vim
        end

        eval $editor "$temp_msg"

        # Check if user wants to proceed with commit
        echo ""
        read -P "Proceed with commit? [Y/n] " -n 1 proceed
        echo ""

        if test "$proceed" = "n" -o "$proceed" = "N"
            echo "⏭️  Skipping commit (files remain staged)."
            rm "$temp_msg"
            continue
        end

        # Commit with edited message
        git commit -F "$temp_msg"
        set -l commit_status $status
        rm "$temp_msg"

        if test $commit_status -eq 0
            echo "✅ Commit successful!"
        else
            echo "❌ Commit failed with status $commit_status"
            return $commit_status
        end

        echo ""
    end

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ All commits processed!"

    # Show notes if any
    set -l notes (echo "$json_response" | jq -r '.notes // empty')
    if test -n "$notes"
        echo ""
        echo "📌 Notes: $notes"
    end
end
