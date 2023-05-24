import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;

using Lambda;

class Jans extends mcli.CommandLine {
	private var now:Date = Date.now();

	private function AFileWasSaved(path:String, extension:Array<String>):Bool {
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

	/**
	 * runs the jans compilation process
	 */
	public function run(fileName:String = null):Void {
		var fileName = if (fileName == null) "./jans.config.json" else fileName;

		if (!FileSystem.exists(fileName)) {
			Sys.println('file ${fileName} does not exist');
			Sys.exit(0);
		}

		var content = File.getContent(fileName);
		var obj:DataFormat = haxe.Json.parse(content);

		Sys.println("Starting observation...");

		while (true) {
			if (AFileWasSaved(obj.path, obj.extension)) {
				Sys.println("File change detected. Compiling...");
				Sys.command(obj.command);
				Sys.println("Done.");
				now = Date.now();
			}

			Sys.sleep(obj.delay);
		}
	}

	/**
	 * initializes the config file
	 */
	public function init() {
		var content = '
{
    "path": "path-to-your-souce-code",
    "extension": ["your-code-extension-1", "your-code-extension-2"],
    "command": "your compile command",
    "delay": 1 
}
			';
		var fileName = "./jans.config.json";
		try {
			File.saveContent(fileName, content);
			Sys.println('config file saved in ${fileName}');
		} catch (e:Dynamic) {
			Sys.println('could not write ${fileName}');
		}
	}
}
