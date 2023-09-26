Class DHCEPRFS.INST.DirLoc Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property ParentID As %Integer [ Required ];

Property PathLevel As %Integer [ Required ];

Property Path As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

Index IdxParentIDAndPath On (ParentID, Path) [ Unique ];

Storage Default
{
<Data name="DirLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ParentID</Value>
</Value>
<Value name="3">
<Value>PathLevel</Value>
</Value>
<Value name="4">
<Value>Path</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.DirLocD</DataLocation>
<DefaultData>DirLocDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.DirLocD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.DirLocI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.DirLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
