/// 名称:用户模板知识库节点表
/// 描述:用户模板知识库节点表
/// 编写者：yejian
/// 编写日期: 2017-11-7
Class EMRservice.entity.EUserTemplateKBNode Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 分组代码EMRmeta.UserTemplate的Code
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// 模板章节编码
Property SectionCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 模板复合编码
Property CompositeCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// KbBaseID
Property KbBaseID As %String;

/// 知识库节点表ID
Property KBNodeID As %String;

/// 顺序
Property Sequence As %String;

/// 有效标志
Property ActiveFlag As %String;

}
