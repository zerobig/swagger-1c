namespace static_json_generator;

public class DocNode
{
    private static DocNode GetSpecificType(DocItems items)
    {
        foreach (var item in items.List)
        {
            switch (item.Key)
            {
                case "tags":
                    return new DocTags();
                case "components":
                    return new DocComponents();
                default:
                    return new DocMethod();
            }
        }

        return new DocNode();
    }

    internal virtual void Parse(DocItems items)
    {
        // TODO:
    }

    public static DocNode Parse(string[] set)
    {
        var items = DocHelper.GetItems(set);

        var result = DocNode.GetSpecificType(items);
        result.Parse(items);

        return result;
    }
}
