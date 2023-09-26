Class User.DHCBPCEquipPart Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCEP_RowId, SqlTableName = DHC_BPC_EquipPart, StorageStrategy = CacheStorage ]
{

Index BPCEquipModel On BPCEPBPCEquipModelDr As Exact;

Property BPCEPBPCEquipModelDr As User.DHCBPCEquipModel [ SqlColumnNumber = 2, SqlFieldName = BPCEP_BPCEquipModel_Dr ];

Property BPCEPCode As %String [ SqlColumnNumber = 3, SqlFieldName = BPCEP_Code ];

Property BPCEPDesc As %String [ SqlColumnNumber = 4, SqlFieldName = BPCEP_Desc ];

Storage CacheStorage
{
<Data name="DHCBPCEquipPartClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCEquipPartDefaultData">
<Value name="1">
<Value>BPCEPBPCEquipModelDr</Value>
</Value>
<Value name="2">
<Value>BPCEPCode</Value>
</Value>
<Value name="3">
<Value>BPCEPDesc</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("EquipPart")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("EquipPart")</IdLocation>
<IndexLocation>^DHCBPC("EquipPart",0)</IndexLocation>
<StreamLocation>^User.DHCBPCEquipPartS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
