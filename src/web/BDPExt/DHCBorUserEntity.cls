/// 名称:操作员诊区对照
/// 描述: 实体类
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2017-03-16
Class web.BDPExt.DHCBorUserEntity Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.BDPExt.DHCBorUserEntity";

Property ID As %String;

// 分诊区     

Property BoruBorDr As %String;

//操作员  工号

Property BoruUseDr As %String;

//姓名

Property BoruUseDrName As %String;

}
