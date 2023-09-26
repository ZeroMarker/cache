Class DHCExternalService.RegInterface.Entity.SelfReg.FindPatientCardRq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

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

/// 终端编码
Property TerminalID As %String(TRUNCATE = 1);

/// 卡号
Property PatientCard As %String(TRUNCATE = 1);

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

}
