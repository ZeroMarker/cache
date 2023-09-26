/// Desc:问卷题型公共属性
/// Creator:Donglulu
/// CreateDate:2020-12-9
Class EMRmeta.QuestionProperty Extends (%Persistent, User.Abstract)
{

/// 描述
Property Description As %String(TRUNCATE = 1);

/// 代码
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// 显示顺序
Property Sequence As %Integer;

Index IdxCode On Code [ Unique ];

Index IdxSequence On Sequence;

Storage Default
{
<Data name="QuestionPropertyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QuestionType</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Code</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.QuestionPropertyD</DataLocation>
<DefaultData>QuestionPropertyDefaultData</DefaultData>
<IdLocation>^DHCEMRM.QuestionPropertyD</IdLocation>
<IndexLocation>^DHCEMRM.QuestionPropertyI</IndexLocation>
<StreamLocation>^DHCEMRM.QuestionPropertyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
