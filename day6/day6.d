import std;

size_t[int] toColony(size_t[] fish)
{
    size_t[int] lanternFish;
    foreach(i; 0 .. 9)
    {
        lanternFish[i] = fish.filter!(f => f == i).count;
    }
    return lanternFish;
}

size_t amountOfOffSpring(size_t[int] lanternFish)
{
    return lanternFish[0];
}

size_t[int] advanceDay(size_t[int] lanternFish)
{
    size_t lanternFishToReset = lanternFish[0];
    foreach(i; 1 .. 9)
    {
        lanternFish[i - 1] = lanternFish[i];
    }
    lanternFish[8] = 0;
    lanternFish[6] = lanternFish[6] + lanternFishToReset;
    return lanternFish;
}

size_t[int] addOffSpring(size_t[int] lanternFish, size_t amountOfOffSpring)
{
    lanternFish[8] = amountOfOffSpring;
    return lanternFish;
}

size_t amount(size_t[int] lanternFish)
{
    return lanternFish.values.sum;
}

void main()
{
    auto lanternFish = File("puzzle.input", "r").byLine.front.splitter(",").map!(f => f.to!size_t).array.toColony;
    foreach(day; 0 .. 256)
    {
        auto offSpring = lanternFish.amountOfOffSpring;
        lanternFish = lanternFish.advanceDay.addOffSpring(offSpring);
    }
    lanternFish.amount.writeln;
}