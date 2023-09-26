/// Desc:问卷题型
/// Creator:Donglulu
/// CreateDate:2020-12-9
Class EMRmeta.QuestionType Extends (%Persistent, User.Abstract)
{

/// 描述
Property Description As %String(TRUNCATE = 1);

/// 代码
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

Index IdxCode On Code [ Unique ];

Storage Default
{
<Data name="QuestionTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.QuestionTypeD</DataLocation>
<DefaultData>QuestionTypeDefaultData</DefaultData>
<IdLocation>^DHCEMRM.QuestionTypeD</IdLocation>
<IndexLocation>^DHCEMRM.QuestionTypeI</IndexLocation>
<StreamLocation>^DHCEMRM.QuestionTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
