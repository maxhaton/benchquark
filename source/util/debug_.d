module util.debug_;

void _(string f = __FILE__, int l =  __LINE__)
{
    import std.stdio;
    writef!"%s : %d\n"(f, l);
}