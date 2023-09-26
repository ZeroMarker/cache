Class DHCExternalService.RegInterface.Entity.SelfReg.QueryScheduleTimeInfoRq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
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

/// 科室代码
Property DepartmentCode As %String(TRUNCATE = 1);

/// 排班代码
Property ScheduleItemCode As %String(TRUNCATE = 1);

/// 医生代码
Property DoctorCode As %String(TRUNCATE = 1);

/// 出诊时段代码,S：上午,X：下午,Y：夜晚
Property RBASSessionCode As %String(TRUNCATE = 1);

/// 出诊日期
Property ServiceDate As %String(TRUNCATE = 1);

/// 亚专业代码
Property ClinicGroupDr As %String(TRUNCATE = 1);

}
