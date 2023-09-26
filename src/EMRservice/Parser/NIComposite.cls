/// Desc:打散数据-反序列化Composite
/// Creator:Candyxu
/// CreateDate:2014-6-26
Class EMRservice.Parser.NIComposite Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Composite";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property Code As %String(XMLNAME = "Code", XMLREF = 1) [ Required ];

Property Text As %String(XMLNAME = "Text", XMLREF = 1) [ Required ];

Property StyleText As %String(XMLNAME = "StyleText", XMLREF = 1) [ Required ];

Property KBNodeID As %String(XMLNAME = "KBNodeID", XMLREF = 1) [ Required ];

Property BindKBBaseID As %String(XMLNAME = "BindKBBaseID", XMLREF = 1) [ Required ];

Property SubItems As list Of EMRservice.Parser.NISimple(XMLNAME = "Simple", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
		while reader.Read()
		{
			if ((reader.Name = "Code") && (reader.NodeType = "element"))
			{
				s:(reader.MoveToAttributeName("Code")) ..Code = reader.Value
				s:(reader.MoveToAttributeName("KBNodeID")) ..KBNodeID = reader.Value
				s:(reader.MoveToAttributeName("BindKBBaseID")) ..BindKBBaseID = reader.Value
			}
			elseif((reader.Name  = "Text") && (reader.NodeType = "element"))
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
			elseif ((reader.Name = "SubItems") && (reader.NodeType = "element"))
			{
				while reader.Read()
				{
					q:((reader.Name = "SubItems") && (reader.NodeType = "endelement"))
					s simple = ##Class(EMRservice.Parser.NISimple).%New()
					d simple.XMLDeserialize(reader)
					d ..SubItems.Insert(simple)	
				}
			}
			q:((reader.Name = "Composite") && (reader.NodeType = "endelement"))	
		}
}

}
