/// 知识库标识和HIS科室对照
Class web.Entity.KB.DHCPHLibContrast Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHLibContrast";

Property PHLCRowId As %String;

Property PHLCLibCode As %String;

Property PHLCLibDesc As %String;

Property PHLCHisLocCode As %String;

Property PHLCHisLocDesc As %String;

}
