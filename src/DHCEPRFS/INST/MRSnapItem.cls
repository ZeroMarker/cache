Class DHCEPRFS.INST.MRSnapItem Extends %Persistent
{

Property MRSnapID As %String [ Required, SqlColumnNumber = 2 ];

Property MRItemID As %String [ Required, SqlColumnNumber = 3 ];

Property DetailNum As %Integer [ Required, SqlColumnNumber = 4 ];

Property MRVerItemDetailID As %String [ Required, SqlColumnNumber = 5 ];

Property FileMasterID As %String [ Required, SqlColumnNumber = 6 ];

Property TotCount As %Integer [ Required, SqlColumnNumber = 7 ];

Property DetailNum2 As %Integer [ SqlColumnNumber = 8 ];

Property MRVerItemDetailID2 As %String [ SqlColumnNumber = 9 ];

Property FileMasterID2 As %String [ SqlColumnNumber = 10 ];

Index IdxMain On (MRSnapID, MRItemID) [ Unique ];

Storage Default
{
<Data name="MRSnapItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MRSnapID</Value>
</Value>
<Value name="3">
<Value>MRItemID</Value>
</Value>
<Value name="4">
<Value>DetailNum</Value>
</Value>
<Value name="5">
<Value>MRVerItemDetailID</Value>
</Value>
<Value name="6">
<Value>FileMasterID</Value>
</Value>
<Value name="7">
<Value>TotCount</Value>
</Value>
<Value name="8">
<Value>DetailNum2</Value>
</Value>
<Value name="9">
<Value>MRVerItemDetailID2</Value>
</Value>
<Value name="10">
<Value>FileMasterID2</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MRSnapItemD</DataLocation>
<DefaultData>MRSnapItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MRSnapItemD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRSnapItemI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRSnapItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
