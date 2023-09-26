/// 名称：		EMRservice.entity.EEMRTemplateGroupLoc
/// 描述：		病历分组科室关联表
/// 编写者：	yejian
/// 编写时间：	2017-8-15
Class EMRservice.entity.EEMRTemplateGroupLoc Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 模板组合ID
Property TemplateGroupCode As %String(TRUNCATE = 1);

/// 模板组合名称
Property TemplateGroupName As %String(TRUNCATE = 1);

/// 科室ID
Property CTLocID As %String;

/// 科室名称(冗余字段)
Property CTLocDesc As %String;

}
