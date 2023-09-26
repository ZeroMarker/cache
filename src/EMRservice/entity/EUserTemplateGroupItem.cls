/// 名称: 科室模板分组子项表
/// 描述: 科室模板分组子项表
/// 编写者：叶剑
/// 编写日期: 2018-2-26
Class EMRservice.entity.EUserTemplateGroupItem Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 科室模板分组ID
Property GroupID As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 科室模板代码
Property Code As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 顺序((分组下顺序))
Property Sequence As %String;

}
