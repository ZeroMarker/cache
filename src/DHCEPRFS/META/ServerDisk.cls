Class DHCEPRFS.META.ServerDisk Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property DiskName As %String(TRUNCATE = 1);

Property DiskDesc As %String(TRUNCATE = 1);

Property DiskDrive As %String(TRUNCATE = 1);

Property ServerName As %String(TRUNCATE = 1);

Property ServerIP As %String(TRUNCATE = 1);

Property ServerDesc As %String(TRUNCATE = 1);

Index IdxMain On ServerIP;

Storage Default
{
<Data name="ServerDiskDefaultData">
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
<Value>DiskDrive</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.ServerDiskD</DataLocation>
<DefaultData>ServerDiskDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.ServerDiskD</IdLocation>
<IndexLocation>^DHCEPRFS.META.ServerDiskI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.ServerDiskS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
