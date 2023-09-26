/// Desc:打散数据-反序列化Tooth
/// Creator:niucaicai
/// CreateDate:2020-07-08
Class EMRservice.Parser.NIToothItems Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Tooth";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property DisplayName As %String(XMLNAME = "DisplayName", XMLREF = 1) [ Required ];

Property QuadrantType As %String(XMLNAME = "QuadrantType", XMLREF = 1) [ Required ];

Property InCode As %String(XMLNAME = "InCode", XMLREF = 1) [ Required ];

Property AreaType As %String(XMLNAME = "AreaType", XMLREF = 1) [ Required ];

Property Code As %String(XMLNAME = "Code", XMLREF = 1) [ Required ];

Property PDisplayName As %String(XMLNAME = "DisplayName", XMLREF = 1) [ Required ];

Property CodeSystem As %String(XMLNAME = "CodeSystem", XMLREF = 1) [ Required ];

Property CodeSystemName As %String(XMLNAME = "CodeSystemName", XMLREF = 1) [ Required ];

Property Position As %String(XMLNAME = "Position", XMLREF = 1) [ Required ];

Property ToothItemAreas As list Of EMRservice.Parser.NIToothItemArea(XMLNAME = "Area", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Method XMLDeserialize(ByRef reader As %XML.TextReader, TDisplayName As %String, TQuadrantType As %String)
{
	s ..DisplayName = TDisplayName
	s ..QuadrantType = TQuadrantType
	while reader.Read()
	{
		if ((reader.Name  = "Position") && (reader.NodeType = "element"))
		{
			s:(reader.MoveToAttributeName("InCode")) ..InCode = reader.Value
			s:(reader.MoveToAttributeName("AreaType")) ..AreaType = reader.Value
			s:(reader.MoveToAttributeName("Code")) ..Code = reader.Value
			s:(reader.MoveToAttributeName("DisplayName")) ..PDisplayName = reader.Value
			s:(reader.MoveToAttributeName("CodeSystem")) ..CodeSystem = reader.Value
			s:(reader.MoveToAttributeName("CodeSystemName")) ..CodeSystemName = reader.Value
			s value = ""
			while reader.Read()
			{
				q:((reader.Name = "Position") && (reader.NodeType = "endelement"))
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
			s ..Position = value
		}
		elseif((reader.Name  = "Area") && (reader.NodeType = "element"))
		{
			//q:((reader.Name = "Area") && (reader.NodeType = "endelement"))
			s ToothItemAreas = ##Class(EMRservice.Parser.NIToothItemArea).%New()
			d ToothItemAreas.XMLDeserialize(reader)
			d ..ToothItemAreas.Insert(ToothItemAreas)
		}
		q:((reader.Name = "Tooth") && (reader.NodeType = "endelement"))
	}
}

}
