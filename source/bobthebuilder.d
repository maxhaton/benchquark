module bobthebuilder;

import driver;
import std.stdio;
import std.file;
auto execAndDiff(string dir, const DriverRoot runner)
    in(dir.exists && dir.isDir)
{
    import std.datetime;
    
    import std.range, std.algorithm;
    const now = Clock.currTime();
    runner.exec();
    return dirEntries(dir, SpanMode.depth).filter!(x => !x.isDir && timeLastModified(x) > now);
}