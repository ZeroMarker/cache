Class DHCBILL.SelfPay.Entity.CompleteCharge.Res.PayDetails Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// PayModeCode 支付方式
Property PayModeCode As %String(TRUNCATE = 1);

/// PayAccountNo 支付账户或卡号
Property PayAccountNo As %String(TRUNCATE = 1);

/// PayAmt 支付金额
Property PayAmt As %String(TRUNCATE = 1);

/// PlatformNo 支付平台唯一号
Property PlatformNo As %GlobalCharacterStream;

/// OutPayNo 第三方交易唯一号
Property OutPayNo As %String(TRUNCATE = 1);

/// PayChannel 支付渠道
Property PayChannel As %String(TRUNCATE = 1);

/// POSPayStr MISPOS交易返回信息
Property POSPayStr As %String(TRUNCATE = 1);

/// PayDate 支付日期
Property PayDate As %String(TRUNCATE = 1);

/// PayTime 支付时间(hh:mm:ss)
Property PayTime As %String(TRUNCATE = 1);

}
