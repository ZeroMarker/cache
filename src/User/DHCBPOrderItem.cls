Class User.DHCBPOrderItem Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPOI_RowId, SqlTableName = DHC_BP_OrderItem, StorageStrategy = CacheStorage ]
{

Index DateRegister On (BPOIStartDate, BPOIBPPatRegisterDr);

Index RegisterType On (BPOIBPPatRegisterDr, BPOIOrderType);

Index Arrange On BPOIBPArrangeDr;

Index StartDate On BPOIStartDate;

Property BPOIBPPatRegisterDr As User.DHCBPPatRegister [ SqlColumnNumber = 2, SqlFieldName = BPOI_BPPatRegister_Dr ];

Property BPOIBPArrangeDr As User.DHCBPArrange [ SqlColumnNumber = 3, SqlFieldName = BPOI_BPArrange_Dr ];

Property BPOIOrderType As %String(DISPLAYLIST = ",Normal,Stand", MAXLEN = 12, SELECTIVITY = "33.3333%", VALUELIST = ",N,S") [ SqlColumnNumber = 4, SqlFieldName = BPOI_OrderType ];

/// 医嘱码表ID
Property BPOIArcimDr As %String [ SqlColumnNumber = 5, SqlFieldName = BPOI_Arcim_Dr ];

Property BPOIDose As %Float [ SqlColumnNumber = 6, SqlFieldName = BPOI_Dose ];

Property BPOIDoseUnitDr As %String [ SqlColumnNumber = 7, SqlFieldName = BPOI_DoseUnit_Dr ];

Property BPOIPackQty As %Float [ SqlColumnNumber = 8, SqlFieldName = BPOI_PackQty ];

Property BPOIPackUnitDr As %String [ SqlColumnNumber = 9, SqlFieldName = BPOI_PackUnit_Dr ];

Property BPOIFreqDr As %String [ SqlColumnNumber = 10, SqlFieldName = BPOI_Freq_Dr ];

Property BPOIInstructDr As %String [ SqlColumnNumber = 11, SqlFieldName = BPOI_Instruct_Dr ];

Property BPOIStartDate As %Date [ SqlColumnNumber = 12, SqlFieldName = BPOI_StartDate ];

Property BPOIStartTime As %Time [ SqlColumnNumber = 13, SqlFieldName = BPOI_StartTime ];

Property BPOIStatus As %String(DISPLAYLIST = ",Verified,Executed,Discontinued", MAXLEN = 12, SELECTIVITY = "25%", VALUELIST = ",V,E,D") [ SqlColumnNumber = 14, SqlFieldName = BPOI_Status ];

Property BPOINote As %String(MAXLEN = 200) [ SqlColumnNumber = 15, SqlFieldName = BPOI_Note ];

Property BPOIMasterSeqNo As %String [ SqlColumnNumber = 16, SqlFieldName = BPOI_MasterSeqNo ];

Property BPOISeqNo As %String [ SqlColumnNumber = 17, SqlFieldName = BPOI_SeqNo ];

Property BPOIRecLocDr As %String [ SqlColumnNumber = 18, SqlFieldName = BPOI_RecLoc_Dr ];

Property BPOIDurationDr As %String [ SqlColumnNumber = 19, SqlFieldName = BPOI_Duration_Dr ];

Property BPOIOrderItemDr As %String [ SqlColumnNumber = 20, SqlFieldName = BPOI_OrderItem_Dr ];

Property BPOICreateCtcpDr As %String [ SqlColumnNumber = 21, SqlFieldName = BPOI_CreateCtcp_Dr ];

Property BPOICreateDate As %Date [ SqlColumnNumber = 22, SqlFieldName = BPOI_CreateDate ];

Property BPOICreateTime As %Time [ SqlColumnNumber = 23, SqlFieldName = BPOI_CreateTime ];

Property BPOIXCtcpDr As %String [ SqlColumnNumber = 24, SqlFieldName = BPOI_XCtcp_Dr ];

Property BPOIXDate As %Date [ SqlColumnNumber = 25, SqlFieldName = BPOI_XDate ];

Property BPOIXTime As %Time [ SqlColumnNumber = 26, SqlFieldName = BPOI_XTime ];

Property BPOIExecCtcpDr As %String [ SqlColumnNumber = 27, SqlFieldName = BPOI_ExecCtcp_Dr ];

Property BPOIExecDate As %Date [ SqlColumnNumber = 28, SqlFieldName = BPOI_ExecDate ];

Property BPOIExecTime As %Time [ SqlColumnNumber = 29, SqlFieldName = BPOI_ExecTime ];

Property BPOICancelExecCtcpDr As %String [ SqlColumnNumber = 30, SqlFieldName = BPOI_CancelExecCtcp_Dr ];

Property BPOICancelExecDate As %Date [ SqlColumnNumber = 31, SqlFieldName = BPOI_CancelExecDate ];

Property BPOICancelExecTime As %Time [ SqlColumnNumber = 32, SqlFieldName = BPOI_CancelExecTime ];

Storage CacheStorage
{
<Data name="DHCBPOrderItemClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPOrderItemDefaultData">
<Value name="1">
<Value>BPOIBPPatRegisterDr</Value>
</Value>
<Value name="2">
<Value>BPOIBPArrangeDr</Value>
</Value>
<Value name="3">
<Value>BPOIOrderType</Value>
</Value>
<Value name="4">
<Value>BPOIArcimDr</Value>
</Value>
<Value name="5">
<Value>BPOIDose</Value>
</Value>
<Value name="6">
<Value>BPOIDoseUnitDr</Value>
</Value>
<Value name="7">
<Value>BPOIPackQty</Value>
</Value>
<Value name="8">
<Value>BPOIPackUnitDr</Value>
</Value>
<Value name="9">
<Value>BPOIFreqDr</Value>
</Value>
<Value name="10">
<Value>BPOIInstructDr</Value>
</Value>
<Value name="11">
<Value>BPOIStartDate</Value>
</Value>
<Value name="12">
<Value>BPOIStartTime</Value>
</Value>
<Value name="13">
<Value>BPOIStatus</Value>
</Value>
<Value name="14">
<Value>BPOINote</Value>
</Value>
<Value name="15">
<Value>BPOIMasterSeqNo</Value>
</Value>
<Value name="16">
<Value>BPOISeqNo</Value>
</Value>
<Value name="17">
<Value>BPOIRecLocDr</Value>
</Value>
<Value name="18">
<Value>BPOIDurationDr</Value>
</Value>
<Value name="19">
<Value>BPOIOrderItemDr</Value>
</Value>
<Value name="20">
<Value>BPOICreateCtcpDr</Value>
</Value>
<Value name="21">
<Value>BPOICreateDate</Value>
</Value>
<Value name="22">
<Value>BPOICreateTime</Value>
</Value>
<Value name="23">
<Value>BPOIXCtcpDr</Value>
</Value>
<Value name="24">
<Value>BPOIXDate</Value>
</Value>
<Value name="25">
<Value>BPOIXTime</Value>
</Value>
<Value name="26">
<Value>BPOIExecCtcpDr</Value>
</Value>
<Value name="27">
<Value>BPOIExecDate</Value>
</Value>
<Value name="28">
<Value>BPOIExecTime</Value>
</Value>
<Value name="29">
<Value>BPOICancelExecCtcpDr</Value>
</Value>
<Value name="30">
<Value>BPOICancelExecDate</Value>
</Value>
<Value name="31">
<Value>BPOICancelExecTime</Value>
</Value>
</Data>
<DataLocation>^DHCBPOrderItem</DataLocation>
<DefaultData>DHCBPOrderItemDefaultData1</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPOrderItem</IdLocation>
<IndexLocation>^DHCBPOrderItem(0)</IndexLocation>
<StreamLocation>^User.DHCBPOrderItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
