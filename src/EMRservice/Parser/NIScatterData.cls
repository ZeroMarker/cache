/// Desc:打散数据-反序列化ScatterData
/// Creator:Candyxu
/// CreateDate:2014-6-26
Class EMRservice.Parser.NIScatterData Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "ScatterData";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property Sections As list Of EMRservice.Parser.NISection(XMLNAME = "Section", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

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
						s section = ##class(EMRservice.Parser.NISection).%New()
						d section.XMLDeserialize(reader)
						d ..Sections.Insert(section)
					}
					q:((reader.Name = "Component")&&(reader.NodeType = "endelement"))
				}
			}
			q:((reader.Name = "ScatterData")&&(reader.NodeType = "endelement"))
		}
}

}
