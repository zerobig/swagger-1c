namespace static_json_generator;

public class DocParser
{
    private string text;

    public void Load(string filename)
    {
        text = System.IO.File.ReadAllText(filename);
    }

    public void LoadText(string text)
    {
        this.text = text;
    }

    public DocParsed Parse(string filename = null)
    {
        if (filename != null)
        {
            this.Load(filename);
        }

        var result = new DocParsed();
        result.Parse(text);
        return result;
    }
}
