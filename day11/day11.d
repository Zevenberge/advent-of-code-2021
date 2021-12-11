import std;

class Octopus
{
    this(int charge)
    {
        _charge = charge;
    }

    private int _charge;
    private int _amountOfFlashes;
    int amountOfFlashes()
    {
        return _amountOfFlashes;
    }

    private Octopus[] _neighbours;

    void neighbours(Octopus[] neighbours)
    {
        _neighbours = neighbours;
    }

    private bool _hasFlashed;
    bool hasFlashed()
    {
        return _hasFlashed;
    }

    bool willFlash()
    {
        return _charge > 9 && !_hasFlashed;
    }

    void flash()
    {
        _amountOfFlashes++;
        _hasFlashed = true;
        foreach(neighbour; _neighbours)
        {
            neighbour.hit;
        }
    }

    void hit()
    {
        _charge++;
    }

    void reset()
    {
        if(_hasFlashed)
        {
            _hasFlashed = false;
            _charge = 0;
        }
    }

    override string toString() const
    {
        return _charge.to!string;
    }
}

Octopus[] area(Octopus[][] octopuses, size_t x, size_t y)
{
    const lowerX = max((cast(int)x) - 1, 0);
    const upperX = min(x + 1, octopuses[0].length - 1);
    const lowerY = max((cast(int)y) - 1, 0);
    const upperY = min(y + 1, octopuses.length - 1);
    Octopus[] area;
    foreach(j; lowerY .. upperY + 1)
    {
        area ~= octopuses[j][lowerX .. upperX + 1];
    }
    return area;
}

void flatForeach(alias fun)(Octopus[][] octopuses)
{
    foreach(row; octopuses)
    {
        foreach(octopus; row)
        {
            fun(octopus);
        }
    }
}


bool simulateStep(Octopus[][] octopuses)
{
    octopuses.flatForeach!(o => o.hit);
    while(octopuses.joiner.any!(o => o.willFlash))
    {
        foreach(octopus; octopuses.joiner.filter!(o => o.willFlash))
        {
            octopus.flash;
        }
    }
    auto haveAllFlashed = octopuses.joiner.all!(o => o.hasFlashed);
    octopuses.flatForeach!(o => o.reset);
    return haveAllFlasged;
}

void main()
{
    auto octopuses = File("puzzle.input", "r").byLine.map!(
        line => line.map!(o => new Octopus(o - '0')).array
    ).array;
    foreach(y, row; octopuses)
    {
        foreach(x, octopus; row)
        {
            octopus.neighbours = octopuses.area(x, y);
        }
    }

    enum amountOfSteps = 100;
    foreach(_; 0 .. amountOfSteps)
    {
        octopuses.simulateStep;
    }

    octopuses.joiner.map!(o => o.amountOfFlashes).sum.writeln;
}