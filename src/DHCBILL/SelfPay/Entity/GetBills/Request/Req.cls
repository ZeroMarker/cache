/// /对账数据入参类
Class DHCBILL.SelfPay.Entity.GetBills.Request.Req Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// TradeCode 业务代码 
Property TradeCode As %String(TRUNCATE = 1);

/// StartDate 开始日期
Property StartDate As %String(TRUNCATE = 1);

/// EndDate 结束日期
Property EndDate As %String(TRUNCATE = 1);

/// PayMode 支付方式日期
Property PayMode As %String(TRUNCATE = 1);

/// HospitalID 院区
Property HospitalID As %String(TRUNCATE = 1);

/// TradeChannel 支付渠道
Property TradeChannel As %String(TRUNCATE = 1);

}
