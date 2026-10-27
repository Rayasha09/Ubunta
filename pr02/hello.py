#!/usr/bin/env python3

import sys
from pathlib import Path


def main():
    if len(sys.argv) != 2:
        print(f"Usage: python3 {sys.argv[0]} LOG_FILE")
        return 1

    log_path = Path(sys.argv[1])

    if not log_path.is_file():
        print(f"Error: file not found: {log_path}")
        return 1

    try:
        with log_path.open("r", encoding="utf-8") as log_file:
            for line_number, line in enumerate(log_file, start=1):
                print(f"{line_number}: {line}", end="")
    except OSError as error:
        print(f"Error reading file: {error}", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
