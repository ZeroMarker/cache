Class User.DHCBPCAnticoagulantModeDrug Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_BPC_AnticoagulantModeDrug, StorageStrategy = CacheStorage ]
{

Property BPCAMDBPCAMDr As User.DHCBPCAnticoagulantMode [ SqlColumnNumber = 2, SqlFieldName = BPCAMD_BPCAM_Dr ];

Property BPCAMDBPCADDr As %String [ SqlColumnNumber = 3, SqlFieldName = BPCAMD_BPCAD_Dr ];

Storage CacheStorage
{
<Data name="BPCAnticoagulantModeDrugClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="BPCAnticoagulantModeDrugDefaultData">
<Value name="1">
<Value>BPCAMDBPCAMDr</Value>
</Value>
<Value name="2">
<Value>BPCAMDBPCADDr</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("AnticoagulantModeDrug")</DataLocation>
<DefaultData>BPCAnticoagulantModeDrugDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("AnticoagulantModeDrug")</IdLocation>
<IndexLocation>^DHCBPC("AnticoagulantModeDrug",0)</IndexLocation>
<StreamLocation>^User.DHCBPCAntic9FF8S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
