/// Desc:问卷题数据属性
/// Creator:Donglulu
/// CreateDate:2020-12-9
Class EMRmeta.QuestionDataSub Extends (%Persistent, User.Abstract)
{

/// 属性类型（EMRmeta.QuestionProperty表的code）
Property PropertyCode As %String(TRUNCATE = 1);

/// 属性内容
Property PropertyValue As %String(MAXLEN = 99999999);

Index IdxQuestIDProperty On (ParRef, PropertyCode) [ Unique ];

Index IdxQuestID On ParRef;

Relationship ParRef As EMRmeta.QuestionData [ Cardinality = parent, Inverse = DataProperty ];

Storage Default
{
<Data name="QuestionDataSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QuesDataID</Value>
</Value>
<Value name="3">
<Value>PropertyCode</Value>
</Value>
<Value name="4">
<Value>PropertyValue</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DataProperty")</DataLocation>
<DefaultData>QuestionDataSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("DataProperty")</IdLocation>
<IndexLocation>^DHCEMRM.QuestionDataSubI</IndexLocation>
<StreamLocation>^DHCEMRM.QuestionDataSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
