/// 名称:库存-消毒分类实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期: 2012-9-5
Class web.Entity.CT.INCSterileCategory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.INCSterileCategory";

//消毒分类RowId

Property SCATRowId As %String;

//消毒分类代码

Property SCATCode As %String;

//消毒分类描述

Property SCATDesc As %String;

}
