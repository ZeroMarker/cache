/// 医院楼层表-医院楼的子表 Entity
/// 基础数据平台-李可凡
/// 2020年8月31日
Class web.Entity.CT.CTLocBuildingFloor Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.CT.CTLocBuildingFloor";

Property CTLBFParRef As %String;

Property CTLBFChildsub As %String;

Property CTLBFRowId As %String;

Property CTLBFFloor As %String;

Property CTLBFDateFrom As %String;

Property CTLBFDateTo As %String;

Property CTLBFMark As %String;

}
