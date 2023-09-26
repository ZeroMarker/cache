/// 名称:撤消最终结算原因 实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-6-25
Class web.Entity.CT.PACReasonForReverseFinDisch Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACReasonForReverseFinDisch";

Property RFDRowId As %String;

//代码

Property RFDCode As %String;

//描述

Property RFDDesc As %String;

//撤销账单

Property RFDCheckBed As %String;

}
