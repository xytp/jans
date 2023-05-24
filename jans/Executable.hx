using Lambda;

class Executable {
	static public function main() {
		new mcli.Dispatch(Sys.args()).dispatch(new Jans());
	}
}
