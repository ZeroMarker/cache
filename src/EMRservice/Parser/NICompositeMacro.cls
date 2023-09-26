Class EMRservice.Parser.NICompositeMacro Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "CompositeMacro";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property Code As %String(XMLNAME = "Code", XMLREF = 1) [ Required ];

Property DisplayName As %String(XMLNAME = "DisplayName", XMLREF = 1) [ Required ];

Property MacroID As %String(XMLNAME = "MacroID", XMLREF = 1) [ Required ];

Property Type As %String(XMLNAME = "Type", XMLREF = 1) [ Required ];

Property Text As %String(XMLNAME = "Text", XMLREF = 1) [ Required ];

Property StyleText As %String(XMLNAME = "StyleText", XMLREF = 1) [ Required ];

Property MacroItems As list Of EMRservice.Parser.NIMacroItems(XMLNAME = "ItemsProperty", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
		while reader.Read()
		{
			if ((reader.Name = "Code") && (reader.NodeType = "element"))
			{
				s:(reader.MoveToAttributeName("Code")) ..Code = reader.Value
				s:(reader.MoveToAttributeName("DisplayName")) ..DisplayName = reader.Value
			}
			elseif((reader.Name  = "Value") && (reader.NodeType = "element"))
			{
				s value = ""
				while reader.Read()
				{
					q:((reader.Name = "Value") && (reader.NodeType = "endelement"))
					if (reader.NodeType = "element")
					{
						s value = value_"<"_reader.Name
						for i=1:1:reader.AttributeCount
						{
							s value = value_reader.Name_"="""_reader.Value_""""
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
			elseif((reader.Name  = "StyleText") && (reader.NodeType = "element"))
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
							s value = value_reader.Name_"="""_reader.Value_""""
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
			elseif ((reader.Name = "Macro") && (reader.NodeType = "element"))
			{
				s:(reader.MoveToAttributeName("ID")) ..MacroID = reader.Value
				s:(reader.MoveToAttributeName("Type")) ..Type = reader.Value
				while reader.Read()
				{
					q:((reader.Name = "Macro") && (reader.NodeType = "endelement"))
					s Items = ##Class(EMRservice.Parser.NIMacroItems).%New()
					d Items.XMLDeserialize(reader)
					d ..MacroItems.Insert(Items)
				}	
			}			
			q:((reader.Name = "MIMacroObject") && (reader.NodeType = "endelement"))	
		}
}

}
