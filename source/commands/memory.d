///Collects massif data for a given command, (and parses it)
module commands.memory;

import util.statman;
import util.owns;
import util.config;

StatManager* command(inout BuildSpecification build, string[] args)
{
    import std.process, std.path, std.file;
    string fileLocation = buildPath(".benchquark", "memory", build.name);
    auto stats = new StatManager("memory");
    fixSubDir("memory");

    //executeShell(format!"valgrind --tool=massif --massif-out-file=%s %s"(fileLocation, build.exactCommand));

    parseMassifOutput(readText(fileLocation), stats);
    return stats;
}


void parseMassifOutput(string fileContent, StatManager* stats)
{
    import std.format, std.stdio;
    struct Header {
        string desc;
        string cmd;
        char time_unit;
        //Better be in instructions, else we're fucked
        invariant(time_unit == 'i');
        void atomsOut(T)(auto ref T x)
        {
            x.setAtom("desc", desc);
            x.setAtom("cmd", cmd);
            x.setAtom("time_unit", time_unit);
        }
    }
    string theRest;
    Header header;
    {
        alias _ = header;
        fileContent
        .formattedRead!"desc: %s\ncmd: %s\ntime_unit: %c\n#-----------\n%s"(_.desc, _.cmd, _.time_unit, theRest);
    }

    header.atomsOut(stats);




    immutable snapFormat = 
"snapshot=%d\n#-----------\ntime=%d\nmem_heap_B=%d\nmem_heap_extra_B=%d\nmem_stacks_B=%d\nheap_tree=%s#-----------\n%s";
    struct Snapshot {
        ulong snapshot;
        ulong time;
        ulong mem_heap_B;
        ulong mem_heap_extra_B;
        ulong mem_stacks_B;
        //Level of heap detail
        string heapData;
    }
    ulong count = 0;
    
    while(theRest != "")
    {
        if(count)
            writef!"\r%d Snapshots counted"(++count);
        else
            writef!"%d Snapshots counted"(++count);
        Snapshot theShot;
        alias _ = theShot;
        try {
            theRest.formattedRead!snapFormat(_.snapshot, _.time,
                                         _.mem_heap_B, _.mem_heap_extra_B,
                                         _.mem_stacks_B, _.heapData, theRest);
        } catch(Exception e)
        {
            import util.inform;
            //inform(e.msg);
            
            theRest = "";
            //This is a hack until parsed properly (let it fail in lieu of checking for EOF)   
        }
        auto arr = stats.initArray("samples");
        with(arr.bump)
        {
            setAtom("snapshot", _.snapshot);
            setAtom("time", _.time);
            setAtom("mem_heap_B", _.mem_heap_B);
            setAtom("mem_heap_extra_B", _.mem_heap_extra_B);
            setAtom("mem_stacks_B", _.mem_stacks_B);
            category("heapData").setAtom("winkWink", "notImplementedYet");
        }
        
    }
    //Correct for the counter above
    writeln("");
}