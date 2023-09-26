/// 名称:药学-疗程实体类
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-8-30
Class web.Entity.CT.PHCDuration Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PHCDuration";

//RowId

Property PHCDURowId As %String;

//代码

Property PHCDUCode As %String;

//系数

Property PHCDUFactor As %String;

//中文描述

Property PHCDUDesc1 As %String;

//英文描述

Property PHCDUDesc2 As %String;

Property PHCDUDateFrom As %String;

Property PHCDUDateTo As %String;

/// 别名（导入用）--2017-02-20 
Property DataAlias As %String;

}
