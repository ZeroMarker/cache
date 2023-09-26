/// 名称:EMRservice.entity.EEMRNavigationSchemeItem
/// 描述:患者完整病历内容的组织方案明细对象
/// 编写者：yejian
/// 编写日期: 2016-5-17
Class EMRservice.entity.EEMRNavigationSchemeItem Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// EMRmeta.EMRNavigationScheme表SchemeCode关联
Property SchemeCode As %String;

/// EMRmeta.CTOrganizationSchemeItem表ItemCode关联
Property ItemCode As %String;

Property ItemName As %String;

/// EMRmeta.CTOrganizationSchemeItem.ID
Property ItemDr As %String;

Property ItemSeq As %String;

}
