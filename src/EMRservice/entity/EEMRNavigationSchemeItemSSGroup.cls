/// 名称: EMRservice.entity.EEMRNavigationSchemeItemSSGroup
/// 描述: 患者完整病历内容的组织方案项目安全组配置(安全组)
/// 编写者：yejian	
/// 编写日期: 2016-5-16
Class EMRservice.entity.EEMRNavigationSchemeItemSSGroup Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// EMRmeta.EMRNavigationScheme表的SchemeCode
Property SchemeCode As %String;

/// EMRmeta.CTOrganizationSchemeItem中的ItemCode关联
Property ItemCode As %String;

/// 方案项名称(冗余字段)
Property ItemName As %String;

/// 规则条件的ID（只使用安全组，即安全组的ID）
Property SSGroupID As %String(TRUNCATE = 1);

/// 规则条件的描述（只使用安全组，即安全组的名称）
Property SSGroupName As %String(TRUNCATE = 1);

}
