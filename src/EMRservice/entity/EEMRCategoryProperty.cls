Class EMRservice.entity.EEMRCategoryProperty Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property NecessaryTemplate As %String(TRUNCATE = 1);

Property ResourceDir As %String(TRUNCATE = 1);

Property NodeRule As %String(TRUNCATE = 1);

Property IsLeadframe As %String(TRUNCATE = 1);

/// 待签，0或空：显示待签，1：不显示待签.
Property IsWaitsign As %String(TRUNCATE = 1);

Property IsMutex As %String(TRUNCATE = 1);

/// 小图标路径
Property ImageUrl As %String(TRUNCATE = 1);

/// 内部表示符
Property InternalID As %String(TRUNCATE = 1);

/// 绑定模板类型Multiple/Single/""
Property TemplateType As %String(TRUNCATE = 1);

/// 模板描述简拼
Property JaneSpell As %String(TRUNCATE = 1);

/// 模板描述全拼
Property FullFight As %String(TRUNCATE = 1);

}
