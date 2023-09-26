Class EMRservice.entity.EEMRNavigationSchemeItemSeq Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// EMRmeta.EMRNavigationScheme表SchemeCode关联（冗余）
Property SchemeCode As %String;

/// EMRmeta.EMRNavigationSchemeItem表的ItemCode（冗余）
Property ItemCode As %String;

/// EMRmeta.EMRNavigationSchemeItem表的ItemName
Property ItemName As %String;

/// EMRmeta.EMRNavigationSchemeItem表rowid关联
Property ItemID As %String;

/// 科室ID
Property CTLocID As %String;

/// 科室名称(冗余字段)
Property CTLocDesc As %String;

/// 顺序
Property ItemSeq As %String;

}
