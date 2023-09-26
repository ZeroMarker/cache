/// Description：文献发布机构表
/// Table：CT.WDT.CDSS.DocuAgency
Class web.CDSSEntity.CMKB.DocuAgency Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.DocuAgency";

/// RowId
Property RowId As %String;

/// 发布机构代码
Property AgencyCode As %String;

/// 发布机构名称
Property AgencyDesc As %String;

/// 机构优先级
Property AgencyPriority As %String;

}
