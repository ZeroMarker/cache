/// Desc:问卷题数据
/// Creator:Donglulu
/// CreateDate:2020-12-9
Class EMRmeta.QuestionData Extends (%Persistent, User.Abstract)
{

/// 病史类型（EMRmeta.MedicalHistoryType表的code）
Property MedHistoryType As %String(TRUNCATE = 1);

/// 题型（EMRmeta.QuestionType表的code）
Property QuestionType As %String(TRUNCATE = 1);

/// 题目
Property QuestionTitle As %String(MAXLEN = 99999999);

/// 代码
Property QuestionCode As %String(MAXLEN = 99999999);

/// 顺序
Property Sequence As %Integer;

/// 发布状态 （1：发布，-1：停用）
Property IsPublish As %String(TRUNCATE = 1);

Index IdxMedHistoryType On MedHistoryType;

Index IdxMedHistoryTypeSeq On (MedHistoryType, Sequence);

Index IdxQuestionCode On QuestionCode;

/// 题目属性
Relationship DataProperty As EMRmeta.QuestionDataSub [ Cardinality = children, Inverse = ParRef ];

Storage Default
{
<Data name="QuestionDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MedHistoryType</Value>
</Value>
<Value name="3">
<Value>QuestionType</Value>
</Value>
<Value name="4">
<Value>QuestionTitle</Value>
</Value>
<Value name="5">
<Value>DefaultShow</Value>
</Value>
<Value name="6">
<Value>QuestionCode</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>IsPublish</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.QuestionDataD</DataLocation>
<DefaultData>QuestionDataDefaultData</DefaultData>
<IdLocation>^DHCEMRM.QuestionDataD</IdLocation>
<IndexLocation>^DHCEMRM.QuestionDataI</IndexLocation>
<StreamLocation>^DHCEMRM.QuestionDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
