/// 名称:药学-用量实体类
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2016-8-26
Class web.Entity.CT.PHCDosage Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PHCDosage";

//RowId

Property PHCDORowId As %String;

//代码

Property PHCDOCode As %String;

//系数

Property PHCDOFactor As %String;

//中文描述

Property PHCDODesc1 As %String;

//英文描述

Property PHCDODesc2 As %String;

Property PHCDOCTUOMDR As %String;

Property PHCDOQty As %String;

}
