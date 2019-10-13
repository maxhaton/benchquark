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

int command(inout BuildSpecification build)
{
    import std.format : format;
    import std.stdio;
    import elf;

    const dir = getcwd;

    inform(format!"Building %s in %s\n"(build.exactCommand, dir));

    import std.file;

    auto output = execAndDiff(build);

    auto stats = StatManager("build - " ~ build.name);

    auto data = stats.category("resultingFiles");

    stats.setAtom("builtIn", dir);

    foreach (file; output)
    {
        import std.path : baseName;

        with (data.category(file.name.baseName))
        {
            import std.conv : to;

            setAtom("sizeBytes", file.size);
            setAtom("sizeKiloBytes", (cast(float) file.size) / 1024f);
            setAtom("timeLastModified", file.timeLastModified.to!string);
            //No elf on windows, no post on sundays
        }
        elfData(data.category(file.name.baseName), file.name);
    }

    stats.prettyString.writeln;
    return 0;
}
