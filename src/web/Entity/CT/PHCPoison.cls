/// 名称:药学-管制药品分类实体类
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-9-5
Class web.Entity.CT.PHCPoison Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PHCPoison";

//管制药品分类RowId

Property PHCPORowId As %String;

//管制药品分类代码

Property PHCPOCode As %String;

//管制药品分类描述

Property PHCPODesc As %String;

//管制药品分类超出计数

Property PHCPOOTCFlag As %String;

//管制药品分类销售记录

Property PHCPOSaleRpt As %String;

//管制药品分类部门报告

Property PHCPOMHRpt As %String;

}
