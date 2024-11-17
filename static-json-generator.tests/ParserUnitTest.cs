namespace static_json_generator.tests
{
    public class ParserUnitTest
    {
        DocParser parser;

        public ParserUnitTest()
        {
            parser = new DocParser();
        }

        [Fact]
        public void ParseFirstFile()
        {
            var data = parser.Parse("..\\..\\..\\example\\HTTPServices\\SJGE_ПервыйПример\\Ext\\Module.bsl");

            Assert.Equal(data?.Nodes.Count, 5);
        }

        [Fact]
        public void ParseSecondFile()
        {
            var data = parser.Parse("..\\..\\..\\example\\HTTPServices\\SJGE_ВторойПример\\Ext\\Module.bsl");

            Assert.Equal(data?.Nodes.Count, 5);
        }
    }
}