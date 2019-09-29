/*
Very basic table<nested table> implementation.

Categories and atoms are held seperately to stop me making mistakes

Operates in terms of D strings 
*/
module util.statman;
import std.json;
import std.exception : enforce;

public
{
    struct StatManager
    {
        HasCategory buf;

        this(string nameset)
        {
            buf = new HasCategory;
            buf.setAtom("from", nameset);
        }

        alias buf this;
    }
}
// Hidden implementation detailed
private:

///The base of all stats
interface HasJSON
{
    JSONValue getJSON() const pure;
    string prettyString(uint depth = 0);
}

class Atom(T) : HasJSON
{
    private T x;
    this(T xx)
    {
        import std.traits : hasIndirections;

        static if (hasIndirections!T)
        {
            x = xx.idup;
        }
        else
        {
            x = xx;
        }
    }

    JSONValue getJSON() const pure
    {
        return JSONValue(x);
    }

    string prettyString(uint depth = 0)
    {
        import std.conv;

        return to!string(x);
    }
}

class HasCategory : HasJSON
{
    HasJSON[string] atomMap;

    void setAtom(T)(string name, T x)
    {
        atomMap[name] = new Atom!T(x);
    }

    HasCategory[string] categoryMap;
    HasCategory category(string name)
    {
        enforce(name !in atomMap, "Name collision: category is also an atom");
        if (name in categoryMap)
        {
            return categoryMap[name];
        }
        else
        {
            categoryMap[name] = new HasCategory;
            return categoryMap[name];
        }
    }
    //Attempts to be slightly clever: Get the identifier from a symbol and use that to assign an atom
    void setAtom(alias var)()
    {
        setAtom(__traits(identifier, var), var);
    }

    JSONValue getJSON() const pure
    {
        JSONValue buf;
        foreach (key, value; atomMap)
        {
            buf[key] = value.getJSON;
        }
        foreach (key, value; categoryMap)
        {
            buf[key] = value.getJSON;
        }
        return buf;
    }

    private string[2][] getAtoms()
    {
        string[2][] tmp;
        foreach (key, value; atomMap)
        {
            tmp ~= [key, value.prettyString];
        }
        return tmp;
    }

    string prettyString(uint depth = 0)
    {
        //ugly

        alias tabrep = x => "\t".replicate(x);

        import util.colour;
        import std.format;
        import std.algorithm;
        import std.array : replicate;

        string tmp = "";
        if (depth == 0)
        {
            //top level atoms
            foreach (key, value; atomMap)
            {
                tmp ~= format!"%s %s\n"(colourString(key, ForegroundColour.Yellow),
                        colourString(value.prettyString(0), ForegroundColour.Red));
            }
        }

        
        foreach (key, value; categoryMap)
        {

            alias tabrep = x => "\t".replicate(x);
            tmp ~= format!"%s%s\n"(tabrep(depth), colourString(key, ForegroundColour.Blue));

            if (value.atomMap.length)
            {
                foreach (key, value; atomMap)
                {
                    tmp ~= format!"%s%s %s\n"(tabrep(depth + 1), colourString(key, ForegroundColour.Yellow),
                            colourString(value.prettyString(0), ForegroundColour.Red));
                }
            }
            tmp ~= value.prettyString(depth + 1);
        }

        return tmp;
    }
}
