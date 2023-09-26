Class DHCEPRFS.INST.DirMaster Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property ParentID As %Integer [ Required ];

Property PathLevel As %Integer [ Required ];

Property Path As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

Index IdxParentIDAndPath On (ParentID, Path) [ Unique ];

Storage Default
{
<Data name="DirMasterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ParentID</Value>
</Value>
<Value name="3">
<Value>Path</Value>
</Value>
<Value name="4">
<Value>PathLevel</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.DirMasterD</DataLocation>
<DefaultData>DirMasterDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.DirMasterD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.DirMasterI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.DirMasterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
