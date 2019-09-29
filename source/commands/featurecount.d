//Counts D features, doesn't really work yet :<(
module commands.featurecount;

import std;
import util.debug_;
import util.statman;

//The Kitchen sink
import dmd.astbase;
import dmd.errors;
import dmd.parse;
import dmd.transitivevisitor;
import dmd.dmodule;
import dmd.func;
import dmd.globals;
import dmd.id;
import dmd.identifier;
import dmd.visitor;
import dmd.frontend;
import dmd.dmangle;
import dmd.dsymbol;
import dmd.declaration;
import dmd.dtemplate;
///Stolen from J.C.'s thing in github/dmd, gets the default dmd import paths on a system
string[] defaultImportPaths(string dlangDir)
{
    import std.path : buildNormalizedPath, buildPath, dirName;
    import std.process : environment;

    const druntimeDir = dlangDir.buildPath("druntime", "import");
    const phobosDir = dlangDir.buildPath("phobos");

    return [environment.get("DRUNTIME_PATH", druntimeDir),
        environment.get("PHOBOS_PATH", phobosDir)];
}

///Sorry god, utility function because dmd works in terms of c strings due to extern(C++) limitations
string cToD(inout char* x)
{
    import core.stdc.string : strlen;

    return cast(immutable char[]) x[0 .. x.strlen];
}
///Walks the semantic time AST, parse time is apparently not enough (e.g. needs sema to have everything)
extern (C++) //This is annoying but required unfortunately 
class FeatureCountVisitor : SemanticTimePermissiveVisitor
{
    alias visit = SemanticTimePermissiveVisitor.visit;
    StatManager stats;
    this()
    {
        stats = StatManager("FeatureCountVisitor");
    }

    override void visit(Module mod)
    {
        foreach (x; *mod.members)
        {
            x.accept(this);
        }

    }

    override void visit(Dsymbol sym)
    {
        
        debug writeln("stub dsymbol");
    }

    override void visit(TemplateDeclaration decl)
    {
        
        if(auto c = decl.constraint)
        {
            import core.stdc.stdio;
            
        }
    }
    override void visit(FuncDeclaration func)
    {
        import std.conv : to;

        auto tmp = stats.category("functions").category(func.mangleExact.cToD);
        with (tmp)
        {
            setAtom("fullSignature", func.toFullSignature.cToD);
            setAtom("ProtectionClass", func.prot.to!string);
            with (category("loc"))
            {
                setAtom("filename", func.loc.filename.cToD);
                setAtom("line", func.loc.linnum);
            }
        }

    }
}

string command(bool useJson, string[] args)
{
    import std.getopt : getopt, config;
    import std.file : readText;
    initDMD;
    scope (exit)
        deinitializeDMD;

    string dimport;
    string fileName;
    string content;
    auto parseResult = getopt(args, config.required, "I|import", &dimport, "f|file", &fileName);
    if(fileName != "") {
        content = readText(fileName);
    } else {
        //stdin
    }
        
    
    defaultImportPaths(dimport).each!addImport;
    //Just dump any issues to stderr
    scope diagnosticReporter = new StderrDiagnosticReporter(global.params.useDeprecated);
    scope mod = parseModule(fileName, content, diagnosticReporter);

    scope tmp = new FeatureCountVisitor();

    //We wamt the whole shebang 
    mod.module_.fullSemantic;

    mod.module_.accept(tmp);
    if(useJson)
        return tmp.stats.getJSON.toPrettyString;
    return tmp.stats.prettyString;
}
