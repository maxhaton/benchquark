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
        StatManager* gcDup()
        {
            auto y = new StatManager;
            y.buf = this.buf;
            return y;
        }
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
class Array : HasJSON {
    string name;
    this(string _name)
    {
        name = _name;
    }
    private HasCategory[] content;
    HasCategory index(ulong i)
    {
        return content[i];
    }
    HasCategory bump()
    {
        auto y = new HasCategory;
        content ~= y;
        return y;
    }
    void debg() const
    {
        import std.stdio;
        writeln("Stored: ", content.length);
    }
    JSONValue getJSON() const pure
    {
        
        JSONValue g;
        g.array = [];
        foreach(i, v; content)
        {
            g.array ~= v.getJSON;
        }
        return g;
    }
    string prettyString(uint depth = 0)
    {
        import std.array : replicate;
        import std.format;
        alias tabrep = x => "\t".replicate(x);
        const tabs = tabrep(depth);
        string tmp = tabs;
        foreach(i, j; content)
        {
            tmp ~= format!"Index: %d\n%s%s"(i, tabs, j.prettyString(depth + 1));
        }
        return tmp;
    }
}
public class HasCategory : HasJSON
{
    HasJSON[string] atomMap;

    void setAtom(T)(string name, T x)
    {
        atomMap[name] = new Atom!T(x);
    }
    Array initArray(string name)
    {
        if(name !in atomMap) {
            auto y = new Array(name);
            atomMap[name] = y;
            return y;
        } else {
            return cast(Array) atomMap[name];
        }
        
        
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
        import std.stdio;
        alias tabrep = x => "\t".replicate(x);

        import util.colour;
        import std.format;
        import std.algorithm;
        import std.array : replicate;

        const tabs = "\t".replicate(depth);
        string tmp;
        
            
        
        foreach (key, value; atomMap)
        {

            tmp ~= format!"%s%s: %s\n"(tabs, colourString(key, ForegroundColour.Yellow),
                        colourString(value.prettyString(0), ForegroundColour.Red));
        }
        
        
        foreach (key, value; categoryMap)
        {
            const colouredKey = key.colourString(ForegroundColour.Green);
            tmp ~= format!"%s%s\n%s\n"(tabs, colouredKey, value.prettyString(depth + 1));
            
        }

        return tmp;
    }
}
