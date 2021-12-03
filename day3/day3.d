import std;

alias DiagnosticReport = const string[];

char determineBitCriterium(string op)(DiagnosticReport diagnosticReport, size_t index)
{
    size_t ones = 0;
    foreach(entry; diagnosticReport)
    {
        ones += entry[index] == '1';
    }
    return '0' + mixin(q{ones * 2 %s diagnosticReport.length}.format(op));
}

alias leastCommonBitAt = determineBitCriterium!"<";
alias mostCommonBitAt = determineBitCriterium!">=";

size_t parse(T)(T bits)
{
    size_t number = 0;
    foreach(bit; 0 .. bits.length)
    {
        number += (bits[bit] == '1') << (bits.length - 1 - bit);
    }
    return number;
}

size_t gammaRate(DiagnosticReport diagnosticReport)
{
    return iota(diagnosticReport[0].length).array
        .map!(bit => diagnosticReport.mostCommonBitAt(bit))
        .parse;
}

size_t epsilonRate(DiagnosticReport diagnosticReport)
{
    size_t seed = (1 << diagnosticReport[0].length) - 1;
    return (seed ^ diagnosticReport.gammaRate) & seed;
}

size_t filterByCriteria(alias selectBitCriterium)(DiagnosticReport diagnosticReport)
{
    auto reducibleReport = diagnosticReport.array;
    size_t index = 0;
    while(reducibleReport.length > 1 && index < reducibleReport[0].length)
    {
        const bitCriterium = selectBitCriterium(reducibleReport, index);
        reducibleReport = reducibleReport.filter!(entry => entry[index] == bitCriterium).array;
        index++;
    }
    return reducibleReport[0].parse;
}

alias oxygenGeneratorRating = filterByCriteria!mostCommonBitAt;
alias co2ScrubberRating = filterByCriteria!leastCommonBitAt;

void main()
{
    const diagnosticReport = File("puzzle.input", "r").byLine.map!(l => l.to!string).array;
    (diagnosticReport.oxygenGeneratorRating * diagnosticReport.co2ScrubberRating).writeln;
}