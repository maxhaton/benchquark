//Argument parsing and other mess
module util.argparse;
import util.inform;
import util.config;
import util.config;
import std.stdio;
import std.getopt;
import std.file;
import std.algorithm;

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
	string configName = ""; 
	bool useJson;

	auto optResult = getopt(args, config.passThrough, "j|json", &useJson, "c|config", &configName);

	//This pattern can be made into a uda at some point but the interface isn't fixed yet

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
	while(configName == "") {
		import std.string : strip;		
		writeln("Specify a configuration name");
		configName = readln().strip;
		
			
		
	}


	//Print some information about the loaded configurations
	{
		writef!"%d Configurations loaded\n"(config.rawBuilds.length);
		config.rawBuilds.map!(x => x.name).each!writeln;

	}
	const build = config.getBuildByString(configName);

	if(accept("outwatch")) {
		import commands.outwatch : command;
		try {
			command(build);
		} catch(Exception e)
		{
			("outwatch exception thrown: " ~ e.msg).alert;
		}
	}
	
	alert("No valid command given!");
	return 1;
}