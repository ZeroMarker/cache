Class EMRservice.XmlParser.NISimple Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Simple";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property Code As %String(XMLNAME = "Code", XMLREF = 1) [ Required ];

Property DisplayName As %String(XMLNAME = "DisplayName", XMLREF = 1) [ Required ];

Property SignatureLevel As %String(XMLNAME = "SignatureLevel", XMLREF = 1) [ Required ];

Property Type As %String(XMLNAME = "Type", XMLREF = 1) [ Required ];

Property BindCode As %String;

Property CompositeConcept As EMRservice.XmlParser.NICompositeConcept(XMLNAME = "CompositeConcept", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
	if ((reader.Name = "MIString") && (reader.NodeType = "element"))
	{
		s ..Type = reader.Name
		while reader.Read()
		{
			if ((reader.Name = "Code") && (reader.NodeType = "element"))
			{
				d reader.Read()
				s ..Code = reader.Value
				//w "Simple:    "_..Code_"||"_reader.Value,!
			}
			elseif((reader.Name  = "DisplayName") && (reader.NodeType = "element"))
			{
				d reader.Read()
				s displayName = $ZSTRIP(reader.Value,"*C") //去特殊字符
				s displayName = $zcvt(displayName,"O","UTF8")
				s ..DisplayName = reader.Value
				//w "Simple:    "_..DisplayName_"||"_reader.Value,!
			}
			elseif((reader.Name  = "SignatureLevel") && (reader.NodeType = "element"))
			{
				d reader.Read()
				s ..SignatureLevel = reader.Value
				//w "Simple:    "_..SignatureLevel_"||"_reader.Value,!
			}
			elseif((reader.Name  = "BindCode") && (reader.NodeType = "element"))
			{
				d reader.Read()
				s ..BindCode = reader.Value
				//w "Simple:    "_..BindCode_"||"_reader.Value,!
			}
			q:((reader.Name = "MIString") && (reader.NodeType = "endelement"))
		}
	}
	if ((reader.Name = "MIMonoChoice") && (reader.NodeType = "element"))
	{
		s ..Type = reader.Name
		while reader.Read()
		{
			if ((reader.Name = "Code") && (reader.NodeType = "element"))
			{
				d reader.Read()
				s ..Code = reader.Value
				//w "Simple:    "_..Code_"||"_reader.Value,!
			}
			elseif((reader.Name  = "DisplayName") && (reader.NodeType = "element"))
			{
				d reader.Read()
				s displayName = $ZSTRIP(reader.Value,"*C") //去特殊字符
				s displayName = $zcvt(displayName,"O","UTF8")
				s ..DisplayName = reader.Value
				//w "Simple:    "_..DisplayName_"||"_reader.Value,!
			}
			elseif((reader.Name  = "SignatureLevel") && (reader.NodeType = "element"))
			{
				d reader.Read()
				s ..SignatureLevel = reader.Value
				//w "Simple:    "_..SignatureLevel_"||"_reader.Value,!
			}
			elseif((reader.Name  = "BindCode") && (reader.NodeType = "element"))
			{
				d reader.Read()
				s ..BindCode = reader.Value
				//w "Simple:    "_..BindCode_"||"_reader.Value,!
			}
			q:((reader.Name = "MIMonoChoice") && (reader.NodeType = "endelement"))
		}
	}
	if ((reader.Name = "MIConcept") && (reader.NodeType = "element"))
	{
		s Concept = ##Class(EMRservice.XmlParser.NICompositeConcept).%New()
		d Concept.XMLDeserialize(reader)
		s ..CompositeConcept = Concept	
	}
	q:((reader.Name = "MIConcept") && (reader.NodeType = "endelement"))
}

}
