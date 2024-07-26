# JsonScripts

![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![macOS](https://img.shields.io/badge/mac%20os-000000?style=for-the-badge&logo=macos&logoColor=F0F0F0)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

JsonScripts CLI.
Run scripts/shell snippets from JSON file definition.

> Work in progress!

## Usage

```
USAGE: jsonscripts <command> [--file <file>] [--silent]

ARGUMENTS:
  <command>               init|list|<alias> Specify a builtin command or a command alias from scripts.json

OPTIONS:
  --file <file>           Specify the json file, default is "./scripts.json"
  --silent                Silent mode
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
