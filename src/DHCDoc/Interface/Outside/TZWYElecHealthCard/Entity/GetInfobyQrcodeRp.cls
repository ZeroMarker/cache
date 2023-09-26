Class DHCDoc.Interface.Outside.TZWYElecHealthCard.Entity.GetInfobyQrcodeRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Property success As %String(TRUNCATE = 1, XMLNAME = "success");

Property errcode As %String(TRUNCATE = 1, XMLNAME = "errcode");

Property msg As %String(TRUNCATE = 1, XMLNAME = "msg");

Property data As DHCDoc.Interface.Outside.TZWYElecHealthCard.Entity.List.GetinfobyQrcodeListRp;

}
