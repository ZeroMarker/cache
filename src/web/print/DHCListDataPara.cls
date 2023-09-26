Class web.print.DHCListDataPara Extends (%RegisteredObject, %XML.Adaptor)
{

Property name As %String(XMLPROJECTION = "ATTRIBUTE");

Property xcol As %String(XMLPROJECTION = "ATTRIBUTE");

Property yrow As %String(XMLPROJECTION = "ATTRIBUTE");

Property fontsize As %String(XMLPROJECTION = "ATTRIBUTE");

Property fontbold As %Boolean(XMLPROJECTION = "ATTRIBUTE");

Property fontname As %String(XMLPROJECTION = "ATTRIBUTE");

Property defaultvalue As %String(MAXLEN = 500, XMLPROJECTION = "ATTRIBUTE");

Property printvalue As %String(MAXLEN = 500, XMLPROJECTION = "ATTRIBUTE");

}
