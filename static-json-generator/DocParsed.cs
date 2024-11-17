namespace static_json_generator;

public class DocParsed
{
    public List<DocNode> Nodes { get; set; } = new List<DocNode>();

    public void Parse(string text)
    {
        var blocks = DocHelper.SpecialSplit(text, "// @swagger");
        foreach (var block in blocks)
        {
            var node = DocNode.Parse(block);
            Nodes.Add(node);
        }
    }
}
