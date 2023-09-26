/// Class Name:		EPRmeta.SubjectLog
/// Description:	电子病历订阅信息操作日志表
/// Creator:	    YHY
/// Create Date:	2012-11-05
Class EPRmeta.SubjectLog Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property SaveDoc As %String(TRUNCATE = 1) [ Required ];

Property SaveTime As %String(TRUNCATE = 1);

Property SaveOriginal As %String(MAXLEN = 200, TRUNCATE = 1);

Property SaveCurrent As %String(MAXLEN = 200, TRUNCATE = 1);

Index Idx On SaveDoc;

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
<Value>SaveDoc</Value>
</Value>
<Value name="3">
<Value>SaveTime</Value>
</Value>
<Value name="4">
<Value>SaveOriginal</Value>
</Value>
<Value name="5">
<Value>SaveCurrent</Value>
</Value>
<Value name="6">
<Value>PateintID</Value>
</Value>
<Value name="7">
<Value>SaveDate</Value>
</Value>
<Value name="8">
<Value>SaveCode</Value>
</Value>
<Value name="9">
<Value>SaveIP</Value>
</Value>
<Value name="10">
<Value>Parref</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.SubjectLogD</DataLocation>
<DefaultData>SubjectLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM..SubjectLogD</IdLocation>
<IndexLocation>^DHCEPRM.SubjectLogI</IndexLocation>
<StreamLocation>^DHCEPRM..SubjectLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
