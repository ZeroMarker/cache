/// 名称：评估表关联科室表
/// 描述：实体类
/// 编写者：基础数据平台组_Xuwenhu
/// 编写日期：2021-04-01
Class web.CDSSEntity.Access.AssConResult Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.Access.AssConResult";

Property RowId As %String;

/// 评估表指针
Property AssDR As %String;

/// 评估结果字典表
Property ResultDR As %String;

}
