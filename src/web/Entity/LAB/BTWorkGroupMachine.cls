/// Creator：基础数据平台-李可凡
/// CreatDate: 2019年11月15日
/// Description：工作小组实体类
/// Table：dbo.BTWorkGroupMachine
Class web.Entity.LAB.BTWorkGroupMachine Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.LAB.BTWorkGroupMachine";

/// RowID
Property RowID As %String;

/// 代码
Property Code As %String;

/// 名称
Property CName As %String;

/// 工作组
Property WorkGroupDR As %String;

/// 负责人
Property Leader As %String;

/// 联系电话
Property Telephone As %String;

/// 报告模板
Property ReportTempl As %String;

/// 所在房间
Property RoomDR As %String;

/// 序号
Property Sequence As %String;

/// 状态
Property Active As %String;

/// 通讯方式
Property CommDirection As %String;

/// 所属小组
Property OwnWorkGroupMachineDR As %String;

}
