/// 名称:标准版检验-工作小组（导入用）
/// 编写者:基础数据平台组 - 钟荣枫
/// 编写日期: 2020-1-21
Class web.BDPExt.BTWorkGroupMachineEntity Extends web.Entity.LAB.BTWorkGroupMachine
{

Parameter PersistentClassName = "web.BDPExt.BTWorkGroupMachineEntity";

// 工作组

Property WorkGroupDesc As %String;

// 所在房间

Property RoomDesc As %String;

// 所在工作小组

Property OwnWorkGroupMachineDesc As %String;

}
