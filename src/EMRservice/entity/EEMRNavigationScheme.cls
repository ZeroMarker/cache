/// 名称:EMRservice.entity.EEMRNavigationScheme
/// 描述:患者完整病历内容的组织方案对象
/// 编写者：yejian
/// 编写日期:2016-5-17
Class EMRservice.entity.EEMRNavigationScheme Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 病历书写顺序方案(Running)、病历归档顺序方案(Archiving)、门急诊顺序方案(Outpatient)
Property SchemeCode As %String;

/// 方案名称
Property SchemeName As %String;

Property CreateUserID As %String;

Property CreateDate As %String;

Property CreateTime As %String;

Property modifyUser As %String;

Property ModifyDate As %String;

Property ModifyTime As %String;

/// 显示次序
Property SchemSeq As %String;

}
