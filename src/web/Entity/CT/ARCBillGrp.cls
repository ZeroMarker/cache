/// Creator:基础数据平台组 孙凤超
/// CreateDate:2012-08-20
/// Desc:账单组
Class web.Entity.CT.ARCBillGrp Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ARCBillGrp";

Property ARCBGRowId As %String;

Property ARCBGCode As %String;

Property ARCBGAbbrev As %String;

Property ARCBGDesc As %String;

Property TARCBGAbbrev As %String;

}
