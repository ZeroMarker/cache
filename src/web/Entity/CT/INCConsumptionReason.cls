/// 名称:库存-库存消耗原因实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期: 2012-8-29
Class web.Entity.CT.INCConsumptionReason Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.INCConsumptionReason";

//库存消耗原因RowId

Property CONRRowId As %String;

//库存消耗原因代码

Property CONRCode As %String;

//库存消耗原因描述

Property CONRDesc As %String;

}
