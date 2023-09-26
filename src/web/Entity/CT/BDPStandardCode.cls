Class web.Entity.CT.BDPStandardCode Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.BDPStandardCode";

Property ID As %String;

/// 国家标准编码
Property BDPInternalCode As %String;

/// 国家标准编码名称
Property BDPInternalDesc As %String;

/// 国家标准编码值
Property BDPInternalValue As %String;

/// 医院标准编码
Property BDPHospNationalCode As %String;

/// 医院标准编码名称
Property BDPPHospNationalDesc As %String;

/// 表名称 
Property TableName As %String;

/// 对应表数据RowID
Property DataReference As %String;

}
