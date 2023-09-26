/// Description：辅助问诊字典表
/// Table：UCT.WDT.CDSS.AssistConsult
Class web.CDSSEntity.CMKB.AssistConsultDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.AssistConsultDict";

/// RowId
Property RowId As %String;

/// 主要症状
Property MainSymptom As %String;

/// 科室
Property LocDesc As %String;

/// 部位
Property PartDesc As %String;

/// 伴随症状
Property CompanySym As %String;

/// 病因诱因
Property Cause As %String;

/// 发病缓急
Property Emergency As %String;

/// 程度
Property Degree As %String;

/// 性质
Property Nature As %String;

/// 缓解或加重因素
Property ReliefFactor As %String;

/// 精神
Property Spirit As %String;

/// 体力
Property Physical As %String;

/// 食欲
Property Appetite As %String;

/// 睡眠
Property Sleep As %String;

/// 大小便
Property Defecation As %String;

/// 使用标识（0编辑中，1已删除，2已审核）
Property UseFlag As %String;

/// 操作人员
Property UpdateUser As %String;

/// 操作时间
Property UpdateDate As %String;

}
