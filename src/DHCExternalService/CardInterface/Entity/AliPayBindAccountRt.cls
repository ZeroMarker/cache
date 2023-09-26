Class DHCExternalService.CardInterface.Entity.AliPayBindAccountRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLSEQUENCE = 0;

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// 账户代码
Property AccTypeCode As %String(TRUNCATE = 1);

/// 账户代码
Property AccNo As %String(TRUNCATE = 1);

/// 患者类型
Property PatientType As %String(TRUNCATE = 1);

/// 患者类型
Property PatientName As %String(TRUNCATE = 1);

/// 性别
Property Sex As %String(TRUNCATE = 1);

/// 出生日期
Property DOB As %String(TRUNCATE = 1);

/// 证件类型
Property IDType As %String(TRUNCATE = 1);

/// 证件号
Property IDNo As %String(TRUNCATE = 1);

/// 联系方式
Property Mobile As %String(TRUNCATE = 1);

/// 绑定HIS卡类型
Property BindCardTypeCode As %String(TRUNCATE = 1);

/// 绑定HIS卡号
Property BindCardNo As %String(TRUNCATE = 1);

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

/// 自助机终端号
Property TerminalID As %String(TRUNCATE = 1);

/// 交易流水号
Property TransactionId As %String(TRUNCATE = 1);

/// 患者ID
Property PatientID As %String(TRUNCATE = 1);

/// 签约标志(0=没有签约， 1= 签约)
Property SignedStatus As %String(TRUNCATE = 1);

}
