/// BDP  sunfengchao
/// 银行代码  实体类 
Class web.Entity.CT.CMCBankMas Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CMCBankMas";

Property CMCBMRowId As %String;

//银行代码

Property CMCBMCode As %String;

//银行名称

Property CMCBMDesc As %String;

//开始日期

Property CMCBMDateFrom As %String;

//结束日期

Property CMCBMDateTo As %String;

}
