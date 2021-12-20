import std;

alias Monomer = string;
alias Polymer = size_t[Monomer];
alias Polymerization = Monomer[] delegate(Monomer);
alias KeyValue = Tuple!(string[], "key", size_t, "value");

void add(ref Polymer polymer, Monomer monomer, size_t amount = 1)
{
    polymer[monomer] = polymer.require(monomer, 0) + amount;
}

Polymer decomposeTemplate(string polymerTemplate)
{
    Polymer polymer;
    foreach(i; 0 .. polymerTemplate.length - 1)
    {
        auto monomer = [polymerTemplate[i], polymerTemplate[i+1]].to!Monomer;
        polymer.add(monomer);
    }
    return polymer;
}

Polymerization asPolymerization(string line)
{
    auto instruction = line.splitter(" -> ");
    auto monomer = instruction.front;
    instruction.popFront;
    auto resultA = [monomer[0], instruction.front[0]];
    auto resultB = [instruction.front[0], monomer[1]];
    return (input) {
        if(input == monomer)
        {
            return [resultA, resultB];
        }
        return [];
    };
}

Polymer flatten(Range)(Range range)
{
    Polymer polymer;
    foreach(element; range)
    {
        foreach(monomer; element.key)
        {
            polymer.add(monomer, element.value);
        }
    }
    return polymer;
}

Polymer polymerisate(Polymer polymer, Polymerization[] polimarizations)
{
    return polymer.byKeyValue.map!(kv => 
        polimarizations.map!(p => KeyValue(p(kv.key), kv.value))
        ).joiner.flatten;
}

size_t[char] countElements(Polymer polymer, string firstLine)
{
    size_t[char] output;
    output[firstLine[0]] = 1;
    output[firstLine[$-1]] = 1;
    foreach(monomer; polymer.byKeyValue)
    {
        foreach(element; monomer.key)
        {
            output[element] = output.require(element, 0) + monomer.value;
        }
    }
    foreach(element; output.byKey)
    {
        output[element] = output[element] / 2;
    }
    return output;
}

void main()
{
    auto lines = File("puzzle.input", "r").byLine;
    auto firstLine = lines.front.to!string;
    auto polymer = firstLine.decomposeTemplate;
    lines.popFront;
    lines.popFront;
    auto polymerizations = lines.map!(line => line.to!string.asPolymerization).array;
    foreach(step; 0 .. 10)
    {
        polymer = polymer.polymerisate(polymerizations);
    }
    auto elements = polymer.countElements(firstLine);
    elements.writeln;
    (elements.byKeyValue.maxElement!(kv => kv.value).value -
        elements.byKeyValue.minElement!(kv => kv.value).value).writeln;
}