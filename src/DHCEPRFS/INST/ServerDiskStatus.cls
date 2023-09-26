Class DHCEPRFS.INST.ServerDiskStatus Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property DiskSize As %String(TRUNCATE = 1);

Property DiskFreeSpace As %String(TRUNCATE = 1);

Property DiskUsed As %String(TRUNCATE = 1);

Property ServerDiskID As %String(TRUNCATE = 1);

Property RecordDate As %Date;

Property RecordTime As %Time;

/// 用以表示此记录为此磁盘的第几次记录，用于估算时取值使用，要连续
Property Sequence As %Integer;

Index IdxServerDiskID On ServerDiskID;

Index IdxSequence On (ServerDiskID, Sequence);

Index IdxDateTime On (ServerDiskID, RecordDate, RecordTime);

Storage Default
{
<Data name="ServerDiskStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DiskCapacity</Value>
</Value>
<Value name="3">
<Value>DiskAvaliable</Value>
</Value>
<Value name="4">
<Value>DiskUsed</Value>
</Value>
<Value name="5">
<Value>DiskName</Value>
</Value>
<Value name="6">
<Value>DiskDesc</Value>
</Value>
<Value name="7">
<Value>ServerName</Value>
</Value>
<Value name="8">
<Value>ServerIP</Value>
</Value>
<Value name="9">
<Value>ServerDesc</Value>
</Value>
<Value name="10">
<Value>RecordDate</Value>
</Value>
<Value name="11">
<Value>RecordTime</Value>
</Value>
<Value name="12">
<Value>ServerDiskID</Value>
</Value>
<Value name="13">
<Value>DiskSize</Value>
</Value>
<Value name="14">
<Value>DiskFreeSpace</Value>
</Value>
<Value name="15">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.ServerDiskSD</DataLocation>
<DefaultData>ServerDiskStatusDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.ServerDiskSD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.ServerDiskSI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.ServerDiskSS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
