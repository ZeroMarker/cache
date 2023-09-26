/// 名称：评估表关联科室表
/// 描述：实体类
/// 编写者：基础数据平台组_xuwenhu
/// 编写日期：2021-04-01
Class web.CDSSEntity.Access.AssConDept Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.Access.AssConDept";

Property RowId As %String;

/// 评估表指针
Property AssDR As %String;

/// 科室指针（疾病分科字典表）
Property DeptDR As %String;

}
