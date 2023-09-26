/// 名称：		EMRservice.entity.EEMRTemplateGroup
/// 描述：		病历分组表
/// 编写者：	yejian
/// 编写时间：	2017-5-6
Class EMRservice.entity.EEMRTemplateGroup Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 模板组合ID
Property TemplateGroupCode As %String(TRUNCATE = 1);

/// 模板组合名称
Property TemplateGroupName As %String(TRUNCATE = 1);

/// 创建者
Property CreateUserID As %String;

/// 创建时间
Property CreateDate As %String;

/// 创建日期
Property CreateTime As %String;

/// 修改者
Property ModifyUser As %String;

/// 修改时间
Property ModifyDate As %String;

/// 修改日期
Property ModifyTime As %String;

/// 模板顺序
Property TemplateSeq As %String;

}
