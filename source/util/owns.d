module util.owns;
enum dir = ".benchquark";
//Is the benchquark directory present
bool dirHealth()
{
    import std.file;
    return exists(dir);
}
bool subDirHealth(string subdir)
{
    import std.file : exists;
    import std.path : buildPath;

    return exists(buildPath(dir, subdir));
}
void fixSubDir(string subdir)
{
    import std.file;
    import std.path : buildPath;
    if(!subDirHealth(subdir))
        mkdir(buildPath(dir, subdir));
}
void createDir()
{
    import std.file;
    mkdir(dir);
    assert(dirHealth);
}

