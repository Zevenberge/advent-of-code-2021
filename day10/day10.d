import std;

static immutable char[char] matchingBraces;
static immutable char[] openingBraces = ['(', '<', '[', '{'];

shared static this()
{
    matchingBraces['('] = ')';
    matchingBraces['<'] = '>';
    matchingBraces['['] = ']';
    matchingBraces['{'] = '}';
}

bool isClosingBrace(char brace)
{
    return matchingBraces.values.any!(b => b == brace);
}

size_t syntaxScore(char brace)
{
    switch(brace)
    {
        case ')': return 3;
        case ']': return 57;
        case '}': return 1197;
        case '>': return 25137;
        default: assert(false);
    }
}

size_t parseChunk(ref char[] line)
{
    const openingBrace = line[0];
    line = line[1 .. $];
    while (true)
    {
        if (line.length == 0)
            return 0;
        auto peek = line[0];
        if (peek == matchingBraces[openingBrace])
        {
            line = line[1..$];
            return 0;
        }
        if (peek.isClosingBrace)
            return peek.syntaxScore;
        auto score = line.parseChunk;
        if(score != 0)
            return score;
    }
}

void main()
{
    File("puzzle.input", "r").byLine.map!(l => l.parseChunk).sum.writeln;
}
