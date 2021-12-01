import std;

void main()
{
    enum file = "puzzle.input";
    int previousInput = int.max;
    int amountOfIncreases = 0;
    
    foreach(group; File(file, "r").byLine
        .map!(line => line.to!int).array
        .byThree)
    {
        int summedValue = group.sum;
        amountOfIncreases += summedValue > previousInput;
        previousInput = summedValue;
    }
    writeln(amountOfIncreases);
}

auto byThree(int[] numbers)
{
    return ByThree(numbers);
}

struct ByThree
{
    this(int[] numbers)
    {
        _numbers = numbers;
    }

    private int[] _numbers;

    int[] front()
    {
        return _numbers[0 .. 3];
    }

    void popFront()
    {
        _numbers = _numbers[1 .. $];
    }

    bool empty()
    {
        return _numbers.length < 3;
    }
}