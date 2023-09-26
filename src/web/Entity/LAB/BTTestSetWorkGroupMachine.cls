/// 名称:标准版检验-项目组合套关联工作小组
/// 编写者:基础数据平台组 - 钟荣枫
/// 编写日期: 2020-7-27
Class web.Entity.LAB.BTTestSetWorkGroupMachine Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.LAB.BTTestSetWorkGroupMachine";

Property RowID As %String;

Property TestSetDR As %String;

Property WorkGroupMachineDR As %String;

Property IsDefault As %String;

Property Sequence As %String;

Property Active As %String;

Property AlowedPrint As %String;

}
