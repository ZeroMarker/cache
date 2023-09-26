/// 名称:手术和过程-手术分级
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2012-9-6
Class web.Entity.CT.ORCOperationCategory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ORCOperationCategory";

Property CATEGRowId As %String;

// 代码

Property CATEGCode As %String;

// 描述

Property CATEGDesc As %String;

// 开始日期

Property CATEGDateFrom As %String;

// 结束日期

Property CATEGDateTo As %String;

}
