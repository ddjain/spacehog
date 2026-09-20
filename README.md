# 🐷 spacehog

[![ShellCheck](https://github.com/ddjain/spacehog/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/ddjain/spacehog/actions/workflows/shellcheck.yml)

> **Your disk isn't full. Your caches are. Find out what's eating it.**

Your Mac says you have **30 GB left**. Storage Settings says
**"System Data: 180 GB."** But what exactly is using that space?

`spacehog` finds out — a lightweight, read-only disk space analyzer for
developers. It digs into the places modern dev environments quietly
accumulate hundreds of gigabytes: Docker images and build caches,
`node_modules`, package managers, ML models, Xcode data, language caches,
downloads, and more — then prints them sorted largest-first.

## Why spacehog?

Modern development machines accumulate a surprising amount of data:

```text
Docker images          85 GB
Docker build cache     42 GB
node_modules           31 GB
Hugging Face models    28 GB
Xcode DerivedData      17 GB
Homebrew caches         8 GB
Downloads               6 GB
────────────────────────────
Total                 217 GB
```

That's 217 GB of potentially reclaimable developer data hiding across your
machine. `spacehog` brings it together in one place.

## Read-only by design

It doesn't clean your machine. It doesn't delete anything. It doesn't
modify your files. It doesn't require `sudo`. It doesn't send your data
anywhere. It simply looks, measures, and reports.

> **spacehog tells you what is eating your disk. You decide what to feed it.**

## Is it safe to run?

Don't take our word for it — check for yourself, it's one file:

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

### Show only the biggest offenders

```sh
./spacehog.sh --top 10
```

### Customize the node_modules search

```sh
./spacehog.sh --node-modules-root ~/projects
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

- 🐳 **Docker** — images, containers, volumes & build cache
- 📦 **Node.js** — `node_modules`, npm, Yarn caches
- 🐍 **Python** — pip, uv caches
- 🦀 **Rust** — Cargo registry
- ☕ **Java** — Maven & Gradle caches
- 🤖 **AI / ML** — Hugging Face, Ollama, PyTorch, Whisper, LM Studio
- 🍎 **Xcode** — DerivedData, Archives & CoreSimulator
- 🍺 **Homebrew** — downloaded packages & caches
- 🎭 **Playwright** — browser binaries
- 📥 **Downloads** & 🗑️ **Trash**
- 🧰 Other developer caches & build artifacts (go-build, node-gyp, pyright)

macOS-only sections are automatically skipped (with a note) when run on
Linux.

## Contributing

Found another developer tool that secretly eats 50 GB? Add it to spacehog.
Contributions are welcome — especially detectors for developer tools,
package managers, build systems, and AI/ML frameworks.

## License

MIT
