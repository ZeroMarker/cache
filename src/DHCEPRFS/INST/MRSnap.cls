Class DHCEPRFS.INST.MRSnap Extends %Persistent
{

Property MREpisodeID As %String [ Required, SqlColumnNumber = 2 ];

Property FillingType As %String [ Required, SqlColumnNumber = 3 ];

Property FillingVersion As %Integer [ Required, SqlColumnNumber = 4 ];

Property MRVersionID As %String [ Required, SqlColumnNumber = 5 ];

Property SnapVersion As %Integer [ Required, SqlColumnNumber = 6 ];

Property CreateDate As %Date [ Required, SqlColumnNumber = 7 ];

Property CreateTime As %Time [ Required, SqlColumnNumber = 8 ];

Property ModifyDate As %Date [ Required, SqlColumnNumber = 9 ];

Property ModifyTime As %Time [ Required, SqlColumnNumber = 10 ];

Index IdxMain On (MREpisodeID, FillingType, FillingVersion, SnapVersion) [ Unique ];

Index IdxMRVersionID On (MRVersionID, SnapVersion) [ Unique ];

Storage Default
{
<Data name="MRSnapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MREpisodeID</Value>
</Value>
<Value name="3">
<Value>FillingType</Value>
</Value>
<Value name="4">
<Value>FillingVersion</Value>
</Value>
<Value name="5">
<Value>MRVersionID</Value>
</Value>
<Value name="6">
<Value>SnapVersion</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>CreateTime</Value>
</Value>
<Value name="9">
<Value>ModifyDate</Value>
</Value>
<Value name="10">
<Value>ModifyTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MRSnapD</DataLocation>
<DefaultData>MRSnapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MRSnapD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRSnapI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRSnapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
