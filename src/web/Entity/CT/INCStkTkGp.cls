/// 名称:库存-库存盘点分类实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期: 2012-9-5
Class web.Entity.CT.INCStkTkGp Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.INCStkTkGp";

//库存盘点分类RowId

Property INCTGRowId As %String;

//库存盘点分类代码

Property INCTGCode As %String;

//库存盘点分类描述

Property INCTGDesc As %String;

}
