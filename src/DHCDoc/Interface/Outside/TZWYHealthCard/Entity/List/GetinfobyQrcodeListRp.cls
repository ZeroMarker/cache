Class DHCDoc.Interface.Outside.TZWYHealthCard.Entity.List.GetinfobyQrcodeListRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Property cardNo As %String(TRUNCATE = 1, XMLNAME = "cardNo");

Property cardType As %String(TRUNCATE = 1, XMLNAME = "cardType");

Property name As %String(TRUNCATE = 1, XMLNAME = "name");

Property eId As %String(TRUNCATE = 1, XMLNAME = "eId");

Property phone As %String(TRUNCATE = 1, XMLNAME = "phone");

}
