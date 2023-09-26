Class User.DHCBPCBed Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCB_RowId, SqlTableName = DHC_BPC_Bed, StorageStrategy = CacheStorage ]
{

Property BPCBCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCB_Code ];

Property BPCBDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCB_Desc ];

Property BPCBBPCBedGroupDr As User.DHCBPCBedGroup [ SqlColumnNumber = 4, SqlFieldName = BPCB_BPCBedGroup_Dr ];

Property BPCBStatus As %String(DISPLAYLIST = ",Idle,Occupied", MAXLEN = 8, SELECTIVITY = "33.3333%", VALUELIST = ",I,O") [ SqlColumnNumber = 5, SqlFieldName = BPCB_Status ];

Property BPCBType As %String [ SqlColumnNumber = 6, SqlFieldName = BPCB_Type ];

Property BPCBPositionLeft As %Float [ SqlColumnNumber = 7, SqlFieldName = BPCB_PositionLeft ];

Property BPCBPositionTop As %Float [ SqlColumnNumber = 8, SqlFieldName = BPCB_PositionTop ];

Property BPCBPositionWidth As %Float [ SqlColumnNumber = 9, SqlFieldName = BPCB_PositionWidth ];

Property BPCBPositionHeight As %Float [ SqlColumnNumber = 10, SqlFieldName = BPCB_PositionHeight ];

/// 别名
Property BPCBAbbrev As %Float [ SqlColumnNumber = 11, SqlFieldName = BPCB_Abbrev ];

/// 支持滤过的床(1支持滤过，0或者空不支持滤过)
Property BPCBIsFiltration As %Boolean [ SqlColumnNumber = 12, SqlFieldName = BPCB_IsFiltration ];

/// 数据归属
Property DataAttribution As User.DHCBPCDataAttribution [ SqlColumnNumber = 13, SqlFieldName = BPCB_DataAttribution ];

Storage CacheStorage
{
<Data name="DHCBPCBedClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCBedDefaultData">
<Value name="1">
<Value>BPCBCode</Value>
</Value>
<Value name="2">
<Value>BPCBDesc</Value>
</Value>
<Value name="3">
<Value>BPCBBPCBedGroupDr</Value>
</Value>
<Value name="4">
<Value>BPCBStatus</Value>
</Value>
<Value name="5">
<Value>BPCBType</Value>
</Value>
<Value name="6">
<Value>BPCBPositionLeft</Value>
</Value>
<Value name="7">
<Value>BPCBPositionTop</Value>
</Value>
<Value name="8">
<Value>BPCBPositionWidth</Value>
</Value>
<Value name="9">
<Value>BPCBPositionHeight</Value>
</Value>
<Value name="10">
<Value>BPCBAbbrev</Value>
</Value>
<Value name="11">
<Value>BPCBIsFiltration</Value>
</Value>
<Value name="12">
<Value>DataAttribution</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("Bed")</DataLocation>
<DefaultData>DHCBPCBedDefaultData1</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("Bed")</IdLocation>
<IndexLocation>^DHCBPC("Bed")</IndexLocation>
<StreamLocation>^User.DHCBPCBedS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
