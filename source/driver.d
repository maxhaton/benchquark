module driver;
import std.process;
///Supported build drivers
enum Drivers  {
    dub, 
    make
}
DriverRoot getDriver(T...)(Drivers opt, T pack)
{
    switch(opt) {
        case Drivers.dub:
            return new DubDriver(pack);
            
        case Drivers.make:
            return new MakeDriver(pack);
            
        default:
            assert(0);
    }
}
interface DriverRoot {
    ///Execute something in the shell
    const string exec(string arg = "");
}

class DubDriver : DriverRoot {
    const string exec(string argString = "")
    {
        return executeShell("dub --force" ~ argString).output;
    }
}

class MakeDriver : DriverRoot {
    const string exec(string argString = "")
    {
        assert(0, "This is a stub");
    }
}