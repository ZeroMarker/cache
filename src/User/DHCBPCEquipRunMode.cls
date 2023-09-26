Class User.DHCBPCEquipRunMode Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCERM_RowId, SqlTableName = DHC_BPC_EquipRunMode, StorageStrategy = CacheStorage ]
{

Property BPCERMCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCERM_Code ];

Property BPCERMDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCERM_Desc ];

Storage CacheStorage
{
<Data name="DHCBPCEquipRunModeClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCEquipRunModeDefaultData">
<Value name="1">
<Value>BPCERMCode</Value>
</Value>
<Value name="2">
<Value>BPCERMDesc</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("EquipRunMode")</DataLocation>
<DefaultData>DHCBPCEquipRunModeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("EquipRunMode")</IdLocation>
<IndexLocation>^DHCBPC("EquipRunMode",0)</IndexLocation>
<StreamLocation>^User.DHCBPCEquipRunModeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
