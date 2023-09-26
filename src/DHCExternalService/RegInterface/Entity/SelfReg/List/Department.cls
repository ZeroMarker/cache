Class DHCExternalService.RegInterface.Entity.SelfReg.List.Department Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 科室代码
Property DepartmentCode As %String(TRUNCATE = 1);

/// 科室名称
Property DepartmentName As %String(TRUNCATE = 1);

/// 科室组标志,Y:科室组，具有二级科室
Property DepartmentGroup As %String(TRUNCATE = 1);

/// 上级科室代码,没有填-1
Property ParentId As %String(TRUNCATE = 1);

/// 科室简介
Property Description As %String(TRUNCATE = 1);

/// 科室地理位置
Property DepartmentAddress As %String(TRUNCATE = 1);

/// 科室年龄限制
Property DepartmentAgeLimit As %String(TRUNCATE = 1);

/// 院区ID
Property DepartmentHospCode As %String(TRUNCATE = 1);

/// 院区
Property DepartmentHospDesc As %String(TRUNCATE = 1);

}
