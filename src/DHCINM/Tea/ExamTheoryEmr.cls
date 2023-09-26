/// Creator:lulin
/// Descriptions:应急预案考核子表
/// Date:
Class DHCINM.Tea.ExamTheoryEmr Extends %Persistent
{

Relationship ParrefEmr As DHCINM.Tea.ExamTheory [ Cardinality = parent, Inverse = ChildEmr ];

/// 题目对应外键
Property ExamSubDR As %String [ SqlColumnNumber = 2, SqlFieldName = ExamSubDR ];

/// 答案
Property Result As %String [ SqlColumnNumber = 3, SqlFieldName = ExamAnswer ];

/// 得分
Property GetScore As %String [ SqlColumnNumber = 4, SqlFieldName = GetScore ];

/// 总分
Property ExamScore As %String [ SqlColumnNumber = 5, SqlFieldName = ExamScore ];

Storage Default
{
<Data name="ExamTheoryEmrDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExamSubDR</Value>
</Value>
<Value name="3">
<Value>Result</Value>
</Value>
<Value name="4">
<Value>GetScore</Value>
</Value>
<Value name="5">
<Value>ExamScore</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Tea.ExamTheoryEmrD</DataLocation>
<DefaultData>ExamTheoryEmrDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildEmr")</IdLocation>
<IndexLocation>^DHCINM.Tea.ExamTheoryEmrI</IndexLocation>
<StreamLocation>^DHCINM.Tea.ExamTheoryEmrS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
