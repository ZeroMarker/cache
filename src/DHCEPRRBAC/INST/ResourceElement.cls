Class DHCEPRRBAC.INST.ResourceElement Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property ElementID As %String(TRUNCATE = 1);

Property ItemID As %String(TRUNCATE = 1);

Property PrivateDomainID As %String(TRUNCATE = 1);

Index IdxElement On ElementID;

Index IdxItemID On ItemID;

Index IdxPrivateDomain On PrivateDomainID;

Index IdexPrivateDomainElementID On (PrivateDomainID, ElementID);

Index IdexPrivateDomainItemElementID On (PrivateDomainID, ItemID);

Storage Default
{
<Data name="ResourceElementDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ElementID</Value>
</Value>
<Value name="3">
<Value>PrivateDomainID</Value>
</Value>
<Value name="4">
<Value>ItemID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRRBAC.INST.RSRCElementD</DataLocation>
<DefaultData>ResourceElementDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRRBAC.INST.RSRCElementD</IdLocation>
<IndexLocation>^DHCEPRRBAC.INST.RSRCElementI</IndexLocation>
<StreamLocation>^DHCEPRRBAC.INST.RSRCElementS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
