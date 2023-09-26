Class User.DHCBPCManufacturer Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_BPC_Manufacturer, StorageStrategy = CacheStorage ]
{

Property BPCMCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCM_Code ];

Property BPCMDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCM_Desc ];

Storage CacheStorage
{
<Data name="BPCManufacturerClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="BPCManufacturerData">
<Value name="1">
<Value>BPCMCode</Value>
</Value>
<Value name="2">
<Value>BPCMDesc</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("Manufacturer")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("Manufacturer")</IdLocation>
<IndexLocation>^DHCBPC("Manufacturer",0)</IndexLocation>
<StreamLocation>^User.DHCBPCManufacturerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
