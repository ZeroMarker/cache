Class web.DHCST.SoapModel.Adr.child Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "child";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property prop As list Of web.DHCST.SoapModel.Adr.DataProperty(XMLNAME = "property", XMLPROJECTION = "ELEMENT");

}
