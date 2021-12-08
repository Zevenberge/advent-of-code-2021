import std;
import std.algorithm : count;

bool hasUniqueLength(String)(String word)
{
    const length = word.count;
    return length == 2 || length == 3 || length == 4 || length == 7;
}

void main()
{
    File("puzzle.input", "r").byLine.map!(line => 
        line.splitter('|').dropOne.front
            .splitter(' ').filter!(word => word.hasUniqueLength).count
    ).sum.writeln;
}