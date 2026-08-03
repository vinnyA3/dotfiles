#!/etc/profiles/per-user/qwerty_asdf/bin/python3
"""
Reload colors of all running standalone foot terminals from a Foot config.

Supports either:

    [colors]
or
    [colors-dark]

Only the following can be updated live:

- 16-color palette
- foreground
- background
- cursor color

Selection colors and cursor text color require restarting Foot.
"""

from __future__ import annotations

import argparse
from pathlib import Path
import sys


def load_colors(path: Path) -> dict[str, str]:
    """
    Parse the [colors] or [colors-dark] section from a Foot config.
    """

    colors = {}
    in_colors = False

    with path.open() as f:
        for raw in f:
            line = raw.strip()

            if not line or line.startswith("#"):
                continue

            if line in ("[colors]", "[colors-dark]"):
                in_colors = True
                continue

            if line.startswith("["):
                if in_colors:
                    break
                continue

            if not in_colors:
                continue

            if "=" not in line:
                continue

            key, value = line.split("=", 1)

            colors[key.strip()] = value.strip()

    if not colors:
        raise RuntimeError("No [colors] or [colors-dark] section found.")

    return colors


def build_escape_sequence(colors: dict[str, str]) -> str:
    seq = []

    #
    # 16-color palette
    #

    for i in range(8):
        key = f"regular{i}"
        if key in colors:
            seq.append(f"\033]4;{i};#{colors[key]}\007")

    for i in range(8):
        key = f"bright{i}"
        if key in colors:
            seq.append(f"\033]4;{i + 8};#{colors[key]}\007")

    #
    # Default foreground/background
    #

    if "foreground" in colors:
        seq.append(f"\033]10;#{colors['foreground']}\007")

    if "background" in colors:
        seq.append(f"\033]11;#{colors['background']}\007")

    #
    # Cursor
    #

    if "cursor" in colors:
        cursor = colors["cursor"].split()

        # Prefer the cursor text color if present.
        color = cursor[1] if len(cursor) > 1 else cursor[0]

        seq.append(f"\033]12;#{color}\007")    

    return "".join(seq)


def running_foot_ttys() -> list[Path]:
    """
    Find controlling TTYs of running standalone foot processes.
    """

    ttys = set()

    proc = Path("/proc")

    for pid in proc.iterdir():
        if not pid.name.isdigit():
            continue

        try:
            comm = (pid / "comm").read_text().strip()

            if comm != "foot":
                continue

            tty = (pid / "fd" / "0").resolve()

            if tty.exists() and tty.is_char_device():
                ttys.add(tty)

        except (FileNotFoundError, PermissionError, OSError):
            continue

    return sorted(ttys)


def reload_colors(sequence: str) -> int:
    updated = 0

    for tty in Path("/dev/pts").iterdir():
        try:
            if not tty.is_char_device():
                continue

            with tty.open("w") as f:
                f.write(sequence)

            updated += 1

        except (PermissionError, OSError):
            pass

    return updated


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Live reload colors for running foot terminals."
    )

    parser.add_argument(
        "theme",
        type=Path,
        help="Path to Foot theme/config file",
    )

    args = parser.parse_args()

    colors = load_colors(args.theme)

    sequence = build_escape_sequence(colors)

    updated = reload_colors(sequence)

    if updated == 0:
        print("No running foot terminals found.")
    else:
        print(f"Updated {updated} foot terminal(s).")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
