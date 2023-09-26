/// 名称:标签字典
/// 编写者:sunfengchao 
/// 编写日期:2021-05-10
Class web.Entity.CT.CTLabel Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTLabel";

Property ID As %String;

/// 代码
Property LabelCode As %String;

/// 名称
Property LabelName As %String;

/// 是否激活 
Property LabelActiveFlag As %String;

/// 备注
Property LabelRemark As %String;

/// 表名 
Property LabelTableName As %String;

/// 分类
Property LabelCategory As %String;

}
