/// 名称:EMRservice.entity.EEMROrganizationScheme
/// 描述:患者完整病历内容的组织方案对象
/// 编写者：yejian
/// 编写日期:2014-8-30
Class EMRservice.entity.EEMROrganizationScheme Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 方案编码
Property SchemeCode As %String;

/// 方案名称
Property SchemeName As %String;

Property CreateUserID As %String;

Property CreateDate As %String;

Property CreateTime As %String;

Property ModifyDate As %String;

Property ModifyTime As %String;

/// 显示次序
Property SchemSeq As %Integer;

Relationship SchemType As EMRservice.entity.EEMROrganizationSchemeType [ Cardinality = children, Inverse = ParScheme ];

}
