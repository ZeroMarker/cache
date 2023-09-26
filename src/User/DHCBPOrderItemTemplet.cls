Class User.DHCBPOrderItemTemplet Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPOIT_RowId, SqlTableName = DHC_BP_OrderItemTemplet, StorageStrategy = CacheStorage ]
{

Index DateRegister On (BPOITStartDate, BPOITBPPatRegisterDr);

Index RegisterType On (BPOITBPPatRegisterDr, BPOITOrderType);

Index Arrange On BPOITBPArrangeDr;

Property BPOITBPPatRegisterDr As User.DHCBPPatRegister [ SqlColumnNumber = 2, SqlFieldName = BPOIT_BPPatRegister_Dr ];

Property BPOITBPArrangeDr As User.DHCBPArrange [ SqlColumnNumber = 3, SqlFieldName = BPOIT_BPArrange_Dr ];

Property BPOITOrderType As %String(DISPLAYLIST = ",Normal,Stand", MAXLEN = 12, SELECTIVITY = "33.3333%", VALUELIST = ",N,S") [ SqlColumnNumber = 4, SqlFieldName = BPOIT_OrderType ];

/// 医嘱码表ID
Property BPOITArcimDr As %String [ SqlColumnNumber = 5, SqlFieldName = BPOIT_Arcim_Dr ];

Property BPOITDose As %Float [ SqlColumnNumber = 6, SqlFieldName = BPOIT_Dose ];

Property BPOITDoseUnitDr As %String [ SqlColumnNumber = 7, SqlFieldName = BPOIT_DoseUnit_Dr ];

Property BPOITPackQty As %Float [ SqlColumnNumber = 8, SqlFieldName = BPOIT_PackQty ];

Property BPOITPackUnitDr As %String [ SqlColumnNumber = 9, SqlFieldName = BPOIT_PackUnit_Dr ];

Property BPOITFreqDr As %String [ SqlColumnNumber = 10, SqlFieldName = BPOIT_Freq_Dr ];

Property BPOITInstructDr As %String [ SqlColumnNumber = 11, SqlFieldName = BPOIT_Instruct_Dr ];

Property BPOITStartDate As %Date [ SqlColumnNumber = 12, SqlFieldName = BPOIT_StartDate ];

Property BPOITStartTime As %Time [ SqlColumnNumber = 13, SqlFieldName = BPOIT_StartTime ];

Property BPOITStatus As %String(DISPLAYLIST = ",Verified,Executed,Discontinued", MAXLEN = 12, SELECTIVITY = "25%", VALUELIST = ",V,E,D") [ SqlColumnNumber = 14, SqlFieldName = BPOIT_Status ];

Property BPOITNote As %String(MAXLEN = 200) [ SqlColumnNumber = 15, SqlFieldName = BPOIT_Note ];

Property BPOITMasterSeqNo As %String [ SqlColumnNumber = 16, SqlFieldName = BPOIT_MasterSeqNo ];

Property BPOITSeqNo As %String [ SqlColumnNumber = 17, SqlFieldName = BPOIT_SeqNo ];

Property BPOITRecLocDr As %String [ SqlColumnNumber = 18, SqlFieldName = BPOIT_RecLoc_Dr ];

Property BPOITDurationDr As %String [ SqlColumnNumber = 19, SqlFieldName = BPOIT_Duration_Dr ];

Property BPOITOrderItemDr As %String [ SqlColumnNumber = 20, SqlFieldName = BPOIT_OrderItem_Dr ];

Property BPOITCreateCtcpDr As %String [ SqlColumnNumber = 21, SqlFieldName = BPOIT_CreateCtcp_Dr ];

Property BPOITCreateDate As %Date [ SqlColumnNumber = 22, SqlFieldName = BPOIT_CreateDate ];

Property BPOITCreateTime As %Time [ SqlColumnNumber = 23, SqlFieldName = BPOIT_CreateTime ];

Property BPOITXCtcpDr As %String [ SqlColumnNumber = 24, SqlFieldName = BPOIT_XCtcp_Dr ];

Property BPOITXDate As %Date [ SqlColumnNumber = 25, SqlFieldName = BPOIT_XDate ];

Property BPOITXTime As %Time [ SqlColumnNumber = 26, SqlFieldName = BPOIT_XTime ];

Property BPOITExecCtcpDr As %String [ SqlColumnNumber = 27, SqlFieldName = BPOIT_ExecCtcp_Dr ];

Property BPOITExecDate As %Date [ SqlColumnNumber = 28, SqlFieldName = BPOIT_ExecDate ];

Property BPOITExecTime As %Time [ SqlColumnNumber = 29, SqlFieldName = BPOIT_ExecTime ];

Property BPOITCancelExecCtcpDr As %String [ SqlColumnNumber = 30, SqlFieldName = BPOIT_CancelExecCtcp_Dr ];

Property BPOITCancelExecDate As %Date [ SqlColumnNumber = 31, SqlFieldName = BPOIT_CancelExecDate ];

Property BPOITCancelExecTime As %Time [ SqlColumnNumber = 32, SqlFieldName = BPOIT_CancelExecTime ];

Storage CacheStorage
{
<Data name="DHCBPOrderItemClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPOrderItemDefaultData">
<Value name="1">
<Value>BPOITBPPatRegisterDr</Value>
</Value>
<Value name="2">
<Value>BPOITBPArrangeDr</Value>
</Value>
<Value name="3">
<Value>BPOITOrderType</Value>
</Value>
<Value name="4">
<Value>BPOITArcimDr</Value>
</Value>
<Value name="5">
<Value>BPOITDose</Value>
</Value>
<Value name="6">
<Value>BPOITDoseUnitDr</Value>
</Value>
<Value name="7">
<Value>BPOITPackQty</Value>
</Value>
<Value name="8">
<Value>BPOITPackUnitDr</Value>
</Value>
<Value name="9">
<Value>BPOITFreqDr</Value>
</Value>
<Value name="10">
<Value>BPOITInstructDr</Value>
</Value>
<Value name="11">
<Value>BPOITStartDate</Value>
</Value>
<Value name="12">
<Value>BPOITStartTime</Value>
</Value>
<Value name="13">
<Value>BPOITStatus</Value>
</Value>
<Value name="14">
<Value>BPOITNote</Value>
</Value>
<Value name="15">
<Value>BPOITMasterSeqNo</Value>
</Value>
<Value name="16">
<Value>BPOITSeqNo</Value>
</Value>
<Value name="17">
<Value>BPOITRecLocDr</Value>
</Value>
<Value name="18">
<Value>BPOITDurationDr</Value>
</Value>
<Value name="19">
<Value>BPOITOrderItemDr</Value>
</Value>
<Value name="20">
<Value>BPOITCreateCtcpDr</Value>
</Value>
<Value name="21">
<Value>BPOITCreateDate</Value>
</Value>
<Value name="22">
<Value>BPOITCreateTime</Value>
</Value>
<Value name="23">
<Value>BPOITXCtcpDr</Value>
</Value>
<Value name="24">
<Value>BPOITXDate</Value>
</Value>
<Value name="25">
<Value>BPOITXTime</Value>
</Value>
<Value name="26">
<Value>BPOITExecCtcpDr</Value>
</Value>
<Value name="27">
<Value>BPOITExecDate</Value>
</Value>
<Value name="28">
<Value>BPOITExecTime</Value>
</Value>
<Value name="29">
<Value>BPOITCancelExecCtcpDr</Value>
</Value>
<Value name="30">
<Value>BPOITCancelExecDate</Value>
</Value>
<Value name="31">
<Value>BPOITCancelExecTime</Value>
</Value>
</Data>
<DataLocation>^DHCBPOrderItemTemplet</DataLocation>
<DefaultData>DHCBPOrderItemTempletDefaultData1</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPOrderItemTemplet</IdLocation>
<IndexLocation>^DHCBPOrderItemTemplet(0)</IndexLocation>
<StreamLocation>^User.DHCBPOrderItemTempletS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
