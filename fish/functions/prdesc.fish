function prdesc
    echo "🔍 Checking if inside a git repository..."
    if not git rev-parse --show-toplevel >/dev/null 2>&1
        echo "❌ Not in a git repo" >&2
        return 1
    end
    echo "✅ Git repo detected"

    # detect PR template
    set -l repo_root (git rev-parse --show-toplevel)
    set -l template_file ""
    echo "📑 Looking for PR template..."
    for p in ".github/pull_request_template.md" "PULL_REQUEST_TEMPLATE.md"
        if test -f "$repo_root/$p"
            set template_file "$repo_root/$p"
            echo "✅ Found PR template at $p"
            break
        end
    end
    if test -z "$template_file"
        echo "⚠️  No PR template found, will use default headings"
    end

    # find default branch
    echo "🔍 Detecting default branch..."
    set -l default_remote_head (git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null)
    set -l default_branch (string replace -r '^origin/' '' -- "$default_remote_head")
    if test -z "$default_branch"
        if git show-ref --verify --quiet refs/remotes/origin/main
            set default_branch "main"
        else if git show-ref --verify --quiet refs/remotes/origin/master
            set default_branch "master"
        else
            echo "❌ Could not detect default branch" >&2
            return 1
        end
    end
    echo "✅ Default branch detected: $default_branch"

    # diff
    echo "🔄 Computing diff against $default_branch..."
    set -l base (git merge-base HEAD "origin/$default_branch" 2>/dev/null)
    if test -z "$base"
        echo "❌ Could not determine merge-base with origin/$default_branch" >&2
        return 1
    end

    # Exclude cassette files from diff (they're large and not useful for PR context)
    set -l diff (git diff --unified=0 --no-color $base...HEAD -- ':!spec/fixtures/cassettes')
    if test -z "$diff"
        echo "ℹ️  No changes vs $default_branch" >&2
        return 1
    end
    echo "✅ Diff collected"

    # branch
    set -l current_branch (git rev-parse --abbrev-ref HEAD)
    echo "📌 Current branch: $current_branch"

    # check if PR already exists
    echo "🔍 Checking if PR already exists..."
    if gh pr view >/dev/null 2>&1
        echo "⚠️  PR already exists for this branch:"
        gh pr view --web
        return 0
    end
    echo "✅ No existing PR found"

    # extract JIRA ticket from branch name
    echo "🎫 Extracting JIRA ticket from branch name..."
    set -l jira_ticket (string match -r '^[A-Z]+-[0-9]+' $current_branch)
    if test -z "$jira_ticket"
        echo "⚠️  Warning: Could not extract JIRA ticket from branch name"
    else
        echo "✅ JIRA ticket: $jira_ticket"
    end

    # build prompt
    echo "📝 Building Copilot prompt..."
    set -l prompt "You write Pull Request titles and descriptions from git diffs.

OUTPUT FORMAT (follow exactly):
1. First line: PR title as \"[$jira_ticket] - <concise summary>\"
2. Second line: blank
3. Remaining lines: PR body following the template EXACTLY as provided

RULES:
- Use the PR template headings exactly as provided - do not modify, add, or remove any sections
- Include JIRA link in the body: https://doximity.atlassian.net/browse/$jira_ticket
- Be concise: short sentences, bullet points
- Only describe what the diff actually changes
- If a section doesn't apply, write 'N/A'
- Keep under 300 words
- Output ONLY the title and body - no preamble, commentary, or closing remarks

CONTEXT:
- Repository default branch: $default_branch
- Current branch: $current_branch
- JIRA ticket: $jira_ticket
"

    if test -n "$template_file"
        set prompt "$prompt\nPR Template:\n"(cat "$template_file")"\n"
    else
        set prompt "$prompt\n(No template found. Use sections: Summary, Changes, Motivation, Risks, Test Plan, Rollout, Checklist.)\n"
    end

    set prompt "$prompt\nGit Diff (unified=0):\n```diff\n$diff\n```"

    # call Copilot CLI and save output
    echo "🤖 Sending prompt to Copilot..."
    set -l temp_file (mktemp)
    copilot -p "$prompt" --allow-all-tools > "$temp_file"

    if test $status -ne 0
        echo "❌ Copilot CLI failed" >&2
        rm -f "$temp_file"
        return 1
    end
    echo "✅ Copilot response received"

    # extract title (first line) and body (rest)
    set -l pr_title (head -n 1 "$temp_file")
    # Skip title and blank line, keep rest as-is in the temp file for now
    tail -n +3 "$temp_file" > "$temp_file.body"

    # Clean up AI response artifacts from the body file directly
    # Remove common prefixes/suffixes that Copilot might add
    sed -E -i '' '
        /^(Here is|Here'\''s) (the|a) (PR|pull request|draft)/Id
        /^I'\''ve (created|prepared|written)/Id
        /^Based on (the diff|your changes)/Id
        /^Let me know if/Id
        /^Feel free to/Id
        /^Please (let me know|feel free)/Id
    ' "$temp_file.body"

    # Trim only leading/trailing blank lines, preserve internal formatting
    sed -i '' -e '/./,$!d' -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$temp_file.body"

    echo "📋 Creating PR with gh..."
    echo "Title: $pr_title"

    # Ask if this should be a draft PR
    echo ""
    read -P "Is this a draft PR? (y/n): " -l draft_response
    set -l draft_flag
    if test "$draft_response" = "y" -o "$draft_response" = "yes"
        set draft_flag "--draft"
        echo "✅ Will create as draft PR"
    end

    # use the cleaned body file for gh
    set -l body_file "$temp_file.body"

    # create PR with editor for final edits
    gh pr create --title "$pr_title" --body-file "$body_file" $draft_flag --editor
    set -l gh_status $status

    # cleanup
    rm -f "$temp_file" "$temp_file.body"

    if test $gh_status -eq 0
        echo "✅ PR created successfully!"

        # Ask for code review
        echo ""
        read -P "Would you like to request a code review? (y/n): " -l response
        if test "$response" = "y" -o "$response" = "yes"
            echo "🤖 Requesting code review..."
            gh pr comment --body "doxbot cr"
            if test $status -eq 0
                echo "✅ Code review requested!"
            else
                echo "❌ Failed to request code review" >&2
            end
        end
    else
        echo "❌ Failed to create PR" >&2
        return 1
    end
end
