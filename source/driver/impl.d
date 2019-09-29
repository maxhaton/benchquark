module driver.impl;
import driver.root;
import std.process;
import runner.impl;
import runner.root;
///Supported build drivers


class DubDriver : DriverRoot {
    this(Runner set)
    {
        runWithThis = set;
    }
    override const string exec(string[] argList = [])
    {
        return runWithThis.execute(["dub"] ~ ["--force"] ~ argList);
    }
}

class MakeDriver : DriverRoot {
    this(Runner set)
    {
        runWithThis = set;
    }
    override const string exec(string[] argString)
    {
        assert(0, "This is a stub");
    }
}