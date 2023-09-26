/// Class Name:		EMRinstance.SubjectLog
/// Description:	电子病历订阅信息操作日志表
/// Creator:	    Lina
/// Create Date:	2016-02-02
Class EMRinstance.SubjectLog Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property SaveUser As %String(TRUNCATE = 1) [ Required ];

Property SaveTime As %String(TRUNCATE = 1);

Property SaveOriginal As %String(MAXLEN = 200, TRUNCATE = 1);

Property SaveCurrentCode As %String(TRUNCATE = 1);

Property SaveCurrent As %String(MAXLEN = 200, TRUNCATE = 1);

Index Idx On SaveUser;

Property PateintID As %String(TRUNCATE = 1) [ Required ];

Property SaveDate As %String(TRUNCATE = 1);

Property SaveCode As %String(TRUNCATE = 1) [ Required ];

Property SaveIP As %String(TRUNCATE = 1) [ Required ];

Storage Default
{
<Data name="SubjectLogDefaultData">
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
<Value name="10">
<Value>SaveUser</Value>
</Value>
<Value name="11">
<Value>SaveTime</Value>
</Value>
<Value name="12">
<Value>SaveOriginal</Value>
</Value>
<Value name="13">
<Value>SaveCurrentCode</Value>
</Value>
<Value name="14">
<Value>SaveCurrent</Value>
</Value>
<Value name="15">
<Value>PateintID</Value>
</Value>
<Value name="16">
<Value>SaveDate</Value>
</Value>
<Value name="17">
<Value>SaveCode</Value>
</Value>
<Value name="18">
<Value>SaveIP</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.SubjectLogD</DataLocation>
<DefaultData>SubjectLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.SubjectLogD</IdLocation>
<IndexLocation>^DHCEMRI.SubjectLogI</IndexLocation>
<StreamLocation>^DHCEMRI.SubjectLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
