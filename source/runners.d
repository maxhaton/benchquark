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