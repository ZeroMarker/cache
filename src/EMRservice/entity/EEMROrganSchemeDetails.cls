/// 名称:EMRservice.entity.EEMROrganizationSchemeDetails
/// 描述:患者完整病历内容的组织方案明细对象
/// 编写者：yejian
/// 编写日期: 2014-8-30
Class EMRservice.entity.EEMROrganSchemeDetails Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

Property ItemCode As %String;

Property ItemName As %String;

Property ItemDr As %String;

Property ItemSeq As %String;

Relationship ParSchemeType As EMRservice.entity.EEMROrganizationSchemeType [ Cardinality = parent, Inverse = Details ];

}
