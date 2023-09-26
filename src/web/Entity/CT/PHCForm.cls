/// 名称:药学-药品剂型实体类
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-9-5
Class web.Entity.CT.PHCForm Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PHCForm";

//药品剂型RowId

Property PHCFRowId As %String;

//药品剂型代码

Property PHCFCode As %String;

//药品剂型描述

Property PHCFDesc As %String;

/// 别名（导入用）--20170220
Property DataAlias As %String;

}
