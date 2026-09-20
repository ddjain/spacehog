# spacehog

Find what's hogging your disk space on macOS/Linux — read-only, zero deletes.

`spacehog` surveys the usual suspects (package manager caches, ML model
caches, browser caches, `node_modules`, Docker, Xcode) and prints them
sorted largest-first, so you know exactly what to clean up and how much
you'll get back.

It never deletes or modifies anything — it only runs `du`, `df`, and `find`.

## Run it directly (no clone needed)

```sh
sh <(curl -fsSL https://raw.githubusercontent.com/ddjain/spacehog/main/spacehog.sh)
```

## Or clone and run

```sh
git clone https://github.com/ddjain/spacehog.git
cd spacehog
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
