module bobthebuilder;

import driver;
import std.stdio;
auto execAndDiff(string dir, const DriverRoot runner)
{
    import std.datetime;
    import std.file;
    import std.range, std.algorithm;
    const now = Clock.currTime();
    runner.exec();

    return dirEntries(dir, SpanMode.depth).filter!(x => x.isFile && timeLastModified(x) > now);
}