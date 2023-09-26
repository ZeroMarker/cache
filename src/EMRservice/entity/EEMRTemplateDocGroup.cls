/// 名称: 病历模板分组关联表
/// 描述: 病历模板分组关联表
/// 编写者：叶剑
/// 编写日期: 2018-3-22
Class EMRservice.entity.EEMRTemplateDocGroup Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 病历模板分组代码
Property GroupCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 病历模板分组名称
Property GroupName As %String(MAXLEN = 200, TRUNCATE = 1);

/// CT_Loc指针
Property CTLocID As %String(TRUNCATE = 1);

Property ParentID As %String(TRUNCATE = 1);

/// 顺序
Property Sequence As %String;

}
