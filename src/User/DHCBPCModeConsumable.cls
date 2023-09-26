Class User.DHCBPCModeConsumable Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_BPC_ModeConsumable, StorageStrategy = CacheStorage ]
{

Index Mode On BPCMCBPCModeDr As Exact;

Index Ctloc On BPCMCCtlocDr As Exact;

Property BPCMCBPCModeDr As User.DHCBPCBloodPurificationMode [ SqlColumnNumber = 2, SqlFieldName = BPCMC_BPCMode_Dr ];

Property BPCMCBPCConsumableDr As %String [ SqlColumnNumber = 3, SqlFieldName = BPCMC_BPCConsumable_Dr ];

Property BPCMCQty As %Float [ SqlColumnNumber = 4, SqlFieldName = BPCMC_Qty ];

Property BPCMCCtlocDr As %String [ SqlColumnNumber = 5, SqlFieldName = BPCMC_Ctloc_Dr ];

/// 数据归属
Property DataAttribution As User.DHCBPCDataAttribution [ SqlColumnNumber = 6, SqlFieldName = BPCMC_DataAttribution ];

Storage CacheStorage
{
<Data name="DHCBPCModeConsumableClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCModeConsumableDefaultData">
<Value name="1">
<Value>BPCMCBPCModeDr</Value>
</Value>
<Value name="2">
<Value>BPCMCBPCConsumableDr</Value>
</Value>
<Value name="3">
<Value>BPCMCQty</Value>
</Value>
<Value name="4">
<Value>BPCMCCtlocDr</Value>
</Value>
<Value name="5">
<Value>DataAttribution</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("ModeConsumable")</DataLocation>
<DefaultData>DHCBPCModeConsumableDefaultData1</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("ModeConsumable")</IdLocation>
<IndexLocation>^DHCBPC("ModeConsumable",0)</IndexLocation>
<StreamLocation>^User.DHCBPCModeConsumableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
