module util.owns;
enum dir = ".benchquark";
//Is the benchquark directory present
bool dirHealth()
{
    import std.file;
    return exists(dir);
}
void createDir()
{
    import std.file;
    mkdir(dir);
    assert(dirHealth);
}