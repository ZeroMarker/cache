/// 名称:库存-库位实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期: 2012-9-5
Class web.Entity.CT.INCStkBin Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.INCStkBin";

//库位RowId

Property INCSBRowId As %String;

//库位代码

Property INCSBCode As %String;

//库位描述

Property INCSBDesc As %String;

}
