Class User.DHCBPCRecordItem Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCRI_RowId, SqlTableName = DHC_BPC_RecordItem, StorageStrategy = CacheStorage ]
{

Index RecordCat On BPCRIBPCRecordCatDr As Exact;

Index ICollectCode On BPCRICollectCode;

Index ICollectCodeRecordCat On (BPCRIBPCRecordCatDr, BPCRICollectCode);

Property BPCRICode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCRI_Code ];

Property BPCRIDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCRI_Desc ];

Property BPCRIBPCRecordCatDr As User.DHCBPCRecordCat [ SqlColumnNumber = 4, SqlFieldName = BPCRI_BPCRecordCat_Dr ];

Property BPCRIType As %String(DISPLAYLIST = ",Drug,VitalSign,Event,Therapy,Lab", MAXLEN = 9, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",D,V,E,T,L") [ SqlColumnNumber = 5, SqlFieldName = BPCRI_Type ];

// 医嘱码表指针

Property BPCRIArcimDr As %String [ SqlColumnNumber = 6, SqlFieldName = BPCRI_Arcim_Dr ];

// 单位指针

Property BPCRIUomDr As %String [ SqlColumnNumber = 7, SqlFieldName = BPCRI_Uom_Dr ];

// 选项指针

Property BPCRIOptions As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = BPCRI_Options ];

// 数值类型

Property BPCRIDataType As %String(DISPLAYLIST = ",Numeric,String,Choice,MultipleChoice,Icon,Date", VALUELIST = ",N,S,C,M,I,D") [ SqlColumnNumber = 9, SqlFieldName = BPCRI_DataType ];

// 多数值代码串，以";"分

Property BPCRIMultiValueDesc As %String [ SqlColumnNumber = 10, SqlFieldName = BPCRI_MultiValueDesc ];

// 排序号

Property BPCRISortNo As %String [ SqlColumnNumber = 11, SqlFieldName = BPCRI_SortNo ];

// 正常最小值

Property BPCRIMin As %Float [ SqlColumnNumber = 12, SqlFieldName = BPCRI_Min ];

// 正常最大值

Property BPCRIMax As %Float [ SqlColumnNumber = 13, SqlFieldName = BPCRI_Max ];

// 不可能最小值

Property BPCRIImpossibleMin As %Float [ SqlColumnNumber = 14, SqlFieldName = BPCRI_ImpossibleMin ];

// 不可能最大值

Property BPCRIImpossibleMax As %Float [ SqlColumnNumber = 15, SqlFieldName = BPCRI_ImpossibleMax ];

// 主记录项指针

Property BPCRIMainRecordItemDr As User.DHCBPCRecordItem [ SqlColumnNumber = 16, SqlFieldName = BPCRI_MainRecordItem_Dr ];

// 采集代码

Property BPCRICollectCode As %String [ SqlColumnNumber = 17, SqlFieldName = BPCRI_CollectCode ];

Storage CacheStorage
{
<Data name="DHCBPCRecordItemClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCRecordItemDefaultData">
<Value name="1">
<Value>BPCRICode</Value>
</Value>
<Value name="2">
<Value>BPCRIDesc</Value>
</Value>
<Value name="3">
<Value>BPCRIBPCRecordCatDr</Value>
</Value>
<Value name="4">
<Value>BPCRIType</Value>
</Value>
<Value name="5">
<Value>BPCRIArcimDr</Value>
</Value>
<Value name="6">
<Value>BPCRIUomDr</Value>
</Value>
<Value name="7">
<Value>BPCRIOptions</Value>
</Value>
<Value name="8">
<Value>BPCRIDataType</Value>
</Value>
<Value name="9">
<Value>BPCRIMultiValueDesc</Value>
</Value>
<Value name="10">
<Value>BPCRISortNo</Value>
</Value>
<Value name="11">
<Value>BPCRIMin</Value>
</Value>
<Value name="12">
<Value>BPCRIMax</Value>
</Value>
<Value name="13">
<Value>BPCRIImpossibleMin</Value>
</Value>
<Value name="14">
<Value>BPCRIImpossibleMax</Value>
</Value>
<Value name="15">
<Value>BPCRIMainRecordItemDr</Value>
</Value>
<Value name="16">
<Value>BPCRICollectCode</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("RecordItem")</DataLocation>
<DefaultData>DHCBPCRecordItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("RecordItem")</IdLocation>
<IndexLocation>^DHCBPC("RecordItem",0)</IndexLocation>
<StreamLocation>^User.DHCBPCRecordItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
