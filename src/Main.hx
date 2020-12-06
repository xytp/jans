package src;

import sys.FileStat;
import sys.io.File;
import sys.FileSystem;

using Lambda;

class Main {
    static public function main() {
        var data = Sys.args()[0];
        var content = File.getContent(data);
        var obj: src.DataFormat = haxe.Json.parse(content);
        var files = getFiles(obj.path, obj.extension);
        Sys.println("Starting observation...");
        while (true) {
            var nfiles = getFiles(obj.path, obj.extension);
            for (fi in nfiles.keyValueIterator()) {
                var old = files[fi.key];
                if (old.mtime.getTime() != fi.value.mtime.getTime()) {
                    Sys.println("File change detected. Compiling...");
                    Sys.command(obj.command);
                    Sys.println("Done.");
                    files = nfiles;
                    break;
                }
            }
            Sys.sleep(obj.delay);
        }
    }

    static private function getFiles(path : String, extension: Array<String>) : Map<String, FileStat> {
        var dirs : Array<String> = [];
        var files = new Map<String, FileStat>();
        FileSystem.readDirectory(path)
            .iter(function (name: String) {
                var tpath = '${path}/${name}';
                var ext = name.split(".");
                if (FileSystem.isDirectory(tpath)) {
                    dirs.push(tpath);
                }
                else if (extension.has(ext[ext.length - 1])) {
                    var stat = FileSystem.stat(tpath);
                    files.set(tpath, stat);
                }
            }
        );
        dirs.iter(function (name: String) {
            for (fi in getFiles(name, extension).keyValueIterator()) {
                files.set(fi.key, fi.value);
            }
        });
        return files;
    }
}