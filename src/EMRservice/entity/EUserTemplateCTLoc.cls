/// 名称: 用户模板科室表
/// 描述: 用户模板科室表
/// 编写者：叶剑
/// 编写日期: 2017-11-9
Class EMRservice.entity.EUserTemplateCTLoc Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 分组代码EMRmeta.UserTemplate的Code
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// CT_Loc指针
Property CTLocID As %String(TRUNCATE = 1);

/// CT_Loc名称
Property CTLocName As %String(TRUNCATE = 1);

}
