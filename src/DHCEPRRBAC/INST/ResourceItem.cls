Class DHCEPRRBAC.INST.ResourceItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property ItemID As %String(TRUNCATE = 1);

Property PrivateDomainID As %String(TRUNCATE = 1);

Property IsActive As %String(TRUNCATE = 1);

Index IdxItem On (IsActive, ItemID);

Index IdxPrivateDomain On (IsActive, PrivateDomainID);

Index IdxPrivateDomainItemID On (PrivateDomainID, ItemID);

Storage Default
{
<Data name="ResourceItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemID</Value>
</Value>
<Value name="3">
<Value>PrivateDomainID</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^DHCEPRRBAC.INST.ResourceItemD</DataLocation>
<DefaultData>ResourceItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRRBAC.INST.ResourceItemD</IdLocation>
<IndexLocation>^DHCEPRRBAC.INST.ResourceItemI</IndexLocation>
<StreamLocation>^DHCEPRRBAC.INST.ResourceItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
