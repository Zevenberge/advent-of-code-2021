import std;

void main()
{
    auto lines = File("puzzle.input", "r").byLine.map!(line => line.to!string).array;
    auto blocks = lines.splitter("");
    auto drawnNumbers = blocks.front.front.to!string;
    blocks.popFront;
    BingoCard[] cards;
    foreach(block; blocks)
    {
        cards ~= new BingoCard(block);
    }
    auto numbers = drawnNumbers.splitter(",");
    int number;
    while(!cards.any!(c => c.hasWon))
    {
        number = numbers.front.to!int;
        foreach(card; cards)
        {
            card.draw(number);
        }
        numbers.popFront;
    }
    auto winningCard = cards.filter!(c => c.hasWon).front;
    writeln(number * winningCard.score);
}

class BingoCard
{
    this(Block)(Block block)
    {
        void addRow(size_t row, const(char)[] line)
        {
            foreach(column; 0 .. 5)
            {
                const start = 3 * column;
                const end = start + 2;
                auto field = new Field(line[start .. end].strip.to!int);
                allFields[5 * row + column] = field;
                rows[row][column] = field;
                columns[column][row] = field;
            }
            
        }
        foreach(i, line; block)
        {
            addRow(i, line);
        }
    }

    private Field[5][5] rows;
    private Field[5][5] columns;
    private Field[25] allFields;

    void draw(int number)
    {
        foreach(field; allFields)
        {
            field.draw(number);
        }
    }

    bool hasWon()
    {
        return rows[].any!(r => r[].isAllCrossed) || columns[].any!(c => c[].isAllCrossed);
    }

    int score()
    {
        return allFields[].filter!(f => !f.isTicked).map!(f => f.number).sum;
    }
}

bool isAllCrossed(Field[] collection)
{
    return collection.length == 0 || 
        (collection[0].isTicked && collection[1 .. $].isAllCrossed);
}

class Field
{
    this(int number)
    {
        _number = number;
    }

    private const int _number;
    int number()
    {
        return _number;
    }

    private bool _isTicked;
    bool isTicked() pure const
    { 
        return _isTicked; 
    }

    void draw(int number)
    {
        _isTicked = _isTicked || _number == number;
    }
}