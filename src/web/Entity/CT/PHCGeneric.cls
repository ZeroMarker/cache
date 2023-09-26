/// 名称:药学-药品处方通用名实体类
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-9-5
Class web.Entity.CT.PHCGeneric Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PHCGeneric";

//药品处方通用名RowId

Property PHCGERowId As %String;

//药品处方通用名代码

Property PHCGECode As %String;

//药品处方通用名描述

Property PHCGEName As %String;

//药品处方通用名开始时间

Property PHCGEDateFrom As %String;

//药品处方通用名结束时间

Property PHCGEDateTo As %String;

/// 别名（导入用）--20170220
Property DataAlias As %String;

}
