Class User.DHCBPCEquipRunParaCat Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCERPC_RowId, SqlTableName = DHC_BPC_EquipRunParaCat, StorageStrategy = CacheStorage ]
{

Property BPCERPCCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCERPC_Code ];

Property BPCERPCDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCERPC_Desc ];

Property BPCERPCValueType As %String(DISPLAYLIST = ",Image,Range,Value", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",I,R,V") [ SqlColumnNumber = 4, SqlFieldName = BPCERPC_ValueType ];

Storage CacheStorage
{
<Data name="BPCEquipRunParaCatClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="BPCEquipRunParaCatDefaultData">
<Value name="1">
<Value>BPCERPCCode</Value>
</Value>
<Value name="2">
<Value>BPCERPCDesc</Value>
</Value>
<Value name="3">
<Value>BPCERPCValueType</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("EquipRunParaCat")</DataLocation>
<DefaultData>BPCEquipRunParaCatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("EquipRunParaCat")</IdLocation>
<IndexLocation>^DHCBPC("EquipRunParaCat",0)</IndexLocation>
<StreamLocation>^User.DHCBPCEquipRunParaCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
