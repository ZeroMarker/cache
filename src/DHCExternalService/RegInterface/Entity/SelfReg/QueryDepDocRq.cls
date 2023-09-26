Class DHCExternalService.RegInterface.Entity.SelfReg.QueryDepDocRq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
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

/// 二级科室查询此属性为科室代码,医生查询此属性为科室代码
Property DepartmentCode As %String(TRUNCATE = 1);

/// 科室类别 例如：1专科2 专家
Property DepartmentType As %String(TRUNCATE = 1);

/// 医生代码
Property DoctorCode As %String(TRUNCATE = 1);

/// 一级科室代码
Property DepartmentGroupCode As %String(TRUNCATE = 1);

/// 开始日期
Property StartDate As %String(TRUNCATE = 1);

/// 结束日期
Property EndDate As %String(TRUNCATE = 1);

/// 当天是否有排班
Property ScheduleFlag As %String(TRUNCATE = 1);

}
