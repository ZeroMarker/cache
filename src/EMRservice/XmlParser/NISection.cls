Class EMRservice.XmlParser.NISection Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Section";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property Code As %String(XMLNAME = "Code", XMLREF = 1) [ Required ];

Property Composites As list Of EMRservice.XmlParser.NIComposite(XMLNAME = "Composite", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Property Sections As list Of EMRservice.XmlParser.NISection(XMLNAME = "Section", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
	while reader.Read()
	{
		if ((reader.Name = "Code")&&(reader.NodeType = "element"))
		{
			if (reader.MoveToAttributeName("Code"))
			{
				s ..Code = reader.Value
			}
		}
		elseif ((reader.Name  = "Composite")&&(reader.NodeType = "element"))
		{
			
			s composite = ##Class(EMRservice.XmlParser.NIComposite).%New()
			d composite.XMLDeserialize(reader)
			d ..Composites.Insert(composite)
		}
		elseif ((reader.Name  = "Component")&&(reader.NodeType = "element"))
		{
			//不需处理子章节中的签名单元
			s componentCount = 1
			while reader.Read()
			{
				if (reader.Name  = "Component")&&(reader.NodeType = "element")
				{
					s componentCount = componentCount + 1
				}
				elseif ((reader.Name = "Component")&&(reader.NodeType = "endelement"))
				{
					s componentCount = componentCount - 1
					q:(componentCount < 1)
				}
			}
		}
		q:((reader.Name = "Section")&&(reader.NodeType = "endelement"))
	}
}

}
