/// Desc:打散数据-反序列化Simple
/// Creator:Candyxu
/// CreateDate:2014-6-26
Class EMRservice.Parser.NISimple Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Simple";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property Code As %String(XMLNAME = "Code", XMLREF = 1) [ Required ];

Property ValueCode As %String(XMLNAME = "ValueCode", XMLREF = 1) [ Required ];

Property DataValue As %String(XMLNAME = "DataValue", XMLREF = 1) [ Required ];

Property BindKBCode As %String(XMLNAME = "BindKBCode", XMLREF = 1) [ Required ];

Property KBNodeID As %String(XMLNAME = "KBNodeID", XMLREF = 1) [ Required ];

Property DataRef As %String(XMLNAME = "DataRef", XMLREF = 1) [ Required ];

Property Separator As %String(XMLNAME = "Separator", XMLREF = 1) [ Required ];

Property Type As %String(XMLNAME = "Type", XMLREF = 1) [ Required ];

Property CompositeConcept As EMRservice.Parser.NICompositeConcept(XMLNAME = "CompositeConcept", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Property CompositeMacro As EMRservice.Parser.NICompositeMacro(XMLNAME = "CompositeMacro", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Property CompositeToothImage As EMRservice.Parser.NICompositeToothImage(XMLNAME = "CompositeToothImage", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Property SourceCode As %String(XMLNAME = "SourceCode", XMLREF = 1) [ Required ];

Property SourceCCode As %String(XMLNAME = "SourceCCode", XMLREF = 1) [ Required ];

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
		if ((reader.Name = "MIString") && (reader.NodeType = "element"))
		{
			s ..Type = reader.Name
			while reader.Read()
			{
				if ((reader.Name = "Code") && (reader.NodeType = "element"))
				{
					s:(reader.MoveToAttributeName("Code")) ..Code = reader.Value
					s:(reader.MoveToAttributeName("SourceCode")) ..SourceCode = reader.Value
					s:(reader.MoveToAttributeName("CCode")) ..SourceCCode = reader.Value
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
					s ..DataValue = value
				}
				q:((reader.Name = "MIString") && (reader.NodeType = "endelement"))
			}	
		}		
		elseif (((reader.Name = "MINumber")||(reader.Name = "MIDateTime")) && (reader.NodeType = "element"))
		{
			s ..Type = reader.Name
			while reader.Read()
			{
				if ((reader.Name = "Code") && (reader.NodeType = "element"))
				{
					s:(reader.MoveToAttributeName("Code")) ..Code = reader.Value
					s:(reader.MoveToAttributeName("SourceCode")) ..SourceCode = reader.Value
					s:(reader.MoveToAttributeName("CCode")) ..SourceCCode = reader.Value
				}
				elseif((reader.Name  = "Value") && (reader.NodeType = "element"))
				{
					while reader.Read()
					{
						q:((reader.Name = "Value") && (reader.NodeType = "endelement"))
						s ..DataValue = ..DataValue_reader.Value
					}
				}
				q:(((reader.Name = "MINumber")||(reader.Name = "MIDateTime")) && (reader.NodeType = "endelement"))
			}	
		}
		elseif ((reader.Name = "MIMonoChoice") && (reader.NodeType = "element"))
		{
			s ..Type = reader.Name
			while reader.Read()
			{
				if ((reader.Name = "Code") && (reader.NodeType = "element"))
				{
					s:(reader.MoveToAttributeName("Code")) ..Code = reader.Value
					s:(reader.MoveToAttributeName("SourceCode")) ..SourceCode = reader.Value
					s:(reader.MoveToAttributeName("CCode")) ..SourceCCode = reader.Value
				}
				elseif((reader.Name  = "Value") && (reader.NodeType = "element"))
				{
					while reader.Read()
					{
						q:((reader.Name = "Value") && (reader.NodeType = "endelement"))
						if ((reader.Name = "Choice") && (reader.NodeType = "element"))
						{
							s:(reader.MoveToAttributeName("Code")) ..ValueCode = reader.Value
							s:(reader.MoveToAttributeName("DisplayName")) ..DataValue = reader.Value
						}
					}					
				}
				q:((reader.Name = "MIMonoChoice") && (reader.NodeType = "endelement"))
			}	
		}	
		elseif ((reader.Name = "MIMultiChoice") && (reader.NodeType = "element"))
		{
			s codeList = "",valueList = ""
			s ..Type = reader.Name
			while reader.Read()
			{
				if ((reader.Name = "Code") && (reader.NodeType = "element"))
				{
					s:(reader.MoveToAttributeName("Code")) ..Code = reader.Value
					s:(reader.MoveToAttributeName("SourceCode")) ..SourceCode = reader.Value
					s:(reader.MoveToAttributeName("CCode")) ..SourceCCode = reader.Value
				}
				elseif((reader.Name = "Separator") && (reader.NodeType = "element"))
				{
					while reader.Read()
					{
						q:((reader.Name = "Separator") && (reader.NodeType = "endelement"))
						s:(reader.NodeType = "chars") ..Separator = reader.Value
					}
				}
				elseif((reader.Name  = "Value") && (reader.NodeType = "element"))
				{
					while reader.Read()
					{
						q:((reader.Name  = "Value")&&(reader.NodeType = "endelement"))
						if ((reader.Name  = "Choice")&&(reader.NodeType = "element"))
						{
							s:(reader.MoveToAttributeName("Code")) codeList = codeList_$lb(reader.Value)
							s:(reader.MoveToAttributeName("DisplayName")) valueList = valueList_$lb(reader.Value)
						}
					}
				}
				if ((reader.Name = "MIMultiChoice") && (reader.NodeType = "endelement"))
				{
					s count = $ll(codeList)
					s code = "",value = ""
					for I=1:1:count
					{
						s:(I '= 1) code = code_..Separator,value = value_..Separator
						s code = code_$list(codeList,I)
						s value = value_$list(valueList,I)
					}
					s ..ValueCode = code,..DataValue = value
					q
				}
			}	
		}		
		elseif ((reader.Name = "MIDictionary") && (reader.NodeType = "element"))
		{
			s ..Type = reader.Name
			while reader.Read()
			{
				if ((reader.Name = "Code") && (reader.NodeType = "element"))
				{
					s:(reader.MoveToAttributeName("Code")) ..Code = reader.Value
					s:(reader.MoveToAttributeName("SourceCode")) ..SourceCode = reader.Value
					s:(reader.MoveToAttributeName("CCode")) ..SourceCCode = reader.Value
				}
				elseif((reader.Name  = "Value") && (reader.NodeType = "element"))
				{
					while reader.Read()
					{
						q:((reader.Name = "Value") && (reader.NodeType = "endelement"))
						if ((reader.Name = "Choice") && (reader.NodeType = "element"))
						{
							s:(reader.MoveToAttributeName("Code")) ..ValueCode = reader.Value
							s:(reader.MoveToAttributeName("DisplayName")) ..DataValue = reader.Value
							s:(reader.MoveToAttributeName("RowId")) ..DataRef = reader.Value
						}
					}
				}
				q:((reader.Name = "MIDictionary") && (reader.NodeType = "endelement"))
			}	
		}
		elseif ((reader.Name = "MILink") && (reader.NodeType = "element"))
		{
			s ..Type = reader.Name
			while reader.Read()
			{
				if ((reader.Name = "Code") && (reader.NodeType = "element"))
				{
					s:(reader.MoveToAttributeName("Code")) ..Code = reader.Value
					s:(reader.MoveToAttributeName("SourceCode")) ..SourceCode = reader.Value
					s:(reader.MoveToAttributeName("CCode")) ..SourceCCode = reader.Value
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
					s ..DataValue = value
				}
				q:((reader.Name = "MILink") && (reader.NodeType = "endelement"))
			}	
		}
		elseif ((reader.Name = "MIImage") && (reader.NodeType = "element"))
		{
			s ..Type = reader.Name
			while reader.Read()
			{
				if ((reader.Name = "Code") && (reader.NodeType = "element"))
				{
					s:(reader.MoveToAttributeName("Code")) ..Code = reader.Value
					s:(reader.MoveToAttributeName("SourceCode")) ..SourceCode = reader.Value
					s:(reader.MoveToAttributeName("CCode")) ..SourceCCode = reader.Value
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
					s ..DataValue = value
				}
				q:((reader.Name = "MIImage") && (reader.NodeType = "endelement"))	
			}
		}
		elseif ((reader.Name = "MIConcept") && (reader.NodeType = "element"))
		{
			s Concept = ##Class(EMRservice.Parser.NICompositeConcept).%New()
			d Concept.XMLDeserialize(reader)
			s ..CompositeConcept = Concept
			q:((reader.Name = "MIConcept") && (reader.NodeType = "endelement"))	
		}
		elseif ((reader.Name ="MIMacroObject") && (reader.NodeType = "element"))
		{
			s Macro = ##Class(EMRservice.Parser.NICompositeMacro).%New()
			d Macro.XMLDeserialize(reader)
			s ..CompositeMacro = Macro
			q:((reader.Name = "MIMacroObject") && (reader.NodeType = "endelement"))
		}
		elseif ((reader.Name ="MICrossToothImage") && (reader.NodeType = "element"))
		{
			s ToothImage = ##Class(EMRservice.Parser.NICompositeToothImage).%New()
			d ToothImage.XMLDeserialize(reader)
			s ..CompositeToothImage = ToothImage
			//q:((reader.Name = "MICrossToothImage") && (reader.NodeType = "endelement"))
		}
}

}
