/// Desc:打散数据-反序列化Area
/// Creator:niucaicai
/// CreateDate:2020-07-08
Class EMRservice.Parser.NIToothItemArea Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Area";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property InCode As %String(XMLNAME = "InCode", XMLREF = 1) [ Required ];

Property Code As %String(XMLNAME = "Code", XMLREF = 1) [ Required ];

Property DisplayName As %String(XMLNAME = "DisplayName", XMLREF = 1) [ Required ];

Property ScriptMode As %String(XMLNAME = "ScriptMode", XMLREF = 1) [ Required ];

Property CodeSystem As %String(XMLNAME = "CodeSystem", XMLREF = 1) [ Required ];

Property CodeSystemName As %String(XMLNAME = "CodeSystemName", XMLREF = 1) [ Required ];

Property Area As %String(XMLNAME = "Area", XMLREF = 1) [ Required ];

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
	if ((reader.Name  = "Area") && (reader.NodeType = "element"))
	{
		s:(reader.MoveToAttributeName("InCode")) ..InCode = reader.Value
		s:(reader.MoveToAttributeName("Code")) ..Code = reader.Value
		s:(reader.MoveToAttributeName("DisplayName")) ..DisplayName = reader.Value
		s:(reader.MoveToAttributeName("ScriptMode")) ..ScriptMode = reader.Value
		s:(reader.MoveToAttributeName("CodeSystem")) ..CodeSystem = reader.Value
		s:(reader.MoveToAttributeName("CodeSystemName")) ..CodeSystemName = reader.Value
		s value = ""
		while reader.Read()
		{
			q:((reader.Name = "Area") && (reader.NodeType = "endelement"))
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
		s ..Area = value
	}
}

}
