/// Function: 实体类 国家标准数据元值域
/// Creator:  sunfengchao
/// CreateDate: 2016-4-7
Class web.Entity.CT.BDPNationalDataDomain Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.BDPNationalDataDomain";

Property BDPDomainRowId As %String;

/// 代码
Property BDPDomainCode As %String;

/// 描述　
Property BDPDomainDescDR As %String;

/// 值
Property BDPDomainValue As %String;

/// 值描述
Property BDPDomainExpression As %String;

/// 类型
Property BDPDomainType As %String;

/// 说明
Property BDPDomainStatement As %String;

/// 国标版本
Property BDPDomainVersion As %String;

/// 其他
Property BDPDomainOther As %String;

}
