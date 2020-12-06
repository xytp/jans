# Jans


## Description

Jans is a tiny language-agnostic tool to automate compilation. Feed it with a json structure to describe your project and it will compile it automatically when it sees a change. Change detection of a file is based on the last modification date, so saving with no changes also counts.

## How to use

First, create a json file with a content like this :

```json
{
    "path": "path-to-your-souce-code",
    "extension": "your-code-extension",
    "command": "your compile command",
    "delay": 1
}
```

Then, run the program in your cli with the path to the json as the first agrument.

## How to build

Jans is entierly written in Haxe, so it should support most target with filesystem support, like java and cpp. To build, you only need a recent version of Haxe and then run `Haxe [target].hxml` with [target] currently being java or cpp.