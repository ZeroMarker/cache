Class DHCExternalService.RegInterface.Entity.SelfReg.QueryPatListRq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
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

/// 医院唯一编号
Property HospitalId As %String(TRUNCATE = 1);

/// 操作员代码
Property ExtUserID As %String(TRUNCATE = 1);

/// 卡号
Property PatientCard As %String(TRUNCATE = 1);

/// 卡类型
Property CardType As %String(TRUNCATE = 1);

/// 病人id
Property PatientID As %String(TRUNCATE = 1);

Property DoctorCode As %String(TRUNCATE = 1);

Property DepartmentCode As %String(TRUNCATE = 1);

Property ScheduleItemCode As %String(TRUNCATE = 1);

}
