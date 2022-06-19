# Jans


## Description

Jans is a tiny language-agnostic tool to automate compilation. Feed it with a json structure to describe your project and it will compile it automatically when it sees a change. Change detection of a file is based on the last modification date, so saving with no changes also counts.

## How to use

First, create a json file with a content like this :

```json
{
    "path": "path-to-your-souce-code",
    "extension": ["your-code-extension-1", "your-code-extension-2", "..."],
    "command": "your compile command",
    "delay": 1
}
```

Then `jans your-config.json`.

Alternatively, you can run jans through haxelib like this.

```
haxelib install jans
haxelib run jans your-config.json
```

With no config file provided, jans will try to open `jans.config.json`

Jans is complied with the use of jans itself, so if you have haxe, you can try it on this repo alone.

## How to build

Jans is entierly written in Haxe, so it should support most target with filesystem support, like java and cpp. To build, you only need a recent version of Haxe and then run `Haxe [target].hxml` with [target] currently being java, jvm or cpp.