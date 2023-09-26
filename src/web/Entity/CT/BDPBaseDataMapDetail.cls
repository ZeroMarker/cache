/// Function:数据对照详情表
/// CreateDate:2020-01-03
/// Creator: sunfengchao
Class web.Entity.CT.BDPBaseDataMapDetail Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.BDPBaseDataMapDetail";

Property BDPMapDRowId As %String;

/// 东华基础码表名称  非空
Property BDPMapDBaseTabNameDR As %String;

/// 字典或者文本的代码
Property BDPMapDTableCode As %String;

/// HIS表数据代码  
Property BDPMapDHisDicCode As %String;

/// HIS表数据描述
Property BDPMapDHisDicDesc As %String;

/// 外部代码  
Property BDPMapDExtDicCode As %String;

/// 外部名称
Property BDPMapDExtDicDesc As %String;

/// 外部名称
Property BDPMapDActive As %String;

/// 是否外部到His对照
Property BDPMapDHisFlag As %String;

Property BDPMapDSystemCode As %String;

}
