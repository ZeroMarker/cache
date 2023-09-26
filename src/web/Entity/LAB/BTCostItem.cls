/// Creator：基础数据平台-李可凡
/// CreatDate: 2019年11月15日
/// Description：收费项目实体类
/// Table：dbo.BTCostItem
Class web.Entity.LAB.BTCostItem Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.LAB.BTCostItem";

/// RowId
Property RowID As %String;

/// 代码
Property Code As %String;

/// 名称
Property CName As %String;

/// 类型
Property ItemType As %String;

/// 价格
Property Price As %String;

/// 序号
Property Sequence As %String;

/// 激活标识
Property Active As %String;

}
