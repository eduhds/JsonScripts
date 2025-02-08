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
USAGE: jnss <command> [--file <file>] [--verbose] [<arguments> ...] [-var <var> ...]

ARGUMENTS:
  <command>               init|list|<alias> Specify a builtin command or a command alias from scripts.json
  <arguments>             Command arguments

OPTIONS:
  -f, --file <file>       Specify the json file, default is "./scripts.json"
  --verbose               Verbose mode
  -var <var>              Specify multiple key-value pairs in the format 'key=value'.
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
jnss init

# List available scripts
jnss list

# Run a command by alias
jnss hello

# Run a command from a scripts.json placed in another location
jnss hello --file /path/to/scripts.json

# Passing command line args
jnss foo -- --bar

# Passing variables (will override one if already exists in .json file)
jnss hello -var 'name=world'
```

## Development

### Run

```sh
swift run jnss hello
```

### Build

```sh
# Build for release
swift run jnss build
# Deploy GitHub release
swift run jnss release -var 'tag=<tag here>' -- .build/release/jnss*.tar.gz
```

## License

[GPL-3.0 license](./LICENSE.txt)

## Credits/Thanks

- [apple/swift-argument-parser](https://github.com/apple/swift-argument-parser)
- [jordanbaird/Prism](https://github.com/jordanbaird/Prism)
