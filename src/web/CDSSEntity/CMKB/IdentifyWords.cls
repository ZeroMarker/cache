/// Description：识别词字典表
/// Table：CT.WDT.CDSS.IdentifyWords
Class web.CDSSEntity.CMKB.IdentifyWords Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.IdentifyWords";

/// WordsRowId
Property WordsRowId As %String;

/// 识别词编码
Property WordsCode As %String;

/// 识别词名称
Property WordsDesc As %String;

/// 类型（D-诊断条件/I-识别词）
Property WordsType As %String;

/// 状态（0-编辑中/1-审核中/2-不通过/3-上线/4-下线）
Property WordsState As %String;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %String;

/// 审核人员
Property AuditUser As %String;

/// 审核时间
Property AuditDate As %String;

/// 拆分状态（0是/1否）
Property SplitState As %String;

/// 备注
Property Remarks As %String;

}
