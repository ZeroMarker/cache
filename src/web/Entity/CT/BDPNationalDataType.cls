/// Function: 实体类 国家标准数据类型
/// Creator:  sunfengchao
/// CreateDate: 2016-4-7
Class web.Entity.CT.BDPNationalDataType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.BDPNationalDataType";

Property BDPStandardRowId As %String;

/// 代码
Property BDPStandardCode As %String;

/// 描述　
Property BDPStandardDesc As %String;

/// 拼音码
Property BDPStandardSearchCode As %String;

/// 国家标准编码源值域代码
Property BDPStandardDomainCode As %String;

/// 国家标准编码源值域名称
Property BDPStandardDomainDesc As %String;

}
