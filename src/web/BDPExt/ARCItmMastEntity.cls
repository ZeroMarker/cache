/// 医嘱项导入实体类
/// Creator:陈莹 
/// CreatDate:2020-03-20
/// 基础数据平台组
Class web.BDPExt.ARCItmMastEntity Extends (web.Entity.CT.ARCItmMast, web.Entity.CT.ARCItemHosp, web.Entity.CT.ARCAlias)
{

Parameter PersistentClassName = "web.BDPExt.ARCItmMastEntity";

// 2019-2-16

Property OrdCat As %String;

Property BillGrp As %String;

Property ARCIMHOSPDR As %String;

}
