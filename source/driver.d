module driver;
import std.process;
import runners;
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
abstract class DriverRoot {
    
    this()
    {
        
    }
    Runner runWithThis;
    ///Execute something in the shell
    const string exec(string[] arg = []);
}

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