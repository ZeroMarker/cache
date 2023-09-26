Class User.DHCBPRecord Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPR_RowId, SqlTableName = DHC_BP_Record, StorageStrategy = CacheStorage ]
{

Index DateTime On (BPRStartDate As Exact, BPRBPArrangeDr As Exact, BPRStartTime As Plus);

Index RecordItem On (BPRBPCRecordItemDr As Exact, BPRBPArrangeDr As Exact);

Property BPRBPArrangeDr As User.DHCBPArrange [ SqlColumnNumber = 2, SqlFieldName = BPR_BPArrange_Dr ];

Property BPRBPCRecordItemDr As User.DHCBPCRecordItem [ SqlColumnNumber = 5, SqlFieldName = BPR_BPCRecordItem_Dr ];

Property BPRBPCRecordCatDr As User.DHCBPCRecordCat [ SqlColumnNumber = 6, SqlFieldName = BPR_BPCRecordCat_Dr ];

Property BPROeoriDr As %String [ SqlColumnNumber = 7, SqlFieldName = BPR_Oeori_Dr ];

Property BPRStartDate As %Date [ SqlColumnNumber = 8, SqlFieldName = BPR_StartDate ];

Property BPRStartTime As %Time [ SqlColumnNumber = 9, SqlFieldName = BPR_StartTime ];

Property BPREndDate As %Date [ SqlColumnNumber = 10, SqlFieldName = BPR_EndDate ];

Property BPREndTime As %Time [ SqlColumnNumber = 11, SqlFieldName = BPR_EndTime ];

Property BPRArcimDr As %String [ SqlColumnNumber = 12, SqlFieldName = BPR_Arcim_Dr ];

Property BPREditStatus As %String(DISPLAYLIST = ",Normal,Edit,Changed,Delete,Removed,Pause,Undo,Ignore", MAXLEN = 7, SELECTIVITY = "11.1111%", TRUNCATE = 1, VALUELIST = ",N,E,C,D,R,P,U,I") [ SqlColumnNumber = 13, SqlFieldName = BPR_EditStatus ];

Property BPRType As %String(DISPLAYLIST = ",Drug,VitalSign,Event,Therapy,Lab", MAXLEN = 9, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",D,V,E,T,L") [ SqlColumnNumber = 14, SqlFieldName = BPR_Type ];

Property BPRSource As %String(DISPLAYLIST = ",Instrument,Manual,Assistant", MAXLEN = 10, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",I,M,A") [ SqlColumnNumber = 15, SqlFieldName = BPR_Source ];

Property BPRAbbreviate As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = BPR_Abbreviate ];

Property BPRQty As %Float [ SqlColumnNumber = 17, SqlFieldName = BPR_Qty ];

Property BPRNote As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = BPR_Note ];

Property BPRUomDr As %String [ SqlColumnNumber = 19, SqlFieldName = BPR_Uom_Dr ];

//医嘱用法指针

Property BPRInstrctDr As %String [ SqlColumnNumber = 20, SqlFieldName = BPR_Instrct_Dr ];

//医嘱接收科室

Property BPRRecLocDr As %String [ SqlColumnNumber = 21, SqlFieldName = BPR_RecLoc_Dr ];

Property BPRSpeed As %Float [ SqlColumnNumber = 22, SqlFieldName = BPR_Speed ];

//速度单位

Property BPRSpeedUnitDr As User.DHCANCSpeedUnit [ SqlColumnNumber = 23, SqlFieldName = BPR_SpeedUnit_Dr ];

Property BPRUpdateUserDr As %String [ SqlColumnNumber = 24, SqlFieldName = BPR_UpdateUser_Dr ];

Property BPRUpdateDate As %Date [ SqlColumnNumber = 25, SqlFieldName = BPR_UpdateDate ];

Property BPRUpdateTime As %Time [ SqlColumnNumber = 26, SqlFieldName = BPR_UpdateTime ];

Storage CacheStorage
{
<Data name="DHCBPRecordClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="DHCBPRecordDefaultData">
<Value name="1">
<Value>BPRBPArrangeDr</Value>
</Value>
<Value name="2">
<Value>BPRBPCRecordItemDr</Value>
</Value>
<Value name="3">
<Value>BPRBPCRecordCatDr</Value>
</Value>
<Value name="4">
<Value>BPROeoriDr</Value>
</Value>
<Value name="5">
<Value>BPRStartDate</Value>
</Value>
<Value name="6">
<Value>BPRStartTime</Value>
</Value>
<Value name="7">
<Value>BPREndDate</Value>
</Value>
<Value name="8">
<Value>BPREndTime</Value>
</Value>
<Value name="9">
<Value>BPRArcimDr</Value>
</Value>
<Value name="10">
<Value>BPREditStatus</Value>
</Value>
<Value name="11">
<Value>BPRType</Value>
</Value>
<Value name="12">
<Value>BPRSource</Value>
</Value>
<Value name="13">
<Value>BPRAbbreviate</Value>
</Value>
<Value name="14">
<Value>BPRQty</Value>
</Value>
<Value name="15">
<Value>BPRNote</Value>
</Value>
<Value name="16">
<Value>BPRUomDr</Value>
</Value>
<Value name="17">
<Value>BPRInstrctDr</Value>
</Value>
<Value name="18">
<Value>BPRRecLocDr</Value>
</Value>
<Value name="19">
<Value>BPRSpeed</Value>
</Value>
<Value name="20">
<Value>BPRSpeedUnitDr</Value>
</Value>
<Value name="21">
<Value>BPRUpdateUserDr</Value>
</Value>
<Value name="22">
<Value>BPRUpdateDate</Value>
</Value>
<Value name="23">
<Value>BPRUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCBPRecord</DataLocation>
<DefaultData>DHCBPRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPRecord</IdLocation>
<IndexLocation>^DHCBPRecord(0)</IndexLocation>
<StreamLocation>^User.DHCBPRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
