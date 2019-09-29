module runner.impl;

import std.process : spawnProcess, wait;
import std.conv : to;
import runner.root;



class StringResult : RunnerResult {
    string rawString;
    this(string set) {
        rawString = set;
    }      
    string prettyString() const
    {
        return rawString;
    }
}
///Just run the command on the shell
@RunnerRequires("") class simplyRun : Runner
{
    ///Just run it on the shell
    RunnerResult execute(string[] fullCommand) const
    {
        import std.process : execute;

        return new StringResult(execute(fullCommand).output);
    }

}


///Fully wraps /usr/bin/time -v  output 
class PosixTimeResult : RunnerResult
{

    string prettyString() const 
    {
        return "unimpl";
    }
    ///Elapsed real time (in seconds).
    float realTime;
    ///Total number of CPU-seconds that the process spent in kernel mode.
    float kernelTime;
    ///Total number of CPU-seconds that the process spent in user mode.
    float userTime;
    ///Heuristic calculation of proportion of CPU dedicated to task
    float cpuProportion;

    ///Maximum resident set size of the process during its lifetime, in Kbytes.
    size_t maxPhysicalMemory;
    ///Average resident set size of the process, in Kbytes.
    size_t averagePhysicalMemory;
    ///Average total (data+stack+text) memory use of the process, in Kbytes.
    size_t averageTotalMemory;
    ///Average unshared data area, in Kbytes
    size_t averageUnsharedData;
    ///Average size of the process's unshared stack space, in Kbytes.
    size_t averageUnsharedStackSpace;
    ///Average size of the process's shared text space, in Kbytes
    size_t averageSharedTextSpace;
    ///System's page size, in bytes.  This is a per-system constant, but varies between systems.
    size_t systemPageSize;
    ///Major page faults
    size_t majorPageFaults;
    ///Number of minor, or recoverable, page faults.  These are faults for pages that are not valid but which have not yet  been claimed by other virtual pages.
    size_t minorPageFaults;
    ///Number of memory swaps
    size_t numberOfSwaps;
    ///Involuntary context switches
    size_t involuntaryContextSwitches;
    ///Number of waits
    size_t voluntaryContextSwitches;

    ///Number of filesystem inputs by the process.
    size_t filesystemInputs;
    ///Number of filesystem outputs by the process.
    size_t filesystemOutputs;
    ///Number of socket messages received by the process.
    size_t socketMessagesRecieved;
    ///Socket messages sent
    size_t socketMessagesSent;
    ///Number of signals delivered
    size_t numberOfSignals;
    ///Exit status 
    uint exitStatus;

    this(string timeOutput)
    {
        import std.format;

        try
        {
            //Well this is fun
            formattedRead!"%f;%f;%f;%f%;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d"(timeOutput,
                    realTime, kernelTime, userTime, cpuProportion,
                    maxPhysicalMemory, averagePhysicalMemory, averageTotalMemory,
                    averageUnsharedData,
                    averageUnsharedStackSpace,
                    averageSharedTextSpace,
                    systemPageSize, majorPageFaults, minorPageFaults, numberOfSwaps,
                    involuntaryContextSwitches, voluntaryContextSwitches,
                    filesystemInputs, filesystemOutputs,
                    socketMessagesRecieved, socketMessagesSent, numberOfSignals, exitStatus);
        }
        catch (FormatException e)
        {
            import util.inform;

            alert(e.msg);
        }

    }
}

///Timing and other non-pmc Data using /usr/bin/time
@RunnerRequires("/usr/bin/time") class posixTimer : Runner
{
    
    import std.file : exists;
    ///The format string passed to /usr/bin/time
    enum formatString = "%e;%S;%U;%P;%M;%t;%K;%D;%p;%X;%Z;%F;%R;%W;%c;%w;%I;%O;%r;%s;%k;%x";
    RunnerResult execute(string[] fullCommand) const
    {
        import std.string;
        import std.range;
        import std.process : execute;

        const res = execute(["/usr/bin/time", "-f", formatString] ~ fullCommand).output;
        const lastLine = res.split[$];
        return new PosixTimeResult(lastLine);
    }
}
