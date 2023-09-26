/// 名称:库存-库存返回原因实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期: 2012-9-5
Class web.Entity.CT.INCStkCat Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.INCStkCat";

//库存返回原因RowId

Property INCSCRowId As %String;

//库存返回原因代码

Property INCSCCode As %String;

//库存返回原因描述

Property INCSCDesc As %String;

}
