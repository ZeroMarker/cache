Class DHCBILL.SelfPay.Entity.CompleteCharge.Req.PayDetails Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// PayModeCode 支付方式
Property PayModeCode As %String(TRUNCATE = 1);

/// TradeChannel 接入方标识(用于区分对账交易来源)
Property TradeChannel As %String(TRUNCATE = 1);

/// PayAccountNo 支付账户或卡号
Property PayAccountNo As %String(TRUNCATE = 1);

/// PayAmt 支付金额
Property PayAmt As %String(TRUNCATE = 1);

/// PlatformNo 支付平台唯一号
Property PlatformNo As %String(TRUNCATE = 1);

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
