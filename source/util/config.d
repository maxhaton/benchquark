///Load JSON config file
module util.config;
import util.inform;

abstract class BuildSpecification
{
    ///User defined named of thing from config file
    string name;
    ///Exact string as if executed on shell
    string exactCommand;
    string[] programAndArgs;
    this(string sName, string sShellString, string[] args = null)
    {
        name = sName;
        exactCommand = sShellString;
        programAndArgs = args;
    }
}
///Build something on the shell, not required to do anything in particular
class RawBuild : BuildSpecification
{
    this()
    {
        super(null, null, null);
    }

    this(string sName, string sShell)
    {
        super(sName, sShell, null);
    }
}

struct ConfigResult
{
    const(BuildSpecification) getBuildByString(string name) const
    {
        import std.algorithm : find;
        const res = rawBuilds.find!(x => x.name == name);

        if (!res.length)
            throw new Exception("Could not find build of name: " ~ name);
        return res[0];
    }

    RawBuild[] rawBuilds;
}

auto loadConfig(string name)
{
    import asdf;
    import std.file;

    const confString = readText(name);

    try
    {
        const output = confString.deserialize!ConfigResult;
        return output;
    }
    catch (Exception e)
    {
        import std.format;

        inform("Error Parsing config file");

        alert(e.msg);
    }
    assert(0);
}
