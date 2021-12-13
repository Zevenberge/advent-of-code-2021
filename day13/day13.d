import std;

alias Coord = Tuple!(int, "x", int, "y");
alias Paper = Coord[];

string[] allLines(File file)
{
    return file.byLine.map!(l => l.to!string).array;
}

Coord toCoord(string dot)
{
    auto parts = dot.splitter(",");
    const x = parts.front.to!int;
    parts.popFront;
    const y = parts.front.to!int;
    return Coord(x, y);
}

int foldValue(int value, int fold)
{
    if(value < fold)
    {
        return value;
    }
    return fold - (value - fold);
}

Coord foldHorizontally(Coord coord, int x)
{
    return Coord(coord.x.foldValue(x), coord.y);
}

Coord foldVertically(Coord coord, int y)
{
    return Coord(coord.x, coord.y.foldValue(y));
}

void addDot(ref Paper paper, string dot)
{
    paper ~= dot.toCoord;
}

void foldHorizontally(ref Paper paper, int x)
{
    paper = paper.map!(coord => coord.foldHorizontally(x)).array;
}

void foldVertically(ref Paper paper, int y)
{
    paper = paper.map!(coord => coord.foldVertically(y)).array;
}

void fold(ref Paper paper, string instruction)
{
    auto foldLine = instruction.splitter(" ").drop(2).front.to!string;
    auto lineNumber = foldLine.splitter("=").drop(1).front.to!int;
    if(foldLine[0] == 'x')
    {
        paper.foldHorizontally(lineNumber);
    }
    else
    {
        paper.foldVertically(lineNumber);
    }
}

size_t countUniques(Paper paper)
{
    bool[Coord] uniques;
    foreach(dot; paper)
    {
        uniques[dot] = true;
    }
    return uniques.length;
}

void main()
{
    auto lines = File("puzzle.input", "r").allLines;
    Paper paper;
    size_t i = 0;
    while(lines[i] != "")
    {
        paper.addDot(lines[i]);
        i++;
    }
    i++; // skip empty line;
    paper.fold(lines[i]);
    paper.countUniques.writeln;
}