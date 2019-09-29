//basic ansi color formatting
module util.colour;
import std.format : format;


bool colouredOutput = true;
///Codes for ANSI Text Attributes
enum TextAttribute : byte
{
    allOff = 0,
    bold = 1,
    underline = 4,
    blink = 5,
    reverseVideo = 7,
    concealed = 8
}
////Basic foregroudn colours
enum ForegroundColour : byte
{
    Black = 30,
    Red = 31,
    Green = 32,
    Yellow = 33,
    Blue = 34,
    Magenta = 35,
    Cyan = 36,
    White = 37
}
///Basic background colors
enum BackgroundColour : byte
{
    Black = 40,
    Red = 41,
    Green = 42,
    Yellow = 43,
    Blue = 44,
    Magenta = 45,
    Cyan = 46,
    White = 47
}
///Who cares about efficiency, write string with attribute applied
string attributeString(string term = "\033[0m")(string input, TextAttribute ta)
{
    if(!colouredOutput) return input;
    return format!"\033[%dm%s%s"(ta, input, term);
}
string colourString(string term = "\033[0m")(string input,
        ForegroundColour fg = ForegroundColour.White, BackgroundColour bg = BackgroundColour.Black)
{
    if(!colouredOutput) return input;
    return format!"\033[%d;%dm%s%s"(fg, bg, input, term);

}
