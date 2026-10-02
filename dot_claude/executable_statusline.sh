#!/usr/bin/env bash
# Claude Code status line. Left: Starship's `$directory$character`. Right:
# Starship's git modules, the branch's PR, then cache, model, effort, context.
# Starship modules render from ~/.config/starship.toml, so the prompt and
# status line stay in sync.
unset STARSHIP_SHELL # plain ANSI, no shell-specific escape wrapping

eval "$(jq -r '@sh "
  cwd=\(.workspace.current_dir // .cwd)
  model=\(.model.display_name // "")
  effort=\(.effort.level // "")
  pct=\(.context_window.used_percentage // "" | if . == "" then . else floor end)
  pr_number=\(.pr.number // "")
  pr_url=\(.pr.url // "")
  pr_state=\(.pr.review_state // "")
  cache_seen=\(.prompt_cache.caching_observed // false)
  cache_warm=\(.prompt_cache.warm // false)
  cache_expires=\(.prompt_cache.expires_at // "")
"')"

cd "$cwd" 2>/dev/null || exit 0
dir=$(starship module directory)
git="$(starship module git_branch)$(starship module git_status)"

dim=$'\e[2m' reset=$'\e[0m'

pr=
if [[ -n $pr_number ]]; then
  case $pr_state in
    approved) color=$'\e[32m' ;;
    changes_requested) color=$'\e[31m' ;;
    *) color=$dim ;;
  esac
  label="#$pr_number${pr_state:+ ${pr_state//_/ }}"
  pr="$color"$'\e]8;;'"$pr_url"$'\a'"$label"$'\e]8;;\a'"$reset"
fi

# An expiry clock time rather than a countdown: the status line only re-runs on
# events (and at expiry), so a countdown would go stale while idle.
cache=
if [[ $cache_seen == true ]]; then
  if [[ $cache_warm == true && -n $cache_expires ]]; then
    cache="${dim}cache $(date -r "$cache_expires" +%H:%M)$reset"
  else
    cache=$'\e[33m'"cache cold$reset"
  fi
fi

claude="$dim$model${effort:+ · $effort}${pct:+ · $pct% ctx}$reset"
right=
for part in "$git" "$pr" "$cache" "$claude"; do
  [[ -n $part ]] && right+="${right:+  }$part"
done
left="${dir% } "$'\e[1;32m❯'"$reset"

# Terminal cells: strip ANSI and OSC 8 links, count emoji (🪾, 🔒) as two cells.
width() {
  perl -CSA -e '$_ = shift; s/\e\]8;;[^\a]*\a//g; s/\e\[[0-9;]*m//g; $w = length; $w++ while /[\x{1F000}-\x{1FFFF}]/g; print $w' "$1"
}

# Right-align using the terminal width; the margin absorbs the TUI's own inset.
right_margin=4
gap=$((${COLUMNS:-0} - $(width "$left") - $(width "$right") - right_margin))
((gap < 1)) && gap=1
printf '%s%*s%s\n' "$left" "$gap" '' "$right"
