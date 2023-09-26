/// 名称:分诊区号别对照维护
/// 描述: 实体类
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2017-03-16
Class web.BDPExt.DHCDepMarkEntity Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.BDPExt.DHCDepMarkEntity";

Property ID As %String;

// 分诊区     

Property DepmBorDr As %String;

// 科室  --> 科室病区

Property DepmDepDr As %String;

// 号别   -->医护人员

Property DepmMarkDr As %String;

// 号别  

Property DepmMarkDrName As %String;

//状态  1

Property DepmState As %String;

//标志 Y/N

Property DepmSign As %String;

//是否报到 Y/N

Property DepmCheckin As %String;

}
