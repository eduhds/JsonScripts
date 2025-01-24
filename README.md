# JsonScripts

![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![macOS](https://img.shields.io/badge/mac%20os-000000?style=for-the-badge&logo=macos&logoColor=F0F0F0)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

JsonScripts CLI.
Run scripts/shell snippets from JSON file definition.

## Install

Download executable from [releases](https://github.com/eduhds/JsonScripts/releases).

> Tip: Consider using [gspm](https://github.com/eduhds/gspm) to download and install assets from GitHub releases!

## Usage

```
USAGE: jsonscripts <command> [--file <file>] [--verbose] [<arguments> ...]

ARGUMENTS:
  <command>               init|list|<alias> Specify a builtin command or a command alias from scripts.json
  <arguments>             Command arguments

OPTIONS:
  -f, --file <file>       Specify the json file, default is "./scripts.json"
  --verbose               Verbose mode
  --version               Show the version.
  -h, --help              Show help information.
```

### Definition file format

```json
{
  "version": 1,
  "variables": {
    "name": "JsonScripts"
  },
  "scripts": {
    "hello": "echo 'Hello from {{name}}'"
  }
}
```

### Examples

```sh
# Generate a scripts.json
jsonscripts init

# List available scripts
jsonscripts list

# Run a command by alias
jsonscripts hello

# Run a command from a scripts.json placed in another location
jsonscripts hello --file /path/to/scripts.json

# Passing command line args
jsonscripts foo -- --bar
```

## Development

### Run

```sh
swift run jsonscripts hello
```

### Build

```sh
bash scripts/build.sh
```

## License

[GPL-3.0 license](./LICENSE.txt)

## Credits/Thanks

- [apple/swift-argument-parser](https://github.com/apple/swift-argument-parser)
- [jordanbaird/Prism](https://github.com/jordanbaird/Prism)
