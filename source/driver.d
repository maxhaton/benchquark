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
            break;
        case Drivers.make:
            return new MakeDriver(pack);
            break;
        default:
            assert(0);
    }
}
interface DriverRoot {
    ///Execute something in the shell
    string exec(string);
}

class DubDriver : DriverRoot {
    string exec(string argString = "")
    {
        return executeShell("dub" ~ argString).output;
    }
}

class MakeDriver : DriverRoot {
    string exec(string argString = "")
    {
        assert(0, "This is a stub");
    }
}