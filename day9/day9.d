import std;

alias Height = uint;
alias HeightMap = Height[][];
alias Coord = Tuple!(size_t, "x", size_t, "y");

HeightMap parseText(Strings)(Strings strings)
{
    return strings.map!(s =>
        s.map!(letter => letter - '0').array
    ).array;
}

uint riskLevel(Height height)
{
    return height + 1;
}

bool hasLowAt(HeightMap map, size_t x, size_t y)
{
    const yRange = map.length;
    const xRange = map[0].length;
    const height = map[y][x];
    return [Coord(x - 1, y), Coord(x + 1, y), Coord(x, y - 1), Coord(x, y + 1)]
        .filter!(c => c.isWithinBounds(xRange, yRange))
        .all!(c => map[c.y][c.x] > height);
}

bool isWithinBounds(Coord coord, size_t xRange, size_t yRange)
{
    return coord.x >= 0 && coord.y >= 0
        && coord.x < xRange && coord.y < yRange;
}

void main()
{
    auto field = File("puzzle.input", "r").byLine.parseText;
    uint totalRiskLevel = 0;
    foreach(y, row; field)
    {
        foreach(x, height; row)
        {
            if(field.hasLowAt(x, y))
            {
                totalRiskLevel += height.riskLevel;
            }
        }
    }
    totalRiskLevel.writeln;
}