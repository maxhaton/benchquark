module commands.justbuild;
import util.config, util.statman, util.inform;
import std.file;

auto execAndDiff(const BuildSpecification buildThis)
{
    import std.datetime;
    import std.process;
    import std.range, std.algorithm;

    const now = Clock.currTime();
    executeShell(buildThis.exactCommand);
    return dirEntries(getcwd, SpanMode.depth).filter!(x => !x.isDir && timeLastModified(x) > now);
}

void elfData(T)(T x, string fileName)
{
    import std.conv : to;
    import elf;

    ELF tmp = ELF.fromFile(fileName);
    auto head = tmp.header;
    auto elfStuff = x.category("ELF");
    with (elfStuff)
    {
        setAtom("machineISA", head.machineISA);
        setAtom("objectFileType", head.objectFileType);
        foreach (section; tmp.sections)
        {
            with (elfStuff.category("sections").category(section.name))
            {
                setAtom("type", section.type.to!string);
                setAtom("address", section.address);
                setAtom("offset", section.offset);
                setAtom("flags", cast(ubyte) section.flags);
                setAtom("size", section.size);
                setAtom("entry size", section.entrySize);
                
            }
        }
    }

}

auto command(inout BuildSpecification build, string[] args)
{

    import std.getopt;
    import std.format : format;
    import std.stdio;
    import std.range;
    import std.algorithm;
    import std.datetime;
    import elf;

    const dir = getcwd;

    bool readElf = false;

    getopt(args, "elf|readElf", &readElf);

    inform(format!"Building %s in %s\n"(build.exactCommand, dir));

    import std.file;

    auto rawOutput = execAndDiff(build);

    auto stats = StatManager("build - " ~ build.name);

    auto data = stats.category("resultingFiles");

    stats.setAtom("builtIn", dir);
    auto output = rawOutput.array.sort!((x, y) => x.timeLastModified < y.timeLastModified);
    SysTime lastTime;
    //There is actually some output
    if(output.length) 
        lastTime = output[0].timeLastModified;
    foreach (file; output)
    {
        
        import std.path : baseName;

        with (data.category(file.name.baseName))
        {
            import std.conv : to;

            setAtom("sizeBytes", file.size);
            setAtom("sizeKiloBytes", (cast(float) file.size) / 1024f);
            setAtom("timeLastModified", file.timeLastModified.to!string);
            setAtom("approxBuildTime_msecs", (file.timeLastModified - lastTime).total!"msecs");
            //No elf on windows, no post on sundays
        }
        if(readElf)
            elfData(data.category(file.name.baseName), file.name);
    }
    
    return stats.gcDup;
}
