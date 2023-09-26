Class DHCExternalService.RegInterface.Entity.SelfReg.QueryStopDoctorRq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// 预约机构
Property ExtOrgCode As %String(TRUNCATE = 1);

/// 客户端类型
Property ClientType As %String(TRUNCATE = 1);

/// 医院唯一编号
Property HospitalId As %String(TRUNCATE = 1);

/// 操作员代码
Property ExtUserID As %String(TRUNCATE = 1);

/// 号源开始日期
Property StartDate As %String(TRUNCATE = 1);

/// 号源结束日期
Property EndDate As %String(TRUNCATE = 1);

Property DepartmentCode As %String(TRUNCATE = 1);

}
