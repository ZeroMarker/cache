/// Creator:Xuwenhu
/// CreatDate:2022-11-30
/// Description：医用知识库评分表注册字段实体类
/// Table：CT.WDT.Access.AssBaseField
Class web.CDSSEntity.Access.AssBaseFieldItem Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Access.AssBaseFieldItem";

Property ABFIParRef As %String;

Property ABFIRowId As %String;

/// 选项描述
Property ItemValue As %String;

/// 选项得分
Property ItemScore As %String;

/// 互斥项
Property ItemExclusion As %String;

/// 跳转项
Property ItemJumpOption As %String;

/// 顺序
Property ItemSequence As %String;

/// 规则ID
Property RuleDR As %String;

/// 备注
Property Remarks As %String;

}
