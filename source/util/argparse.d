module util.argparse;
import util.inform;
import util.config;
import std.stdio;
import std.getopt;
import std.file;
struct Program {

}
///Ugly argument parsing, no attempt at abstraction
int argParse(string[] args)
{
    
	//Skip exe location
	size_t stat = 1;
	string curTok(size_t tmp = stat)
        in(stat <= args.length, "Index out of bounds, no more arguments")
    {
		return args[tmp];
	}
	bool accept(string tmp)
	{
	
		if(stat == args.length) return false;
		if(args[stat] == tmp) {
			++stat;
			return true;
		} else {
			return false;
		}
	}
	//Config to use
	string configName; 
	bool useJson;

	auto optResult = getopt(args, config.passThrough, "j|json", &useJson, "c|config", &configName);

	
	//Counter doesn't need a config file
	if(accept("counter")) {	
		import commands.featurecount : command;
		try {
			command(useJson, args[1..$]).writeln;
		} catch(Exception e)
		{
			inform(e.msg);
		}
		

		return 0;
	}


	//Everything needing config file goes past here
	if(!exists("bq.json"))
		alert("No config file found");
	
	const config = loadConfig("bq.json");

	const build = config.getBuildByString(configName);

	
	
	alert("No valid command given!");
	return 1;
}