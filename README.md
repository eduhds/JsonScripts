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
  <command>               Specify the command alias/key

OPTIONS:
  --file <file>           Specify the json file, defaul is "./scripts.json"
  --silent                Silent mode
  -h, --help              Show help information.
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
