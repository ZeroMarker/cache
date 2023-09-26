/// 科室货位导入实体类
/// Creator:陈莹 
/// CreatDate:2020-11-09
/// 基础数据平台组
Class web.BDPExt.INCStkBinEntity Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.BDPExt.INCStkBinEntity";

// 科室名称

Property locDesc As %String;

// 货位码

Property binDesc As %String;

// 药品代码

Property inciCode As %String;

// 药品名称

Property inciDesc As %String;

}
