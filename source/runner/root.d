module runner.root;

///UDA to tag all runners, automatically added to list of requirements
immutable struct RunnerRequires
{
    ///Either name of tool in path or tool 
    string tool;
}

interface Runner
{
    RunnerResult execute(string[] args) const;
}

const interface RunnerResult
{
    ///Dump the data, not neccessarily machine readable
    //string rawString();
    string prettyString();
    alias prettyString this;

}
///Get runners from group, check whether what they call is in path if applicable or exists as an absolute path
bool checkRunners(alias group)(bool shout)
{
    import std.traits;
    import std.process : environment;
    import std.string : split;
    import std.path;
    import std.file : exists;

    const PATH = environment.get("PATH");

    version (Posix) char sep = ':';
    version (Windows) char sep = ';';

    const pathLocations = PATH.split(sep);

    alias runnerSymbols = getSymbolsByUDA!(group, RunnerRequires);

    foreach (uda; runnerSymbols)
    {
        bool succ = true;
        foreach (runReq; getUDAs!(uda, RunnerRequires))
        {

            const progPath = runReq.tool;
            if(progPath == "")
                continue;
            

            if (isAbsolute(progPath))
            {
                if (!progPath.exists)
                    succ = false;
            }
            else
            {
                foreach (locs; pathLocations)
                {
                    if (!buildPath(locs, progPath).exists)
                        succ = false;
                }
            }
            if (!succ)
            {
                if (shout)
                    throw new Exception(progPath ~ " missing");
                return false;
            }
        }

    }
    return true;
}
