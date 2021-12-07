import std;

int fuelUsage(int amountOfSteps)
{
    static int[int] totalFuel;
    totalFuel[0] = 0;
    return totalFuel.require(amountOfSteps, amountOfSteps + fuelUsage(amountOfSteps - 1));
}

void main()
{
    auto crabs = File("puzzle.input", "r").byLine.front.splitter(",").map!(m => m.to!int);
    const firstCrab = crabs.minElement;
    const lastCrab = crabs.maxElement;
    int fuel = int.max;
    foreach(pos; firstCrab .. (lastCrab + 1))
    {
        int thisFuel = 0;
        foreach(crab; crabs)
        {
            thisFuel += abs(crab - pos).fuelUsage;
        }
        fuel = min(fuel, thisFuel);
    }
    fuel.writeln;
}