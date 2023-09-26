/// 名称:分诊区科室对照维护
/// 描述: 实体类
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2017-03-16
Class web.BDPExt.DHCExaBorDepEntity Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.BDPExt.DHCExaBorDepEntity";

Property ID As %String;

// 分诊区 dr       

Property BordBorDr As %String;

// 科室  string 

Property BordDepDr As %String;

// 备注

Property BordMemo As %String;

}
