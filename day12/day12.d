import std;
import std.ascii : isUpper;

alias Route = Grotto[];
enum start = "start";
enum end = "end";

abstract class Grotto
{
    static Grotto construct(string name)
    {
        if(name == end)
        {
            return new Exit();
        }
        if(name.all!(ch => ch.isUpper))
        {
            return new LargeGrotto();
        }
        return new SmallGrotto();
    }

    protected Grotto[] connectors;

    void connect(Grotto other)
    {
        connectors ~= other;
        other.connectors ~= this;
    }

    abstract bool canMoveTo(Route route);

    abstract bool canMoveFrom();

    bool isExit()
    {
        return false;
    }
}

auto possibleGrottos(Grotto grotto, Route route)
{
    return grotto.connectors.filter!(conn => grotto.canMoveFrom && conn.canMoveTo(route));
}

auto currentLocation(Route route)
{
    return route[$-1];
}

auto possibleRoutes(Route route)
{
    return possibleGrottos(route.currentLocation, route).map!(grotto => route ~ grotto);
}

class SmallGrotto : Grotto
{
    override bool canMoveTo(Route route)
    {
        return !route.canFind(this);
    }

    override bool canMoveFrom()
    {
        return true;
    }
}

class LargeGrotto : Grotto
{
    override bool canMoveTo(Route _)
    {
        return true;
    }

    override bool canMoveFrom()
    {
        return true;
    }
}

class Exit : Grotto
{
    override bool canMoveTo(Route _)
    {
        return true;
    }

    override bool canMoveFrom()
    {
        return false;
    }

    override bool isExit()
    {
        return true;
    }
}

template flatMap(alias fun)
{
    auto flatMap(Range)(Range range)
    {
        return range.map!fun.joiner;
    }
}

Route[] traverse(Route[] routes)
{
    return routes.flatMap!(route => route.possibleRoutes).array;
}

void findAllRoutes(Grotto start)
{
    Route initial = [start];
    Route[] currentRoutes = [initial];
    size_t successfulRoutes = 0;
    do
    {
        currentRoutes = currentRoutes.traverse;
        successfulRoutes += currentRoutes.filter!(route => route.currentLocation.isExit).count;
    }
    while(currentRoutes.length > 0);
    writeln(successfulRoutes);
}

Grotto buildCaveSystem()
{
    Grotto[string] caves;
    foreach(line; File("puzzle.input", "r").byLine)
    {
        auto parts = line.splitter("-");
        auto firstCave = parts.front.to!string;
        auto first = caves.require(firstCave, Grotto.construct(firstCave));
        parts.popFront;
        auto secondCave = parts.front.to!string;
        auto second = caves.require(secondCave, Grotto.construct(secondCave));
        first.connect(second);
    }

    return caves[start];
}

void main()
{
    buildCaveSystem.findAllRoutes;
}