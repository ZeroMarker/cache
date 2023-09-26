/// 名称: 科室模板分组关联表
/// 描述: 科室模板分组关联表
/// 编写者：叶剑
/// 编写日期: 2018-2-26
Class EMRservice.entity.EUserTemplateGroup Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 科室模板分组代码
Property GroupCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 科室模板分组名称
Property GroupName As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// CT_Loc指针
Property CTLocID As %String(TRUNCATE = 1);

Property ParentID As %String(TRUNCATE = 1);

/// 顺序
Property Sequence As %String;

/// TemplateID
Property TemplateID As %String;

/// 病历展现结构，业务活动记录ID
Property EMRDocID As %String(TRUNCATE = 1);

}
