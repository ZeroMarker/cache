/// 名称:项目组合套界面-关联标本类型窗口
/// 编写者:基础数据平台-李可凡
/// 编写日期: 2020-9-17
Class web.Entity.LAB.BTTestSetSpecimen Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.LAB.BTTestSetSpecimen";

Property RowID As %String;

Property TestSetDR As %String;

Property SpecimenDR As %String;

Property ContainerDR As %String;

Property MergeType As %String;

Property IsDefault As %String;

Property Sequence As %String;

}
