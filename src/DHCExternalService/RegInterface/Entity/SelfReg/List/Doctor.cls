Class DHCExternalService.RegInterface.Entity.SelfReg.List.Doctor Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 医生代码
Property DoctorCode As %String(TRUNCATE = 1);

/// 医生名称
Property DoctorName As %String(TRUNCATE = 1);

/// 医生职称代码
Property DoctotLevelCode As %String(TRUNCATE = 1);

/// 医生职称
Property DoctorLevel As %String(TRUNCATE = 1);

/// 医生科室
Property DeptId As %String(TRUNCATE = 1);

/// 医生科室名称
Property DeptName As %String(TRUNCATE = 1);

/// 医生简介
Property Description As %String(TRUNCATE = 1);

}
