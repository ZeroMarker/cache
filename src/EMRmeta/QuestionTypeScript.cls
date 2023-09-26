/// Desc:问卷题型特有脚本表
/// Creator:Donglulu
/// CreateDate:2020-12-9
Class EMRmeta.QuestionTypeScript Extends (%Persistent, User.Abstract)
{

/// 题型（EMRmeta.QuestionType的Code）
Property QuestTypeCode As %String(TRUNCATE = 1);

/// 脚本代码
Property ScriptCode As %String(TRUNCATE = 1);

/// 脚本描述
Property ScriptDesc As %String(TRUNCATE = 1);

Index IdxQuestType On QuestTypeCode;

Index IdxQuestTypeScriptCode On (QuestTypeCode, ScriptCode) [ Unique ];

Index IdxScriptCode On ScriptCode;

Storage Default
{
<Data name="QuestionTypeScriptDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QuestTypeCode</Value>
</Value>
<Value name="3">
<Value>PropertyCode</Value>
</Value>
<Value name="4">
<Value>PropertyDesc</Value>
</Value>
<Value name="5">
<Value>ScriptCode</Value>
</Value>
<Value name="6">
<Value>ScriptDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.QuestTypeScriptD</DataLocation>
<DefaultData>QuestionTypeScriptDefaultData</DefaultData>
<IdLocation>^DHCEMRM.QuestTypeScriptD</IdLocation>
<IndexLocation>^DHCEMRM.QuestTypeScriptI</IndexLocation>
<StreamLocation>^DHCEMRM.QuestTypeScriptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
