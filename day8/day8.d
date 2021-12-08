import std;
import std.algorithm : count;

static immutable char[7] init = ['a', 'b', 'c', 'd', 'e', 'f', 'g'];

struct Segments
{
    string one;
    string four;
    string seven;

    void reduce(string word)
    {
        switch(word.length)
        {
            case 2:
                reduceOne(word);
                return;
            case 3: 
                reduceSeven(word);
                return;
            case 4:
                reduceFour(word);
                return;
            default:
                return;
        }
    }

    private void reduceOne(string word)
    {
        one = word;
    }

    private void reduceFour(string word)
    {
        four = word;
    }

    private void reduceSeven(string word)
    {
        seven = word;
    }

    int deriveNumber(string word)
    {
        switch(word.length)
        {
            case 2: return 1;
            case 3: return 7;
            case 4: return 4;
            case 5: return twoThreeOrFive(word);
            case 6: return zeroSixOrNine(word);
            case 7: return 8;
            default: assert(false);
        }
    }

    private int twoThreeOrFive(string word)
    {
        auto foursWithoutOnes = four.filter!(f => !one.any!(o => o == f));
        if(word.containsAll(foursWithoutOnes))
        {
            return 5;
        }
        return word.containsAll(seven) ? 3 : 2;
    }

    private int zeroSixOrNine(string word)
    {
        if(!word.containsAll(one))
        {
            return 6;
        }
        return word.containsAll(four) ? 9 : 0;
    }
}

bool containsAll(String)(string word, String subset)
{
    return subset.all!(s => word.any!(w => w == s));
}

int handleLine(String)(String line)
{
    auto parts = line.splitter('|');
    auto input = parts.front.strip;
    auto words = input.splitter(' ').map!(w => w.to!string).array;
    Segments segments;
    foreach(word; words)
    {
        segments.reduce(word);
    }
    parts.popFront;
    auto output = parts.front.strip.splitter(' ');
    return output.map!(o => cast(char)(segments.deriveNumber(o.to!string) + '0')).to!int;
}

void main()
{
    File("puzzle.input", "r").byLine
        .map!handleLine.sum.writeln;
}