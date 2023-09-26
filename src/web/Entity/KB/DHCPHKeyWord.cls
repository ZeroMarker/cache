/// 描述: 知识库关键表字典表
/// 编写者：谷雪萍
/// 编写日期: 2017-03-23
Class web.Entity.KB.DHCPHKeyWord Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHKeyWord";

Property PHKWRowId As %String;

Property PHKWCode As %String;

Property PHKWDesc As %String;

Property PHKWActiveFlag As %String;

Property PHKWSysFlag As %String;

Property PHKWTypeFlag As %String;

}
