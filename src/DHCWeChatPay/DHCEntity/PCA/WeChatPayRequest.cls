Class DHCWeChatPay.DHCEntity.PCA.WeChatPayRequest Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 0;

/// phoneNo	手机号
Property phoneNo As %String(TRUNCATE = 1);

/// terminalId	校验码
Property terminalId As %String(TRUNCATE = 1);

Property terminalType As %String(TRUNCATE = 1);

Property hospitalId As %String(TRUNCATE = 1);

Property patientCard As %String(TRUNCATE = 1);

Property patientId As %String(TRUNCATE = 1);

Property bankTradeInfo As DHCWeChatPay.DHCEntity.PCA.BankPayResult(XMLPROJECTION = "ELEMENT");

Property admId As %String(TRUNCATE = 1);

Property patAmt As %String(TRUNCATE = 1);

Property hisTradeNo As %String(TRUNCATE = 1);

Property userCode As %String(TRUNCATE = 1);

Property InvInfo As %String(TRUNCATE = 1);

}
