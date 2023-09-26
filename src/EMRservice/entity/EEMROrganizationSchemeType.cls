/// 名称：		EMRservice.entity.EEMROrganizationSchemeType
/// 描述：		方案类型Entity
/// 编写者：	yejian
/// 编写时间：	2014-8-30
Class EMRservice.entity.EEMROrganizationSchemeType Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 方案类型
Property SchemType As %String;

Relationship ParScheme As EMRservice.entity.EEMROrganizationScheme [ Cardinality = parent, Inverse = SchemType ];

Relationship Details As EMRservice.entity.EEMROrganSchemeDetails [ Cardinality = children, Inverse = ParSchemeType ];

}
