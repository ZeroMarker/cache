Class DHCEPRFS.INST.PrintInfo Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property MRLogDetailID As %String(TRUNCATE = 1);

Property MREpisodeID As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property Relationship As %String(TRUNCATE = 1);

Property IDNumber As %String(TRUNCATE = 1);

Property Contact As %String(TRUNCATE = 1);

Property Remarks As %String(TRUNCATE = 1);

Property PrintPurposeDesc As %String(TRUNCATE = 1);

Property PrintPurposeCode As %String(TRUNCATE = 1);

Index IdxMRLogDetailID On MRLogDetailID [ Unique ];

Storage Default
{
<Data name="PrintInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MRLogDetailID</Value>
</Value>
<Value name="3">
<Value>MREpisodeID</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>Relationship</Value>
</Value>
<Value name="6">
<Value>IDNumber</Value>
</Value>
<Value name="7">
<Value>Contact</Value>
</Value>
<Value name="8">
<Value>Remarks</Value>
</Value>
<Value name="9">
<Value>PrintPurposeDesc</Value>
</Value>
<Value name="10">
<Value>PrintPurposeCode</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.PrintInfoD</DataLocation>
<DefaultData>PrintInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.PrintInfoD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.PrintInfoI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.PrintInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
