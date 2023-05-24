# Jans


## Description

Jans is a tiny language-agnostic tool to automate compilation. Feed it with a json structure to describe your project and it will compile it automatically when it sees a change. Change detection of a file is based on the last modification date, so saving with no changes also counts.

## How to use

First, type the command `jans --init` that will create a json file named `jans.config.json` with a content like this:

```json
{
    "path": "path-to-your-souce-code",
    "extension": ["your-code-extension-1", "your-code-extension-2", "..."],
    "command": "your compile command",
    "delay": 1 
}
```
Then change it depending of your project requirements.
The `delay` parameter sets the sleep time between each check, in seconds.

Then `jans --run your-config.json`.

Alternatively, you can run jans through haxelib like this.

```bash
haxelib install jans
haxelib run jans --init #to init your config
haxelib run jans --run your-config.json #to run your compilation
```

With no config file provided, jans will try to open `jans.config.json` in the current directory.

Jans is complied with the use of jans itself, so if you have haxe, you can try it on this repo alone.

## How to build

```haxe cpp.hxml```