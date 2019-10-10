///Watch the stdout of an executing command
module commands.outwatch;
import util.config;
import std.process;
import std.datetime;
import std.format;
import util.inform;
int command(inout BuildSpecification build)
{
    import std.stdio;
    auto timeMut = Clock.currTime;
    inform(format!"Outwatch executing -> %s"(build.exactCommand));
    auto pipe = pipeShell(build.exactCommand, Redirect.stdout | Redirect.stderr);

    auto output = pipe.stdout;
    
    while(!pipe.pid.tryWait.terminated)
    {
        import std.range : padRight, array;
        const startTime = Clock.currTime;

        
        const line = output.readln;  

        //N.B. line isn't stripped so \n is not required
        const dur = startTime - timeMut;
        const leftSide = format!"%d ms"(dur.total!"msecs").padRight(' ', 8).array;
        writef!"%s| %s"(leftSide, line);

        timeMut = startTime;
    }
    //Wait to finish
    pipe.pid.wait;
    return 0;
}


