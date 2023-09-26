/// Desc:问卷题型特有属性表
/// Creator:Donglulu
/// CreateDate:2020-12-9
Class EMRmeta.QuestionTypeProperty Extends (%Persistent, User.Abstract)
{

/// 题型（EMRmeta.QuestionType的Code）
Property QuestTypeCode As %String(TRUNCATE = 1);

/// 属性代码
Property PropertyCode As %String(TRUNCATE = 1);

/// 属性描述
Property PropertyDesc As %String(TRUNCATE = 1);

/// 显示顺序
Property Sequence As %Integer;

Index IdxTypeCode On QuestTypeCode;

Index IdxQuestTypeSeq On (QuestTypeCode, Sequence);

Index IdxTypeProperty On (QuestTypeCode, PropertyCode) [ Unique ];

Storage Default
{
<Data name="QuestionTypePropertyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QuesTypeCode</Value>
</Value>
<Value name="3">
<Value>PropertyID</Value>
</Value>
<Value name="4">
<Value>QuestTypeCode</Value>
</Value>
<Value name="5">
<Value>PropertyCode</Value>
</Value>
<Value name="6">
<Value>PropertyDesc</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.QuestTypePropertyD</DataLocation>
<DefaultData>QuestionTypePropertyDefaultData</DefaultData>
<IdLocation>^DHCEMRM.QuestTypePropertyD</IdLocation>
<IndexLocation>^DHCEMRM.QuestTypePropertyI</IndexLocation>
<StreamLocation>^DHCEMRM.QuestTypePropertyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
