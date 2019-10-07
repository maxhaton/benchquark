///Watch the stdout of an executing command
module commands.outwatch;
import util.config;
import std.process;
import std.datetime;
void command(inout BuildSpecification build)
{
    import std.stdio;
    auto timeMut = Clock.currTime;
    
    auto pipe = pipeShell(build.shellString, Redirect.stdout | Redirect.stderr);

    auto output = pipe.stdout;
    
    while(!output.eof)
    {
        const startTime = Clock.currTime;

        
        const line = output.readln;

        writef!"%s | %s"(startTime - timeMut, line);

        timeMut = startTime;
    }
    //Wait to finish
    pipe.pid.wait;
}


