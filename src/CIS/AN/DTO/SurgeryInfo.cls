Class CIS.AN.DTO.SurgeryInfo Extends %RegisteredObject
{

/// 术者科室
Property SurgeonDept As %String;

/// 手术名称
Property OperDesc As %String;

/// 手术等级
Property OperClass As %String;

/// 切口类型
Property BladeType As %String;

/// 手术部位
Property BodySite As %String;

/// 主刀
Property Surgeon As %String;

/// 一助
Property Assist1 As %String;

/// 二助
Property Assist2 As %String;

/// 术前诊断
Property PrevDiagnosis As %String;

/// 术后诊断
Property PostDiagnosis As %String;

}
