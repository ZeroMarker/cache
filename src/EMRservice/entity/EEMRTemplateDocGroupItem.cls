/// 名称: 病历模板分组子项表
/// 描述: 病历模板分组子项表
/// 编写者：叶剑
/// 编写日期: 2018-3-22
Class EMRservice.entity.EEMRTemplateDocGroupItem Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 病历模板分组ID
Property GroupID As %String(MAXLEN = 200, TRUNCATE = 1);

/// EMRmeta.EMRTemplateCategory表CategoryType类型为CategoryChapter的ID
Property DocID As %String(MAXLEN = 200, TRUNCATE = 1);

/// 顺序((分组下顺序))
Property Sequence As %String;

}
