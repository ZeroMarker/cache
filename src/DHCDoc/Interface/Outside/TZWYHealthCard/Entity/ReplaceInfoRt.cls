Class DHCDoc.Interface.Outside.TZWYHealthCard.Entity.ReplaceInfoRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Property eleCardCode As %String(TRUNCATE = 1, XMLNAME = "eleCardCode");

Property phone As %String(TRUNCATE = 1, XMLNAME = "phone");

Property address As %String(TRUNCATE = 1, XMLNAME = "address");

Property depositBank As %String(TRUNCATE = 1, XMLNAME = "depositBank");

Property bankCardNo As %String(TRUNCATE = 1, XMLNAME = "bankCardNo");

Property appid As %String(TRUNCATE = 1, XMLNAME = "appid");

Property time As %String(TRUNCATE = 1, XMLNAME = "time");

Property noncestr As %String(TRUNCATE = 1, XMLNAME = "nonce_str");

Property sign As %String(TRUNCATE = 1, XMLNAME = "sign");

}
