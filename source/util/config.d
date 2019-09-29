///Load JSON config file
module util.config;
import util.inform;
abstract class BuildSpecification {
    ///User defined named of thing from config file
    string name;
    ///Exact string as if executed on shell
    @property string shellString;
    @property string[] programAndArgs;
}
///Build something on the shell, not required to do anything in particular
class RawBuild : BuildSpecification {
    this(string sName, string sShell)
    {
        shellString = sShell;
        name = sName;
    }
}

struct ConfigResult {
    const(BuildSpecification) getBuildByString(string name)
    {
        import std.algorithm : find;
        const res = rawBuilds.find!(x => x.name = name);
        if(!res.length) throw new Exception("Could not find build of name: " ~ name);
        return res[0];
    }
    RawBuild[] rawBuilds;
}
auto loadConfig(string name)
{
    import asdf;
    import std.file;
    const confString = readText(name);
     
    try {
        const output = confString.deserialize!ConfigResult;
        return output;
    } catch(Exception e)
    {
        inform("Error Parsing config file");

        alert(e.msg);
    }
    assert(0);
}   