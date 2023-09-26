Class EMRservice.Parser.NIMacroItemsProperty Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "MacroItemsProperty";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property PropertyName As %String(XMLNAME = "PropertyName", XMLREF = 1) [ Required ];

Property PropertyValue As %String(XMLNAME = "PropertyValue", XMLREF = 1) [ Required ];

}
