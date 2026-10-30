# AGENTS.md

Guidance for AI coding agents working in this repository.

## What this repository is

`midea-lua` is a **data repository**, not an application. It collects Lua protocol
files (and some UI plugin bundles) for Midea smart appliances. These Lua files
encode and decode the binary control/query messages exchanged with each device,
translating between device byte streams and JSON. They are consumed by projects
such as [`midea-lan`](https://github.com/wuwentao/midea-lan) and related
Home Assistant / `msmart`-style tooling.

There is no build system, no test runner, and no application entry point. Do not
look for one. The "product" is the curated set of files under `lua/` and
`plugin/`, plus analysis notes under `docs/`.

## Repository layout

- `lua/0x<TYPE>/` — Lua protocol files grouped by device type byte. Each
  subdirectory is a two-hex-digit uppercase device type, e.g. `0xAC` (air
  conditioner), `0xCD` (heat-pump water heater), `0xC3`, `0xDB`, `0xEA`, etc.
- `plugin/` — Appliance UI plugin bundles (`.zip`). Some are extracted, e.g.
  `plugin/c3/T0xC3/` contains the unpacked JS/image assets of a plugin.
- `docs/` — Human- and tool-generated analysis of the protocols, e.g.
  `docs/ac_newprotocol_tags.md` catalogs 0xB1/0xB0 property tags.
- `README.md` — How to download these files with the `midealan` CLI.
- `LICENSE` — MIT.

## File naming conventions

Lua protocol files follow:

```
T_<SUBTYPE>_<TYPE>_<SN8-or-variant>_<VERSION-or-DATE>.lua
```

- `T` — fixed prefix.
- `<SUBTYPE>` — 4-digit device subtype, usually `0000` or `0008`.
- `<TYPE>` — two-hex-digit device type matching the parent directory (`AC`,
  `CD`, `44`, ...). The directory is `0x<TYPE>`; the filename uses bare `<TYPE>`.
- `<SN8-or-variant>` — the 8-char SN8 model code (e.g. `00000Q11`,
  `2530001N`, `RSJ000CB`) or a short numeric variant (e.g. `22`, `24`).
- `<VERSION-or-DATE>` — trailing protocol version or `YYYYMMDDNN` date stamp,
  when present.

Plugin bundles use `T0x<TYPE>_<DATE>.zip`; cloud-downloaded bundles may instead
carry an opaque server-assigned name.

**Preserve the original downloaded filename.** Do not rename files to "clean them
up" — the name carries the SN8 and version that identify the device build.
Place a new file in the `lua/0x<TYPE>/` directory matching its device type,
creating the directory if it does not yet exist.

## Lua file structure

The files are plain Lua (targeting Lua 5.1-era interpreters, no external deps
beyond `cjson`). A typical file defines:

- `local JSON = require "cjson"` plus `KEY_*`, `VALUE_*`, and `BYTE_*` constants.
- `jsonToData(jsonCmd)` — JSON control command → device byte string.
- `dataToJson(jsonCmd)` — device byte string → JSON status.
- Helpers: `jsonToModel`, `binToModel`, `getTotalMsg`, checksum/CRC routines
  (`makeSum`, `crc8_854`), and hex/string conversion utilities.

These are vendor-supplied, often minified or machine-formatted. **Do not
refactor, reformat, or "improve" existing protocol files.** Treat them as
received data. Only touch a Lua file when the user explicitly asks you to analyze
or fix a specific protocol behavior.

## Working rules for agents

- This repo's value is fidelity to the source. When adding files, add exactly
  what was downloaded — the intended protocol/plugin files and nothing else.
- Encoding: UTF-8 without BOM. Line endings: Unix (LF). Code comments in English.
- When writing analysis or docs, put them under `docs/` as Markdown. Only create
  Markdown files when the user asks for them.
- Do not add a build system, linter config, or CI unless the user requests it.
- Network downloads use the `midealan` CLI (see `README.md`). Follow the user's
  mirror/proxy policy for any package installs; keep such settings scoped to the
  single command and never persist them to global config.

## Git and PR conventions

- Default branch: `main`. Remote: `git@github.com:wuwentao/midea-lua.git`.
- Never commit or push unless the user explicitly asks.
- Push feature work to a new branch, not directly to `main`.
- Commit messages follow Conventional Commits with an optional device-type or
  area scope, e.g.:
  - `feat(lua): add M0200008 fan-light protocol`
  - `feat(44): add ZKP-3INCH01 Lua protocol`
  - `fix(dc): match manufacturer Lua download`
  - `refactor: update lua file by device type dir`
- Keep PRs focused: only the intended protocol files and documentation.
- Before committing, confirm no unintended files (stray downloads, secrets) are
  staged. Prefer staging specific paths over `git add .`.

## Verification

There is nothing to build or test. "Verification" for a contribution means:

1. The file is placed in the correct `lua/0x<TYPE>/` directory for its type.
2. The filename is unchanged from the download.
3. The file is valid UTF-8, LF line endings, no accidental truncation.
4. Optionally, `luac -p <file>` or `lua -l <file>` to confirm it parses, if a
   Lua interpreter is available. Do not rewrite the file to make it parse.

---

_Reviewed by Claude Code (Claude Opus 4.8)._ 🤖
