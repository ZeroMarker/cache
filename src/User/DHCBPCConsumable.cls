Class User.DHCBPCConsumable Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_BPC_Consumable, StorageStrategy = CacheStorage ]
{

Property BPCCCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCC_Code ];

Property BPCCDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCC_Desc ];

Property BPCCType As %String(DISPLAYLIST = ",Dialyzer,Filter,Perfusion,Segregator,Adsorber,Other", MAXLEN = 9, SELECTIVITY = "15%", VALUELIST = ",D,F,P,S,A,O") [ SqlColumnNumber = 4, SqlFieldName = BPCC_Type ];

/// 膜面积
Property BPCCMembraneArea As %Float [ SqlColumnNumber = 5, SqlFieldName = BPCC_MembraneArea ];

/// 是否高通量
Property BPCCHighFluxed As %Boolean [ SqlColumnNumber = 6, SqlFieldName = BPCC_HighFluxed ];

/// 医嘱码表指针
Property BPCCArcimDr As %String [ SqlColumnNumber = 7, SqlFieldName = BPCC_Arcim_Dr ];

Storage CacheStorage
{
<Data name="DHCBPCConsumableClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCConsumableDefaultData">
<Value name="1">
<Value>BPCCCode</Value>
</Value>
<Value name="2">
<Value>BPCCDesc</Value>
</Value>
<Value name="3">
<Value>BPCCType</Value>
</Value>
<Value name="4">
<Value>BPCCMembraneArea</Value>
</Value>
<Value name="5">
<Value>BPCCHighFluxed</Value>
</Value>
<Value name="6">
<Value>BPCCArcimDr</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("Consumable")</DataLocation>
<DefaultData>DHCBPCConsumableDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("Consumable")</IdLocation>
<IndexLocation>^DHCBPC("Consumable",0)</IndexLocation>
<StreamLocation>^User.DHCBPCConsumableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
