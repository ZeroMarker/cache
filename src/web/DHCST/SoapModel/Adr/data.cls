Class web.DHCST.SoapModel.Adr.data Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "data";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property data As list Of web.DHCST.SoapModel.Adr.DataProperty(XMLNAME = "property", XMLPROJECTION = "ELEMENT");

Property children As list Of web.DHCST.SoapModel.Adr.children(XMLNAME = "children", XMLPROJECTION = "ELEMENT");

}
