Class EMRservice.XmlParser.NIComposite Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Composite";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property Code As %String(XMLNAME = "Code", XMLREF = 1) [ Required ];

Property SubItems As list Of EMRservice.XmlParser.NISimple(XMLNAME = "Simple", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
	while reader.Read()
	{
		if ((reader.Name = "Code") && (reader.NodeType = "element"))
		{
			s:(reader.MoveToAttributeName("Code")) ..Code = reader.Value
		}	
		elseif ((reader.Name = "SubItems") && (reader.NodeType = "element"))
		{
			while reader.Read()
			{
				q:((reader.Name = "SubItems") && (reader.NodeType = "endelement"))
				s simple = ##Class(EMRservice.XmlParser.NISimple).%New()
				d simple.XMLDeserialize(reader)
				d ..SubItems.Insert(simple)	
			}
		}
		q:((reader.Name = "Composite") && (reader.NodeType = "endelement"))
	}
}

}
