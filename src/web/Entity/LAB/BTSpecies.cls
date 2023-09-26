/// 名称:标准版检验-性别
/// 编写者:基础数据平台组 - 杨帆
/// 编写日期: 2019-11-25
Class web.Entity.LAB.BTSpecies Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.LAB.BTSpecies";

// RowId

Property RowID As %String;

// 代码

Property Code As %String;

// 性别

Property CName As %String;

// 怀孕

Property Pregnant As %String;

// HIS代码

Property HISCode As %String;

// STD代码

Property STDCode As %String;

}
