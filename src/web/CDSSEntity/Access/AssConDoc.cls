/// 名称:评估表关联文献表
/// 描述:实体类
/// 编写者:基础数据平台组 - 阚延新
/// 编写日期:2021-03-20
Class web.CDSSEntity.Access.AssConDoc Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Access.AssConDoc";

/// rowid
Property ID As %String;

/// 评估表指针
Property AssDR As %String;

/// 文献指针
Property DocDR As %String;

Property NewDocDR As %String;

}
