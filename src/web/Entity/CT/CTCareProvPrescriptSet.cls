/// 基础数据平台-李可凡
/// 2020年10月19日
/// 医护人员关联处方表
/// User.CTCareProvPrescriptSet
Class web.Entity.CT.CTCareProvPrescriptSet Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.CT.CTCareProvPrescriptSet";

Property CPPSParRef As %String;

Property CPPSRowId As %String;

Property CPPSChildsub As %String;

Property CPPSPrescriptSetDR As %String;

}
