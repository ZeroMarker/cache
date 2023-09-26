/// 名称: EMRservice.entity.EEMROrganizationSchemeLoc
/// 描述: 患者完整病历内容的组织方案配置表对象
/// 编写者：yejian
/// 编写日期: 2014-8-30
Class EMRservice.entity.EEMROrganizationSchemeLoc Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

Property SchemeID As %String;

/// 方案名称(冗余字段)
Property SchemeName As %String;

/// 科室ID
Property CTLocID As %String;

/// 科室名称(冗余字段)
Property CTLocDesc As %String;

}
