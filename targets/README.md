# targets/

Raw inputs. **Read-only.** Git-ignored except this file and `MANIFEST.csv`.

- Add files only through `scripts/Add-Target.ps1`. It records the SHA-256 and sets the file to read-only.
- One row per file in `MANIFEST.csv`. A target with no row is out of bounds (CLAUDE.md §0).
