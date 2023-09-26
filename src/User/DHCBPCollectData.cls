Class User.DHCBPCollectData Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCD_RowId, SqlTableName = DHC_BP_CollectData, StorageStrategy = CacheStorage ]
{

Property BPCDBPArrangeDr As User.DHCBPArrange [ SqlColumnNumber = 2, SqlFieldName = BPCD_BPArrange_Dr ];

Property BPCDRecordItemDr As User.DHCBPCRecordItem [ SqlColumnNumber = 3, SqlFieldName = BPCD_RecordItem_Dr ];

Property BPCDStartDate As %Date [ SqlColumnNumber = 4, SqlFieldName = BPCD_StartDate ];

Property BPCDStartTime As %Time [ SqlColumnNumber = 5, SqlFieldName = BPCD_StartTime ];

Property BPCDNote As %String [ SqlColumnNumber = 6, SqlFieldName = BPCD_Text ];

Property BPCDQty As %Float [ SqlColumnNumber = 7, SqlFieldName = BPCD_Num ];

Property BPCDUpdateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = BPCD_UpdateDate ];

Property BPCDUpdateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = BPCD_UpdateTime ];

Index BpaId On (BPCDBPArrangeDr As Exact, BPCDStartDate As Exact, BPCDStartTime As Plus);

Index RecordItemId On (BPCDRecordItemDr As Plus, BPCDStartDate As Exact, BPCDStartTime As Plus);

Storage CacheStorage
{
<Data name="DHCBPCollectDataClass">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCollectDataDefaultData">
<Value name="1">
<Value>BPCDBPArrangeDr</Value>
</Value>
<Value name="2">
<Value>BPCDRecordItemDr</Value>
</Value>
<Value name="3">
<Value>BPCDStartDate</Value>
</Value>
<Value name="4">
<Value>BPCDStartTime</Value>
</Value>
<Value name="5">
<Value>BPCDNote</Value>
</Value>
<Value name="6">
<Value>BPCDQty</Value>
</Value>
<Value name="7">
<Value>BPCDUpdateDate</Value>
</Value>
<Value name="8">
<Value>BPCDUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCBPCollectData</DataLocation>
<DefaultData>DHCBPCollectDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPCollectData</IdLocation>
<IndexLocation>^DHCBPCollectData(0)</IndexLocation>
<StreamLocation>^User.DHCBPCollectDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
