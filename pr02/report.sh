#!/usr/bin/env bash
set -euo pipefail

top=0

if [[ "${1:-}" == "--top" ]]; then
    top="$2"
    shift 2
fi

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 [--top N] DIRECTORY LEVEL"
    exit 1
fi

directory="$1"
level="$2"

if [[ ! -d "$directory" ]]; then
    echo "Error: directory not found: $directory"
    exit 1
fi

if [[ ! "$level" =~ ^(ERROR|WARN|INFO)$ ]]; then
    echo "Error: level must be ERROR, WARN or INFO"
    exit 1
fi

printf "module count\n"

grep -h "$level" "$directory"/*.log 2>/dev/null |
awk -v level="$level" '
{
    for (i = 1; i <= NF; i++) {
        if ($i == level) {
            module = $(i + 1)
            count[module]++
            break
        }
    }
}
END {
    for (module in count)
        printf "%s %d\n", module, count[module]
}' |
sort -k2,2nr |
if (( top > 0 )); then head -n "$top"; else cat; fi
