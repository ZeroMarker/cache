Class EMRservice.Parser.NIMacroItems Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "MacroItems";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property Name As %String(XMLNAME = "Name", XMLREF = 1) [ Required ];

Property MacroItemProperty As list Of EMRservice.Parser.NIMacroItemsProperty(XMLNAME = "ItemsProperty", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
	if ((reader.Name = "Column") && (reader.NodeType = "element"))
	{
		s count = reader.AttributeCount
		for i=1:1:count
		{
			d reader.MoveToAttributeIndex(i)
			if (reader.Name = "Name")
			{
				s ..Name = reader.Value
				continue
			}
			s property = ##Class(EMRservice.Parser.NIMacroItemsProperty).%New()
			s property.PropertyName = reader.Name
			s property.PropertyValue = reader.Value
			d ..MacroItemProperty.Insert(property)
		}	
		while reader.Read()
		{
			q:((reader.Name = "Column") && (reader.NodeType = "endelement"))
			if (reader.NodeType = "chars")
			{
				s property = ##Class(EMRservice.Parser.NIMacroItemsProperty).%New()
				s property.PropertyName = "Value"
				s property.PropertyValue = reader.Value
				d ..MacroItemProperty.Insert(property)
			}
				
		}
	}
}

}
