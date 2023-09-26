/// Desc:打散数据-反序列化Section
/// Creator:Candyxu
/// CreateDate:2014-6-26
Class EMRservice.Parser.NISection Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Section";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property Code As %String(XMLNAME = "Code", XMLREF = 1) [ Required ];

Property Text As %String(XMLNAME = "Text", XMLREF = 1) [ Required ];

Property StyleText As %String(XMLNAME = "StyleText", XMLREF = 1) [ Required ];

Property Composites As list Of EMRservice.Parser.NIComposite(XMLNAME = "Composite", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Property Sections As list Of EMRservice.Parser.NISection(XMLNAME = "Section", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
		while reader.Read()
		{
			if ((reader.Name = "Code")&&(reader.NodeType = "element"))
			{
				s:(reader.MoveToAttributeName("Code")) ..Code = reader.Value
			}
			elseif((reader.Name  = "Text")&&(reader.NodeType = "element"))
			{
				s value = ""
				while reader.Read()
				{
					q:((reader.Name = "Text") && (reader.NodeType = "endelement"))
					if (reader.NodeType = "element")
					{
						s value = value_"<"_reader.Name
						for i=1:1:reader.AttributeCount
						{
							d reader.MoveToAttributeIndex(i)
							s value = value_" "_reader.Name_"="""_reader.Value_""""
						}
						s value = value_">"
					}
					elseif (reader.NodeType = "endelement")
					{
						s value = value_"</"_reader.Name_">"
					}
					elseif (reader.NodeType = "chars")
					{
						s value = value_reader.Value
					}
				}
				s ..Text = value
			}
			elseif((reader.Name  = "StyleText")&&(reader.NodeType = "element"))
			{
				s value = ""
				while reader.Read()
				{
					q:((reader.Name = "StyleText") && (reader.NodeType = "endelement"))
					if (reader.NodeType = "element")
					{
						s value = value_"<"_reader.Name
						for i=1:1:reader.AttributeCount
						{
							d reader.MoveToAttributeIndex(i)
							s value = value_" "_reader.Name_"="""_reader.Value_""""
						}
						s value = value_">"
					}
					elseif (reader.NodeType = "endelement")
					{
						s value = value_"</"_reader.Name_">"
					}
					elseif (reader.NodeType = "chars")
					{
						s value = value_reader.Value
					}
				}
				s ..StyleText = value			
			}				
			elseif ((reader.Name = "Component")&&(reader.NodeType = "element"))
			{
				while reader.Read()
				{
					if ((reader.Name = "Section")&&(reader.NodeType = "element"))
					{
						s section = ##Class(EMRservice.Parser.NISection).%New()
						d section.XMLDeserialize(reader)
						d ..Sections.Insert(section)
					}
					q:((reader.Name = "Component")&&(reader.NodeType = "endelement"))
				}
			}
			elseif ((reader.Name  = "Composite")&&(reader.NodeType = "element"))
			{
				
				s composite = ##Class(EMRservice.Parser.NIComposite).%New()
				d composite.XMLDeserialize(reader)
				d ..Composites.Insert(composite)
			}
			q:((reader.Name = "Section")&&(reader.NodeType = "endelement"))
		}
}

}
