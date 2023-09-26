/// 基础数据平台-李可凡
/// 2020年3月23日
/// 医护人员关联管制药品分类表
/// User.CTCareProvPHCPoison
Class web.Entity.CT.CTCareProvPHCPoison Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.CT.CTCareProvPHCPoison";

Property CPPParRef As %String;

Property CPPRowId As %String;

Property CPPChildsub As %String;

Property CPPPHCPoisonDR As %String;

}
