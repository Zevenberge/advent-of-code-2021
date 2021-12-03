import std;


size_t gammaRate(const string[] diagnosticReport)
{
    const entryLength = diagnosticReport[0].length;
    size_t gammaRate = 0;
    foreach(bit; 0 .. entryLength)
    {
        size_t ones = 0;
        foreach(entry; diagnosticReport)
        {
            ones += entry[bit] == '1';
        }
        gammaRate += (ones > diagnosticReport.length / 2) << (entryLength - 1 - bit);
    }
    return gammaRate;
}

size_t epsilonRate(const string[] diagnosticReport)
{
    size_t seed = (1 << diagnosticReport[0].length) - 1;
    return (seed ^ diagnosticReport.gammaRate) & seed;
}

void main()
{
    const diagnosticReport = File("puzzle.input", "r").byLine.map!(l => l.to!string).array;
    (diagnosticReport.gammaRate * diagnosticReport.epsilonRate).writeln;
}