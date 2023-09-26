/// 名称: 草药毒性字典表
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-07-19
Class web.Entity.KB.DHCPHToxicity Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHToxicity";

Property ToxRowId As %String;

Property ToxCode As %String;

Property ToxDesc As %String;

Property ToxActiveFlag As %String;

}
