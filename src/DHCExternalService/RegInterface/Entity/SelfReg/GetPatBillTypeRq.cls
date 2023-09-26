Class DHCExternalService.RegInterface.Entity.SelfReg.GetPatBillTypeRq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// 交易流水号
Property TransactionId As %String(TRUNCATE = 1);

/// 预约机构
Property ExtOrgCode As %String(TRUNCATE = 1);

/// 客户端类型
Property ClientType As %String(TRUNCATE = 1);

/// 终端编码
Property TerminalID As %String(TRUNCATE = 1);

/// 医院唯一编号
Property HospitalId As %String(TRUNCATE = 1);

/// 操作员代码
Property ExtUserID As %String(TRUNCATE = 1);

/// 病人ID
Property PatientID As %String(TRUNCATE = 1);

/// 卡类型
Property CardType As %String(TRUNCATE = 1);

/// 卡号码
Property CardNo As %String(TRUNCATE = 1);

/// 姓名
Property PatientName As %String(TRUNCATE = 1);

}
