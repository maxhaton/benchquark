module runners;

interface Runner {
    string execute(string[] args) const;

}

///Just run the command on the shell
class simplyRun : Runner {
    ///Just run it on the shell
    string execute(string[] fullCommand) const
    {
        import std.process : execute;
        return execute(fullCommand).output;
    }

}


///Attempts to time a process based on a D stopwatch
class stopwatchTime : Runner {
    ///N.B. string return values will be exterminated
    string execute(string[] fullCommand) const {
        import std.process : spawnProcess, wait;
        import std.datetime.stopwatch;
        import std.conv : to;

        auto sw = StopWatch(AutoStart.no);
        auto tmp = spawnProcess(fullCommand);

        sw.start;
        tmp.wait;
        sw.stop;

        return sw.peek.to!string;
    }
}