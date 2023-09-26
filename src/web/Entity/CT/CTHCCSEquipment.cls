/// 名称:医呼通设备
/// 编写者:基础数据平台组 - 杨帆
/// 编写日期: 2020-12-17
Class web.Entity.CT.CTHCCSEquipment Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTHCCSEquipment";

// EQRowId

Property EQRowId As %String;

// 设备代码

Property EQCode As %String;

// 设备ID

Property EQId As %String;

// 是否启用

Property EQActiveFlag As %String;

// 备注

Property EQRemarks As %String;

}
