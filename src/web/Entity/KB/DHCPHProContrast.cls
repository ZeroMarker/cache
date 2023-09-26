/// 名称: 商品名与His对照　
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期:  2016-10-11
Class web.Entity.KB.DHCPHProContrast Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHProContrast";

Property PHPCRowId As %String;

Property PHPCCode As %String;

Property PHPCDesc As %String;

Property PHPCHisCode As %String;

Property PHPCHisDesc As %String;

Property PHPCActiveFlag As %String;

Property PHPCSysFlag As %String;

}
