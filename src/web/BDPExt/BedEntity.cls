/// 床位数据导入实体类
/// Creator:陈莹 
/// CreatDate:2018-11-18
/// 基础数据平台组
Class web.BDPExt.BedEntity Extends (web.Entity.CT.PACRoom, web.Entity.CT.PACBed)
{

Parameter PersistentClassName = "web.BDPExt.BedEntity";

// 病区代码

Property WARDCode As %String;

// 病区名称

Property WARDDesc As %String;

// 床的高度

Property BEDHeight As %String;

// 床的宽度

Property BEDWidth As %String;

// 每行床位个数

Property BEDNumber As %String;

// 行与行间距

Property BEDYGap As %String;

// 列与列间距

Property BEDXGap As %String;

}
