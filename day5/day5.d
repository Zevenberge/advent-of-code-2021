import std;

struct Coord
{
    this(const(char[]) input)
    {
        auto parts = input.splitter(",");
        x = parts.front.to!int;
        parts.popFront;
        y = parts.front.to!int;
    }

    this(int x, int y)
    {
        this.x = x;
        this.y = y;
    }

    int x;
    int y;
}

int[Coord] oceanFloor;

void addCoordinate(Coord coord)
{
    const int current = oceanFloor.require(coord, 0);
    oceanFloor[coord] = current + 1;
}

void addLine(Coord from, Coord to)
{
    const amountOfSteps = max(abs(from.x - to.x), abs (from.y - to.y));
    const stepX = (to.x - from.x) / amountOfSteps;
    const stepY = (to.y - from.y) / amountOfSteps;
    if(stepX * stepY != 0) return;
    foreach(i; 0 .. amountOfSteps + 1)
    {
        Coord current = Coord(from.x + i * stepX, from.y + i * stepY);
        addCoordinate(current);
    }
}

size_t amountOfPointsWithIntersectingLines()
{
    return oceanFloor.values.filter!(val => val > 1).count;
}

void main()
{
    foreach(line; File("puzzle.input", "r").byLine)
    {
        auto parts = line.splitter(" -> ");
        auto from = parts.front.to!Coord;
        parts.popFront;
        auto to = parts.front.to!Coord;
        addLine(from, to);
    }
    writeln(amountOfPointsWithIntersectingLines);
}