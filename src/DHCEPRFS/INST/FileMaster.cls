Class DHCEPRFS.INST.FileMaster Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property DirMasterID As %Integer [ Required ];

Property DirLocID As %Integer [ Required ];

Property FileMasterName As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

Property FileLocName As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

Property MD5Code As %String(MAXLEN = 50, TRUNCATE = 1);

Index IdxMaster On (DirMasterID, FileMasterName) [ Unique ];

Index IdxLoc On (DirLocID, FileLocName) [ Unique ];

Storage Default
{
<Data name="FileMasterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DirMasterID</Value>
</Value>
<Value name="3">
<Value>DirLocID</Value>
</Value>
<Value name="4">
<Value>FileMasterName</Value>
</Value>
<Value name="5">
<Value>FileLocName</Value>
</Value>
<Value name="6">
<Value>MD5Code</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.FileMasterD</DataLocation>
<DefaultData>FileMasterDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.FileMasterD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.FileMasterI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.FileMasterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
