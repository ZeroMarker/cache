/// Creator：基础数据平台-李可凡
/// CreatDate: 2019年11月15日
/// Description：医院实体类
/// Table：dbo.BTHospital
Class web.Entity.LAB.BTHospital Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.LAB.BTHospital";

/// RowId
Property RowID As %String;

/// 代码
Property Code As %String;

/// 名称
Property CName As %String;

/// 全称
Property FullDesc As %String;

/// 顺序
Property Sequence As %String;

/// 激活标识
Property Active As %String;

}
