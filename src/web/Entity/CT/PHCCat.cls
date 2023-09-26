/// 名称:药学-药理学分类实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期: 2012-9-5
Class web.Entity.CT.PHCCat Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PHCCat";

//药理学分类RowId

Property PHCCRowId As %String;

//药理学分类代码

Property PHCCCode As %String;

//药理学分类描述

Property PHCCDesc As %String;

}
