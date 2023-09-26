/// 全局化词表关联的科室
Class web.Entity.MKB.MKBGDiagLoc Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.MKB.MKBGDiagLoc";

/// RowId
Property ID As %String;

/// 从生到死诊断表指针
Property DiaDR As %String;

/// 专业科室
Property ProfDeptDR As %String;

/// 科室频次
Property Frequency As %String;

}
