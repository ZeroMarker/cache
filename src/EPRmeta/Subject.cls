/// Class Name:		EPRmeta.Subject
/// Description:	电子病历订阅信息表
/// Creator:	    YHY
/// Create Date:	2012-10-28		
Class EPRmeta.Subject Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index Idx On Event;

/// 订阅项数据编码
Property Code As %String(MAXLEN = 30, TRUNCATE = 1) [ Required ];

/// 术语编码
Property Glossary As %String(MAXLEN = 30, TRUNCATE = 1) [ Required ];

/// 订阅数据项描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 表达式
Property Expression As %String(MAXLEN = 200, TRUNCATE = 1);

/// 订阅数据类型
Property Type As %String(MAXLEN = 30, TRUNCATE = 1) [ Required ];

/// 是否有效 Y/N
Property IsActive As %String(MAXLEN = 3, TRUNCATE = 1);

/// 备注文本
Property ResumeText As %String(MAXLEN = 200, TRUNCATE = 1);

/// 事件
Property Event As %String(TRUNCATE = 1);

Storage Default
{
<Data name="SubjectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Glossary</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Expression</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
<Value name="7">
<Value>IsActive</Value>
</Value>
<Value name="8">
<Value>ResumeText</Value>
</Value>
<Value name="9">
<Value>Event</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.SubjectD</DataLocation>
<DefaultData>SubjectDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.SubjectD</IdLocation>
<IndexLocation>^DHCEPRM.SubjectI</IndexLocation>
<StreamLocation>^DHCEPRM.SubjectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
