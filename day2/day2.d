import std;

struct Position
{
    private int horizontalPosition;
    private int depth;

    Position up(int x) pure const
    {
        return Position(horizontalPosition, depth - x);
    }

    Position down(int x) pure const
    {
        return Position(horizontalPosition, depth + x);
    }

    Position forward(int x) pure const
    {
        return Position(horizontalPosition + x, depth);
    }

    int multiply() pure const
    {
        return horizontalPosition * depth;
    }
}

Position move(const Position initialPosition, const(char[]) input)
{
    auto split = input.splitter(' ');
    const methodName = split.front;
    split.popFront;
    const amount = split.front.to!int;
    switch(methodName)
    {
        static foreach(member; __traits(allMembers, Position))
        {
            static if(__traits(compiles, __traits(getMember, initialPosition, member)(amount)))
            {
                case member:
                    return __traits(getMember, initialPosition, member)(amount);
            }
        }
        default:
            assert(false, "Could not find movement " ~ methodName);
    }
}

void main()
{
    enum file = "puzzle.input";
    File(file, "r").byLine.fold!((position, line) => position.move(line))(Position()).multiply.writeln;
}
