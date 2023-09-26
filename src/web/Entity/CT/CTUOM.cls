/// 名称:库存-调价原因实体类
/// 编写者:基础平台组-陈莹
/// 编写日期: 2012-8-30
Class web.Entity.CT.CTUOM Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTUOM";

//单位RowId

Property CTUOMRowId As %String;

//单位代码

Property CTUOMCode As %String;

//单位描述

Property CTUOMDesc As %String;

//国外描述

Property CTUOMForeignDesc As %String;

}
