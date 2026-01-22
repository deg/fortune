import random
import sys
from pathlib import Path

def get_fortunes():
    """Reads fortunes from the data directory."""
    data_dir = Path(__file__).parent / "data"
    fortunes = []

    if not data_dir.exists():
        return ["No fortunes found. Please ensure the 'data' directory exists in the package."]

    # We look for all files in the data directory. BSD fortune files usually don't have extensions.
    for data_file in data_dir.iterdir():
        if data_file.is_file() and not data_file.name.startswith("."):
            try:
                with open(data_file, "r", encoding="utf-8", errors="ignore") as f:
                    content = f.read()
                    # BSD fortune format: fortunes are separated by a '%' on a line by itself.
                    # We split by '\n%\n' to get individual fortunes.
                    parts = content.split("\n%\n")
                    # Clean up each fortune and filter empty ones
                    for part in parts:
                        cleaned = part.strip()
                        if cleaned and cleaned != "%":
                            fortunes.append(cleaned)
            except Exception as e:
                # Silently skip files that can't be read
                continue

    if not fortunes:
        return ["The fortune database is empty."]

    return fortunes

def main():
    if len(sys.argv) > 1 and sys.argv[1] in ["--help", "-h"]:
        print("Usage: fortune")
        print("Displays a random fortune from the BSD collection.")
        return

    fortunes = get_fortunes()
    print(random.choice(fortunes))

if __name__ == "__main__":
    main()
