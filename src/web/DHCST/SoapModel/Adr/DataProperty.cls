Class web.DHCST.SoapModel.Adr.DataProperty Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "property";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property name As %String(XMLNAME = "name", XMLPROJECTION = "XATTRIBUTE");

/// 值域
Property value As %String(XMLNAME = "value", XMLPROJECTION = "XATTRIBUTE");

}
