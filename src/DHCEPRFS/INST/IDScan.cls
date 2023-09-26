Class DHCEPRFS.INST.IDScan Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property MREpisodeID As %String(TRUNCATE = 1);

Property MedRecordNo As %String(TRUNCATE = 1);

Property FileMasterID As %String(TRUNCATE = 1);

Property FileMasterPath As %String(MAXLEN = 100, TRUNCATE = 1);

Property FilePhysicalPath As %String(MAXLEN = 100, TRUNCATE = 1);

Property TotCount As %Integer;

Property ActUserID As %String(TRUNCATE = 1);

Property ActDate As %Date;

Property ActTime As %Time;

Index IdxMREpisodeID On (MREpisodeID, ActDate, ActTime);

Index IdxMedRecordNo On (MedRecordNo, ActDate, ActTime);

Index IdxUserID On (ActUserID, ActDate, ActTime);

Index IdxDateTime On (ActDate, ActTime);

Storage Default
{
<Data name="IDScanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MREpisodeID</Value>
</Value>
<Value name="3">
<Value>FileMasterID</Value>
</Value>
<Value name="4">
<Value>FileMasterPath</Value>
</Value>
<Value name="5">
<Value>TotCount</Value>
</Value>
<Value name="6">
<Value>ActUserID</Value>
</Value>
<Value name="7">
<Value>ActDate</Value>
</Value>
<Value name="8">
<Value>ActTime</Value>
</Value>
<Value name="9">
<Value>FilePhysicalPath</Value>
</Value>
<Value name="10">
<Value>MedRecordNo</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.IDScanD</DataLocation>
<DefaultData>IDScanDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.IDScanD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.IDScanI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.IDScanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
