package src;

import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;

using Lambda;

class Jans {
	static private var now:Date = Date.now();

	static public function main() {
		var args = Sys.args();
		var data = if (args.length > 0) args[0] else "./jans.config.json";

		var content = File.getContent(data);
		var obj:src.DataFormat = haxe.Json.parse(content);

		Sys.println("Starting observation...");

		while (true) {
			if (AFileWasSaved(obj.path, obj.extension)) {
				Sys.println("File change detected. Compiling...");
				Sys.command(obj.command);
				Sys.println("Done.");
			}
			now = Date.now();

			Sys.sleep(obj.delay);
		}
	}

	static private function AFileWasSaved(path:String, extension:Array<String>):Bool {
		var filePaths = FileSystem.readDirectory(path);

		for (filePath in filePaths) {
			var trueFilePath = '${path}/${filePath}';
			if (!FileSystem.isDirectory(trueFilePath) && extension.has(Path.extension(trueFilePath))) {
				if (FileSystem.stat(trueFilePath).mtime.getTime() > now.getTime()) {
					return true;
				}
			}
		}

		for (filePath in filePaths) {
			var trueFilePath = '${path}/${filePath}';
			if (FileSystem.isDirectory(trueFilePath)) {
				if (AFileWasSaved(trueFilePath, extension)) {
					return true;
				}
			}
		}

		return false;
	}
}
