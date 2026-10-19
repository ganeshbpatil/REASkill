# re-lab

A structured workspace for reverse-engineering investigations driven by [REA](https://github.com/morluto/rea) and Claude Code.

```
re-lab/
├── CLAUDE.md              ← standing rules for every investigation
├── targets/               ← binaries, APKs, HAR captures (read-only, git-ignored)
│   └── MANIFEST.csv       ← hash, source and legal basis for every target
├── investigations/
│   ├── _template/         ← copied by scripts/New-Investigation.ps1
│   └── 2026-10-competitor-x/
│       ├── brief.md       ← question, scope, success criteria
│       ├── evidence/      ← REA outputs + LOG.md
│       └── report.md      ← findings + build spec
├── specs/                 ← reusable "how to build feature Y" docs (clean-room)
└── scripts/               ← intake + scaffolding (PowerShell)
```

## Setup (Windows)
```powershell
npm install -g rea-agents@6.4.0
rea setup                    # skill + client registration
rea doctor                   # expect at least one analysis engine to be healthy
claude mcp add --scope user rea -- rea mcp
git clone https://github.com/ganeshbpatil/REASkill C:\re-lab
```

## Flow
```powershell
.\scripts\Add-Target.ps1 -Path D:\downloads\competitor.apk -Source "Play Store v4.2.1" -Basis "competitive behaviour analysis; lawfully installed"
.\scripts\New-Investigation.ps1 -Slug competitor-x
# fill in brief.md, then in Claude Code:
#   "Run the investigation in investigations/2026-10-competitor-x per CLAUDE.md"
```
