#!/usr/bin/env bash

input=$(cat)

# --- Directory ---
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""')
[ -z "$cwd" ] && cwd=$(pwd)
dir=$(basename "$(echo "$cwd" | tr '\\' '/')")

# --- Context % ---
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty' 2>/dev/null)
if [ -n "$used_pct" ]; then
    context_str=$(printf "%.0f%%" "$used_pct")
else
    context_str="0%"
fi

# --- Git branch ---
git_branch=""
cwd_unix=$(echo "$cwd" | tr '\\' '/')
if [ -n "$cwd_unix" ] && git -C "$cwd_unix" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git_branch=$(git -C "$cwd_unix" -c core.hooksPath=/dev/null symbolic-ref --short HEAD 2>/dev/null \
        || git -C "$cwd_unix" rev-parse --short HEAD 2>/dev/null)
fi

# --- Elapsed time of last command ---
# Uses millisecond precision via date +%s%3N (GNU date / MSYS2).
# Format rules:
#   < 1000 ms  → "Xms"   (e.g. "342ms")
#   1s – 59s   → "Xs"    (e.g. "5s")
#   1m – 59m   → "Xm Ys" (e.g. "2m 30s")
#   >= 1h      → "Xh Ym" (e.g. "1h 5m")
transcript=$(echo "$input" | jq -r '.transcript_path // empty')
elapsed_str=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
    # Try millisecond-precision mtime (GNU stat on Linux/MSYS2)
    mtime_ms=$(stat -c %Y000 "$transcript" 2>/dev/null)
    # stat -c %Y gives seconds; append 000 for ms baseline, then try %y for sub-second
    mtime_ns=$(stat -c %y "$transcript" 2>/dev/null)
    if [ -n "$mtime_ns" ]; then
        # Extract fractional seconds field (e.g. "2026-03-01 12:34:56.789012345 +0000")
        frac=$(echo "$mtime_ns" | grep -oP '(?<=\.)\d+')
        if [ -n "$frac" ]; then
            ms_part=$(echo "$frac" | cut -c1-3)
            # Remove leading zeros for arithmetic
            ms_part=$(echo "$ms_part" | sed 's/^0*//')
            [ -z "$ms_part" ] && ms_part=0
            epoch_s=$(stat -c %Y "$transcript" 2>/dev/null)
            mtime_ms=$(( epoch_s * 1000 + ms_part ))
        fi
    fi

    now_ms=$(date +%s%3N 2>/dev/null)
    # Fallback: if date +%s%3N is unsupported (returns literal), use seconds only
    if ! echo "$now_ms" | grep -qE '^[0-9]+$'; then
        now_ms=$(( $(date +%s) * 1000 ))
    fi

    elapsed_ms=$(( now_ms - mtime_ms ))
    [ "$elapsed_ms" -lt 0 ] && elapsed_ms=0

    if [ "$elapsed_ms" -lt 1000 ]; then
        elapsed_str="${elapsed_ms}ms"
    else
        elapsed_s=$(( elapsed_ms / 1000 ))
        if [ "$elapsed_s" -lt 60 ]; then
            elapsed_str="${elapsed_s}s"
        elif [ "$elapsed_s" -lt 3600 ]; then
            m=$(( elapsed_s / 60 ))
            s=$(( elapsed_s % 60 ))
            elapsed_str="${m}m ${s}s"
        else
            h=$(( elapsed_s / 3600 ))
            m=$(( (elapsed_s % 3600) / 60 ))
            elapsed_str="${h}h ${m}m"
        fi
    fi
fi

# --- Assemble left-aligned statusline ---
# Format: dir [branch] | context% | HH:MM:SS | elapsed (elapsed hidden when absent)
current_time=$(date +%H:%M:%S)

if [ -n "$git_branch" ]; then
    out="${dir} [${git_branch}] | ${context_str} | ${current_time}"
else
    out="${dir} | ${context_str} | ${current_time}"
fi

[ -n "$elapsed_str" ] && out="${out} | ${elapsed_str}"

printf "%s" "$out"
