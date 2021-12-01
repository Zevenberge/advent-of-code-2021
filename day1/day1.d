import std;

void main()
{
    enum file = "puzzle.input";
    int previousInput = int.max;
    int amountOfIncreases = 0;
    foreach(line; File(file, "r").byLine)
    {
        int convertedValue = line.to!int;
        amountOfIncreases += convertedValue > previousInput;
        previousInput = convertedValue;
    }
    writeln(amountOfIncreases);
}