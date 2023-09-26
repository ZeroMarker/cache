Class EPRinstance.VersionHistory Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Rule reference
Property TemplateDR As %String(TRUNCATE = 1);

Property ReasonDescription As %String(MAXLEN = 500, TRUNCATE = 1);

Property ContentDescription As %String(MAXLEN = 500, TRUNCATE = 1);

/// 最后保存版本
Property LastVersion As %Integer;

Property CreateDate As %Date;

Property CreateTime As %Time;

Index TemplateDR On TemplateDR;

ClassMethod AddVersionHistoryInfos(VersionHistoryInfos As %String) As %String
{
	s objEPRLogs = ##class(EPRinstance.VersionHistory).%New()
	q:(objEPRLogs="") "0"
	
	s now = $H
	s date = $P(now,",",1)
	s time = $P(now,",",2)
	
	s objEPRLogs.TemplateDR = $p(VersionHistoryInfos,"^",1)
	s objEPRLogs.ReasonDescription = $p(VersionHistoryInfos,"^",2)
	s objEPRLogs.ContentDescription = $p(VersionHistoryInfos,"^",3)
	s objEPRLogs.LastVersion = $p(VersionHistoryInfos,"^",4)
	s objEPRLogs.CreateDate = date
	s objEPRLogs.CreateTime = time
	
	s status = objEPRLogs.%Save()
	q:('$$$ISOK(status)) "0"	
	q objEPRLogs.%Id()
}

Query SELECTALL(TemplateDR As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "TemplateDR:%String,ReasonDescription:%String,ContentDescription:%String,LastVersion:%String,CreateDate:%String,CreateTime:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_VersionHistory_SELECTALL, SqlProc ]
{
 SELECT TemplateDR,ReasonDescription,ContentDescription,LastVersion,CreateDate,CreateTime
 FROM EPRinstance.VersionHistory where TemplateDR=:TemplateDR ORDER BY TemplateDR
}

Storage Default
{
<Data name="VersionHistoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ContentDescription</Value>
</Value>
<Value name="3">
<Value>CreateDate</Value>
</Value>
<Value name="4">
<Value>CreateTime</Value>
</Value>
<Value name="5">
<Value>LastVersion</Value>
</Value>
<Value name="6">
<Value>ReasonDescription</Value>
</Value>
<Value name="7">
<Value>TemplateDR</Value>
</Value>
</Data>
<DataLocation>^EPRinstance.VersionHistoryD</DataLocation>
<DefaultData>VersionHistoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EPRinstance.VersionHistoryD</IdLocation>
<IndexLocation>^EPRinstance.VersionHistoryI</IndexLocation>
<StreamLocation>^EPRinstance.VersionHistoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
