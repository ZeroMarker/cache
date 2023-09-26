Class User.DHCBPCSpecimen Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_BPC_Specimen, StorageStrategy = CacheStorage ]
{

Property BPCSCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCS_Code ];

Property BPCSDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCS_Desc ];

Storage CacheStorage
{
<Data name="DHCBPCSpecimenClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCSpecimenData">
<Value name="1">
<Value>BPCSCode</Value>
</Value>
<Value name="2">
<Value>BPCSDesc</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("Specimen")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("Specimen")</IdLocation>
<IndexLocation>^DHCBPC("Specimen",0)</IndexLocation>
<StreamLocation>^User.DHCBPCSpecimenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
