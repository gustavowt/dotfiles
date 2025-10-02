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

    set -l diff (git diff --unified=0 --no-color $base...HEAD)
    if test -z "$diff"
        echo "ℹ️  No changes vs $default_branch" >&2
        return 1
    end
    echo "✅ Diff collected"

    # branch
    set -l current_branch (git rev-parse --abbrev-ref HEAD)
    echo "📌 Current branch: $current_branch"

    # build prompt
    echo "📝 Building Claude prompt..."
    set -l prompt "You write precise Pull Request descriptions from diffs.

Rules:
- Use the repo’s PR template headings exactly if provided.
- Be direct. Short sentences and bullet points.
- No filler words, fluff, or marketing language.
- Only describe what the diff changes and why it’s needed.
- If a section doesn’t apply, write 'N/A'.
- Keep it under 300 words.
- The jira issue key is on the $current_branch. collect it and replace with https://doximity.atlassian.net/browse/{ISSUE-KEY} in Jira link section.

Repository default branch: $default_branch
Current branch: $current_branch
"

    if test -n "$template_file"
        set prompt "$prompt\nPR Template:\n"(cat "$template_file")"\n"
    else
        set prompt "$prompt\n(No template found. Use sections: Summary, Changes, Motivation, Risks, Test Plan, Rollout, Checklist.)\n"
    end

    set prompt "$prompt\nGit Diff (unified=0):\n```diff\n$diff\n```"

    # call Claude CLI
    echo "🤖 Sending prompt to Claude..."
    claude -p "$prompt"
    echo "✅ Claude response ready"
end
