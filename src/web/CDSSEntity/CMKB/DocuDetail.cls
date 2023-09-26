/// Description：文献管理详细信息表
/// Table：CT.WDT.CDSS.DocuDetail
Class web.CDSSEntity.CMKB.DocuDetail Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.DocuDetail";

/// RowId
Property RowId As %String;

/// 文献指向 文献管理表
Property DocuDR As %String;

/// 文献详情标题
Property Title As %String;

/// 文献详情内容
Property Content As %String;

/// 文献详情父级
Property ParentDR As %String;

}
