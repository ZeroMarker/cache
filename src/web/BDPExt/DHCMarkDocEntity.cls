/// 名称:医生号别对照
/// 描述: 实体类
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2017-03-20
Class web.BDPExt.DHCMarkDocEntity Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.BDPExt.DHCMarkDocEntity";

//ID

Property ID As %String;

//号别代码

Property MarkdMarkDr As %String;

//号别描述

Property MarkdMarkDrName As %String;

//医生 工号

Property MarkdDocDr As %String;

//医生描述

Property MarkdDocDrName As %String;

//科室    

Property MarkddepDr As %String;

}
