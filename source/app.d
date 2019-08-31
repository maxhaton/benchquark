import std.stdio;
import std.getopt, std.file;


import driver;
import bobthebuilder;
import runners;
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
	

	writef!"Starting with %s in %s\n"(whichDriver, loc);

	const drive = getDriver(whichDriver, new stopwatchTime);

	foreach(t; execAndDiff(loc, drive)) {
		writef!"%s: \n\tsize -> %s\n"(t, t.size);
	}
	if(opts.helpWanted)
	{
		writeln("Imagine a manual here...");
	}


}
