Class web.DHCST.SoapModel.Adr.children Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "children";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property name As %String(XMLNAME = "name", XMLPROJECTION = "XATTRIBUTE");

Property child As list Of web.DHCST.SoapModel.Adr.child(XMLNAME = "child", XMLPROJECTION = "ELEMENT");

}
