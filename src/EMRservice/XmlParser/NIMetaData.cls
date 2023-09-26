Class EMRservice.XmlParser.NIMetaData Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "MetaData";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property Sections As list Of EMRservice.XmlParser.NISection(XMLNAME = "Section", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
	while reader.Read()
	{
		if ((reader.Name="Component") && (reader.NodeType = "element"))
		{
			while reader.Read()
			{
				if ((reader.Name = "Section")&&(reader.NodeType = "element"))
				{
					s section = ##class(EMRservice.XmlParser.NISection).%New()
					d section.XMLDeserialize(reader)
					d ..Sections.Insert(section)
				}
				q:((reader.Name = "Component")&&(reader.NodeType = "endelement"))
			}
		}
		q:((reader.Name = "MetaData")&&(reader.NodeType = "endelement"))
	}
}

}
