/// 名称：		EMRservice.entity.ETemplateSign
/// 描述：		待签配置对象
/// 编写者：	yejian	
/// 编写时间：	2018-12-5
Class EMRservice.entity.ETemplateSign Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 模板ID
Property TemplateID As %String(TRUNCATE = 1);

/// 模板版本ID
Property TemplateVersion As %String;

/// 关联EMRmeta.SignRole表的ActionCode
Property ActionCode As %String;

/// 关联EMRmeta.SignRole表的Description
Property Description As %String;

/// 关联EMRmeta.Titles表的Code
Property TitleCode As %String;

/// 关联EMRmeta.Titles表的Description
Property TitleName As %String;

/// 医务人员待签：MEDICAL，患者待签：PATIENT
Property SignType As %String;

/// 签名顺序
Property Sequence As %Integer;

/// 规则编码（EMRmeta.RoleSignRuleList的RoleRuleCode以^分隔）
Property RoleRuleCode As %String;

/// 是否必签 
Property IsForce As %String(TRUNCATE = 1);

}
