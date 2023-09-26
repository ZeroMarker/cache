Class EMR.DOC.DTO.EMRTSchemeItem Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 导航方案
Property EMRTScheme As %Integer;

/// 项目类型
Property DataType As %Integer;

/// 项目节点(业务活动记录对应：CF.EMR.DOC.TemplateCategory，文档对应：CF.EMR.DOC.Template)
Property DataID As %String;

/// URL
Property HISURL As %String;

/// HIS参数
Property HISParameter As %String;

/// 顺序
Property Sequence As %Integer;

}
