Class DHCExternalService.CardInterface.Entity.RequestInfo Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// CardNo	卡号。
Property CardNo As %String(TRUNCATE = 1, XMLNAME = "CardNo");

/// CardType	卡类型(银行卡、就诊卡、医保卡)
Property CardType As %String(TRUNCATE = 1, XMLNAME = "CardType");

/// CardSecurityNo	卡校验码(银行卡可以为空)
Property CardSecurityNo As %String(TRUNCATE = 1, XMLNAME = "CardSecurityNo");

}
