module driver.root;
import runner.root;
import runner.impl;
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