Class EPRmeta.ReportVersion Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Author As %String(TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As %Time;

Property Data As %GlobalCharacterStream(LOCATION = "^DHCEPRM.ReportVersionS");

Property LastSaveDate As %Date;

Property LastSaveTime As %Time;

Property PublicationDate As %Date;

Property PublicationTime As %Time;

Property ReportID As %String(TRUNCATE = 1);

Property Status As %Integer;

Property Conditions As %String(MAXLEN = 2500, TRUNCATE = 1);

Property VersionNumber As %Integer;

ClassMethod SELECTMAXVERSION(AReportID As %String) As %Integer
{
 new Result
 &sql(SELECT MAX(VersionNumber)
 into :Result 
 FROM EPRmeta.ReportVersion
 WHERE ReportID = :AReportID)
 QUIT Result
}

Query SELECTALL(AReportID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,ReportID:%String,Author:%String,LastSaveDate:%Date,LastSaveTime:%Time,PublicationDate:%Date,PublicationTime:%Time,CreateDate:%Date,CreateTime:%Time,Status:%Integer,VersionNumber:%Integer", SELECTMODE = "RUNTIME") [ SqlName = SP_ReportVersion_SELECTALL, SqlProc ]
{
 SELECT ID,ReportID,Author,LastSaveDate,LastSaveTime,
 PublicationDate,PublicationTime,CreateDate,CreateTime,Status,VersionNumber
 FROM EPRmeta.ReportVersion
 WHERE ReportID = :AReportID
}

Storage Default
{
<Data name="ReportVersionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Author</Value>
</Value>
<Value name="3">
<Value>CreateDate</Value>
</Value>
<Value name="4">
<Value>CreateTime</Value>
</Value>
<Value name="5">
<Value>Data</Value>
</Value>
<Value name="6">
<Value>LastSaveDate</Value>
</Value>
<Value name="7">
<Value>LastSaveTime</Value>
</Value>
<Value name="8">
<Value>PrintTemplateID</Value>
</Value>
<Value name="9">
<Value>PublicationDate</Value>
</Value>
<Value name="10">
<Value>PublicationTime</Value>
</Value>
<Value name="11">
<Value>Status</Value>
</Value>
<Value name="12">
<Value>VersionNumber</Value>
</Value>
<Value name="13">
<Value>ReportID</Value>
</Value>
<Value name="14">
<Value>Conditions</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.ReportVersionD</DataLocation>
<DefaultData>ReportVersionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.ReportVersionD</IdLocation>
<IndexLocation>^DHCEPRM.ReportVersionI</IndexLocation>
<StreamLocation>^DHCEPRM.ReportVersionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
