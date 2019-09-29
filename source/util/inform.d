module util.inform;
import util.colour;
import std.stdio;

///Send coloured output to stdout
bool inform(lazy string output)
{    
    writeln(colourString(output, ForegroundColour.Yellow));
    return true;//So it can be used in preconditions (hack)
}
///Print message and terminate
bool alert(lazy string output, int code = 1 )
{
    import core.stdc.stdlib : exit;
    writeln(colourString(output, ForegroundColour.Red).attributeString!""(TextAttribute.underline));
    exit(code);
    return true;
}