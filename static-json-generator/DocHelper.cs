namespace static_json_generator;

internal static class DocHelper
{
    public static DocItems GetItems(string[] set)
    {
        var results = new DocItems();

        // TODO:

        return results;
    }

    public static string[][] SpecialSplit(string text, string left)
    {
        var list = new List<string[]>();
        var indexLeft = -1;
        indexLeft = text.IndexOf(left, indexLeft + 1) + left.Length;
        while (indexLeft > -1)
        {
            var block = new List<string>();

            var nextLine = DocHelper.NextLine(text, indexLeft);
            while (nextLine.StartsWith("//"))
            {
                block.Add(nextLine.Trim());
                indexLeft += nextLine.Length;
                nextLine = DocHelper.NextLine(text, indexLeft);
            }

            list.Add(block.ToArray());
            indexLeft = text.IndexOf(left, indexLeft + 1) + left.Length;
        }

        return list.ToArray();
    }

    public static string NextLine(string text, int index)
    {
        var indexLeft = text.IndexOf("\n", index);
        if (indexLeft == -1)
        {
            return text;
        }

        var line = string.Empty;
        var indexRight = text.IndexOf("\n", indexLeft + 1);

        if (indexRight > -1)
        {
            line = text.Substring(indexLeft + 1, indexRight - indexLeft);
        }
        else
        {
            line = text.Substring(indexLeft + 1);
        }

        return line;
    }
}
