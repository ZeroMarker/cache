Class DHCExternalService.CardInterface.Entity.AliPayFindPatientRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLSEQUENCE = 0;

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// 证件类型
Property IDType As %String(TRUNCATE = 1);

/// 证件号码
Property IDNo As %String(TRUNCATE = 1);

/// 患者姓名
Property PatientName As %String(TRUNCATE = 1);

/// 卡类型代码
Property CardTypeCode As %String(TRUNCATE = 1);

/// 卡号
Property PatientCard As %String(TRUNCATE = 1);

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

/// 自助机终端号
Property TerminalID As %String(TRUNCATE = 1);

/// 用户ID
Property PatientID As %String(TRUNCATE = 1);

}
