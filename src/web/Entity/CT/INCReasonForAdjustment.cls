/// 名称:库存-调价原因实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期: 2012-8-29
Class web.Entity.CT.INCReasonForAdjustment Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.INCReasonForAdjustment";

//调价原因RowId

Property ADJRowId As %String;

//调价原因代码

Property ADJCode As %String;

//调价原因描述

Property ADJDesc As %String;

}
