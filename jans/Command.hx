class Command {
	public static function main() {
		var args = Sys.args();

		var userDir = args.pop();
		Sys.setCwd(userDir);

		new mcli.Dispatch(args).dispatch(new Jans());
	}
}
