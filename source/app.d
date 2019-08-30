import std.stdio;
import std.getopt, std.file;
import driver;
void main(string[] args)
{
	bool useColour;
	Drivers whichDriver;
	GetoptResult opts;
	string loc = getcwd;

	
	try {
		opts = getopt(args, config.required, "driver",  &whichDriver, "d|dir", &loc,  "colour", &useColour);
	} catch (Exception y)
	{
		writeln(y.msg);
		return;
	}
	

	writef!"Starting with %s in %s"(whichDriver, loc);

	if(opts.helpWanted)
	{
		writeln("Imagine a manual here...");
	}
}
