/// 名称:安全组医嘱状态实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-3-18
Class web.Entity.CT.SSGroupOrderStatus Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.SSGroupOrderStatus";

Property OSTATRowId As %String;

//OSTATParRef=SSGRPRowId

Property OSTATParRef As %String;

Property OSTATChildsub As %String;

Property OSTATOrdStatDR As %String;

/// Allow To D/C
Property OSTATAllowToDC As %String;

/// Allow To DC Paid
Property OSTATAllowToDCPaid As %String;

/// Allow To DC Packed
Property OSTATAllowToDCPacked As %String;

}
