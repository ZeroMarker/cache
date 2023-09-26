Class EPRmeta.Report Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

Property GUID As %String(MAXLEN = 36, TRUNCATE = 1);

/// 最后保存版本
Property LastVersion As %Integer;

Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 发布版本
Property PublishVersion As %Integer;

Property ReportCategoryID As %String(TRUNCATE = 1);

ClassMethod SELECTBYGUID(AGUID As %String) As %String
{
 new Result	 
 &sql(SELECT ID
 into :Result 
 FROM EPRmeta.Report
 WHERE GUID = :AGUID)
 QUIT Result
}

Query SELECTBYCATEID(CATEID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,GUID:%String,Name:%String,PrintTemplateCategoryID:%String,Description:%String,PublishVersion:%Integer,LastVersion:%Integer", SELECTMODE = "RUNTIME") [ SqlName = SP_Report_SELECTBYCATEID, SqlProc ]
{
 SELECT ID, GUID, Name, ReportCategoryID, Description,PublishVersion,LastVersion
 FROM EPRmeta.Report
 WHERE ReportCategoryID = :CATEID
 ORDER BY ID
}

Storage Default
{
<Data name="ReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>GUID</Value>
</Value>
<Value name="4">
<Value>LastVersion</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>PublishVersion</Value>
</Value>
<Value name="7">
<Value>ReportCategoryID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.ReportD</DataLocation>
<DefaultData>ReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.ReportD</IdLocation>
<IndexLocation>^DHCEPRM.ReportI</IndexLocation>
<StreamLocation>^DHCEPRM.ReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
