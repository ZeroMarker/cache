/// Desc:打散数据-反序列化MICrossToothImage
/// Creator:niucaicai
/// CreateDate:2020-07-08
Class EMRservice.Parser.NICompositeToothImage Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "CrossToothImage";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property Code As %String(XMLNAME = "Code", XMLREF = 1) [ Required ];

Property SourceCode As %String(XMLNAME = "SourceCode", XMLREF = 1) [ Required ];

Property SourceCCode As %String(XMLNAME = "SourceCCode", XMLREF = 1) [ Required ];

Property KBNodeID As %String(XMLNAME = "KBNodeID", XMLREF = 1) [ Required ];

Property DisplayName As %String(XMLNAME = "DisplayName", XMLREF = 1) [ Required ];

Property Text As %String(XMLNAME = "Text", XMLREF = 1) [ Required ];

Property ShowMode As %String(XMLNAME = "ShowMode", XMLREF = 1) [ Required ];

Property ToothItems As list Of EMRservice.Parser.NIToothItems(XMLNAME = "Tooth", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
	while reader.Read()
	{
		if ((reader.Name = "Code") && (reader.NodeType = "element"))
		{
			s:(reader.MoveToAttributeName("Code")) ..Code = reader.Value
			s:(reader.MoveToAttributeName("SourceCode")) ..SourceCode = reader.Value
			s:(reader.MoveToAttributeName("CCode")) ..SourceCCode = reader.Value
			s:(reader.MoveToAttributeName("KBNodeID")) ..KBNodeID = reader.Value
			s:(reader.MoveToAttributeName("DisplayName")) ..DisplayName = reader.Value
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
		elseif ((reader.Name = "SubItems") && (reader.NodeType = "element"))
		{
			s:(reader.MoveToAttributeName("ShowMode")) ..ShowMode = reader.Value
			while reader.Read()
			{
				if ((reader.Name = "Tooth") && (reader.NodeType = "element"))
				{
					s TDisplayName = ""
					s TQuadrantType = ""
					s:(reader.MoveToAttributeName("DisplayName")) TDisplayName = reader.Value
					s:(reader.MoveToAttributeName("QuadrantType")) TQuadrantType = reader.Value
					s ToothItems = ##Class(EMRservice.Parser.NIToothItems).%New()
					d ToothItems.XMLDeserialize(reader,TDisplayName,TQuadrantType)
					d ..ToothItems.Insert(ToothItems)
				}
				q:((reader.Name = "SubItems") && (reader.NodeType = "endelement"))	
			}
		}			
		q:((reader.Name = "MICrossToothImage") && (reader.NodeType = "endelement"))	
	}
}

}
