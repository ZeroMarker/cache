/// 名称:分诊区诊室对照维护
/// 描述: 实体类
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2017-03-16
Class web.BDPExt.DHCBorExaRoomEntity Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.BDPExt.DHCBorExaRoomEntity";

Property ID As %String;

/// 分诊区     
Property BorDr As %String;

/// 诊室
Property BorExaRoomDr As %String;

/// 备注 
Property Memo As %String;

}
