import std;

struct LanternFish
{
    int daysToOffSpring;

    bool hasOffSpring()
    {
        return daysToOffSpring == 0;
    }

    LanternFish advanceDay()
    {
        return LanternFish(daysToOffSpring ? daysToOffSpring - 1 : 6);
    }

    LanternFish resetDay()
    {
        return daysToOffSpring ? this : LanternFish(6);
    }
}

LanternFish[] advanceDay(LanternFish[] fish)
{
    return fish.map!(f => f.advanceDay).array;
}

LanternFish[] addOffSpring(LanternFish[] fish)
{
    return fish.filter!(f => f.hasOffSpring).map!(_ => LanternFish(8)).array;
}

void main()
{
    auto lanternFish = File("puzzle.input", "r").byLine.front.splitter(",").map!(f => LanternFish(f.to!int)).array;
    foreach(day; 0 .. 80)
    {
        auto offSpring = lanternFish.addOffSpring;
        lanternFish = lanternFish.advanceDay ~ offSpring;
    }
    lanternFish.length.writeln;
}