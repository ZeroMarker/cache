/// 名称: EMRservice.entity.EEMRNavigationSchemeItemLoc
/// 描述: 患者完整病历内容的组织方案配置表对象
/// 编写者：yejian
/// 编写日期: 2016-5-17
Class EMRservice.entity.EEMRNavigationSchemeItemLoc Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// EMRmeta.EMRNavigationScheme表的SchemeCode
Property SchemeCode As %String;

/// EMRmeta.CTOrganizationSchemeItem表的ItemCode
Property ItemCode As %String;

/// 方案项名称(冗余字段)
Property ItemName As %String;

/// 科室ID
Property CTLocID As %String;

/// 科室名称(冗余字段)
Property CTLocDesc As %String;

}
