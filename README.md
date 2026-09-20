# spacehog

[![ShellCheck](https://github.com/ddjain/spacehog/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/ddjain/spacehog/actions/workflows/shellcheck.yml)

Find what's hogging your disk space on macOS/Linux — read-only, zero deletes.

`spacehog` surveys the usual suspects (package manager caches, ML model
caches, browser caches, `node_modules`, Docker, Xcode) and prints them
sorted largest-first, so you know exactly what to clean up and how much
you'll get back.

## Is it safe to run?

Yes, but don't take our word for it — check for yourself, it's one file:

- **No `sudo`, ever.** The script never elevates privileges.
- **No network calls.** It doesn't phone home or fetch anything.
- **No writes or deletes.** It only calls `du`, `df`, `find`, and
  `docker system df` — all read-only. Grep the script for `rm`, `mv`, `>`,
  or `curl`/`wget` and you'll find none.
- **It's ~140 lines, plain Bash, nothing obfuscated.** Read the whole thing
  in under two minutes: [`spacehog.sh`](./spacehog.sh).
- **Linted in CI** — every push runs [ShellCheck](https://www.shellcheck.net/)
  (badge above).
- **Pinned releases.** Instructions below reference an immutable tagged
  commit, not the moving `main` branch, so what you run is what you audited.

## Recommended: download, inspect, then run

```sh
curl -fsSL https://raw.githubusercontent.com/ddjain/spacehog/v1.0.0/spacehog.sh -o spacehog.sh
less spacehog.sh          # read it — it's short
sha256sum spacehog.sh     # (or: shasum -a 256 spacehog.sh) — compare to the checksum below
chmod +x spacehog.sh
./spacehog.sh
```

**Expected SHA-256 for `v1.0.0`:**
```
38f29c4f944c17ba1c90f1130a220bdda7f2e1537e195ab8ceed58cd7cb97272
```

## Quick run (if you already trust it)

```sh
sh <(curl -fsSL https://raw.githubusercontent.com/ddjain/spacehog/v1.0.0/spacehog.sh)
```

Note this pulls the tagged `v1.0.0` version, not `main` — `main` can change;
the tag won't.

## Or clone and run

```sh
git clone https://github.com/ddjain/spacehog.git
cd spacehog
git checkout v1.0.0
chmod +x spacehog.sh
./spacehog.sh
```

## Options

```
Usage: spacehog.sh [options]

  --top N                  Items to show per section (default: 25)
  --node-modules-root DIR  Root to search for node_modules (default: $HOME)
  --depth N                Max search depth for node_modules (default: 6)
  -h, --help                Show this help and exit
```

## What it checks

- Overall volume usage (`df -h /`)
- `~/Library/Caches`, `~/.cache`, `~/Downloads`, `~/.Trash`
- Package manager caches: uv, pip, npm, Yarn, Homebrew, go-build, node-gyp,
  pyright, Playwright, Cargo, Gradle, Maven
- ML model caches: Hugging Face, Whisper, Torch, Ollama, LM Studio
- Docker (`docker system df`, or the Docker.app VM disk if the daemon isn't
  running)
- `node_modules` directories anywhere under your home directory
- Xcode DerivedData/Archives and CoreSimulator caches

macOS-only sections are automatically skipped (with a note) when run on
Linux.

## License

MIT
