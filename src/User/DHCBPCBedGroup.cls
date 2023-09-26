Class User.DHCBPCBedGroup Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCBG_RowId, SqlTableName = DHC_BPC_BedGroup, StorageStrategy = CacheStorage ]
{

Property BPCBGCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCBG_Code ];

Property BPCBGDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCBG_Desc ];

Property BPCBGLocationDr As %String [ SqlColumnNumber = 4, SqlFieldName = BPCBG_Location_Dr ];

// 是否隔离

Property BPCBGIsolated As %Boolean [ SqlColumnNumber = 5, SqlFieldName = BPCBG_Isolated ];

// 数据归属

Property DataAttribution As User.DHCBPCDataAttribution [ SqlColumnNumber = 6, SqlFieldName = BPCBG_DataAttribution ];

Storage CacheStorage
{
<Data name="DHCBPCBedGroupClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCBedGroupDefaultData">
<Value name="1">
<Value>BPCBGCode</Value>
</Value>
<Value name="2">
<Value>BPCBGDesc</Value>
</Value>
<Value name="3">
<Value>BPCBGLocationDr</Value>
</Value>
<Value name="4">
<Value>BPCBGIsolated</Value>
</Value>
<Value name="5">
<Value>DataAttribution</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("BedGroup")</DataLocation>
<DefaultData>DHCBPCBedGroupDefaultData1</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("BedGroup")</IdLocation>
<IndexLocation>^DHCBPC("BedGroup")</IndexLocation>
<StreamLocation>^User.DHCBPCBedGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
