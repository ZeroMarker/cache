/// 名称:标准版检验-工作组（导入用）
/// 编写者:基础数据平台组 - 钟荣枫
/// 编写日期: 2020-1-21
Class web.BDPExt.BTWorkGroupEntity Extends web.Entity.LAB.BTWorkGroup
{

Parameter PersistentClassName = "web.BDPExt.BTWorkGroupEntity";

// 检验科室

Property DepartmentDesc As %String;

// 房间

Property RoomDesc As %String;

// 关联工作组

Property LinkWorkGroupDesc As %String;

}
