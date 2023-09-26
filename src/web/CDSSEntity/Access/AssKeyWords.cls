/// 名称：评估表关键字表
/// 描述：实体类
/// 编写者：基础数据平台组_xuwenhu
/// 编写日期：2021-04-14
Class web.CDSSEntity.Access.AssKeyWords Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.Access.AssKeyWords";

Property RowId As %String;

/// 评估表指针
Property AssDR As %String;

/// 关键字
Property KeyWords As %String;

}
