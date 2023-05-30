import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;

using Lambda;

class Jans extends mcli.CommandLine {
	private var now:Date = Date.now();

	private function AFileWasSaved(path:String, extensions:Array<String>, excludes:Array<String>):Bool {
		var filePaths = FileSystem.readDirectory(path);

		for (filePath in filePaths) {
			var trueFilePath = '${path}/${filePath}';
			if (excludes.contains(trueFilePath)) {
				continue;
			}

			if (!FileSystem.isDirectory(trueFilePath) && (extensions.contains("*") || extensions.contains(Path.extension(trueFilePath)))) {
				if (FileSystem.stat(trueFilePath).mtime.getTime() > now.getTime()) {
					return true;
				}
			}

			if (FileSystem.isDirectory(trueFilePath)) {
				if (AFileWasSaved(trueFilePath, extensions, excludes)) {
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
			for (rule in obj.rules) {
				if (AFileWasSaved(rule.path, rule.extensions, rule.excludes)) {
					Sys.println('File change detected for rule "${rule.name}". Compiling...');

					var commands = rule.command.copy();
					Sys.command(commands.shift(), commands);

					Sys.println("Done.");
					now = Date.now();
				}
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
	"rules": [
		{
			"name": "the rule name",
			"path": "the path to check",
			"excludes": ["file to exclude 1", "directory to exclude 1"],
			"extensions": [
				"your file extension 1",
				"your file extension 2"
			],
			"command": [
				"your command",
				"your command parameter 1",
				"your command parameter 2"
			]
		}
	],
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
