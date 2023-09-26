Class User.DHCBPComplication Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPC_RowId, SqlTableName = DHC_BP_Complication, StorageStrategy = NewStorage1 ]
{

Index Register On BPCPatRegisterDr;

Property BPCPatRegisterDr As User.DHCBPPatRegister [ SqlColumnNumber = 2, SqlFieldName = BPC_PatRegister_Dr ];

/// 发生事件
Property BPCOccurrence As %String [ SqlColumnNumber = 3, SqlFieldName = BPC_Occurrence ];

/// 事件描述
Property BPCEventDescription As %String [ SqlColumnNumber = 4, SqlFieldName = BPC_EventDescription ];

/// 病情处理
Property BPCTreatmentOfDisease As %String [ SqlColumnNumber = 5, SqlFieldName = BPC_TreatmentOfDisease ];

Property BPCDate As %Date [ SqlColumnNumber = 6, SqlFieldName = BPC_Date ];

Property BPCStatus As %String(DISPLAYLIST = ",Normal,Delete", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,D") [ SqlColumnNumber = 62, SqlFieldName = BPC_Status ];

Property BPCCreateCtcpDr As %String [ SqlColumnNumber = 8, SqlFieldName = BPC_CreateCtcp_Dr ];

Property BPCCreateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = BPC_CreateDate ];

Property BPCCreateTime As %Time [ SqlColumnNumber = 10, SqlFieldName = BPC_CreateTime ];

Property BPCUpdateCtcpDr As %String [ SqlColumnNumber = 11, SqlFieldName = BPC_UpdateCtcp_Dr ];

Property BPCUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = BPC_UpdateDate ];

Property BPCUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = BPC_UpdateTime ];

Storage NewStorage1
{
<Data name="DHCBPComplicationClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPComplicationDefaultData">
<Value name="1">
<Value>BPCPatRegisterDr</Value>
</Value>
<Value name="2">
<Value>BPCOccurrence</Value>
</Value>
<Value name="3">
<Value>BPCEventDescription</Value>
</Value>
<Value name="4">
<Value>BPCTreatmentOfDisease</Value>
</Value>
<Value name="5">
<Value>BPCDate</Value>
</Value>
<Value name="6">
<Value>BPCStatus</Value>
</Value>
<Value name="7">
<Value>BPCCreateCtcpDr</Value>
</Value>
<Value name="8">
<Value>BPCCreateDate</Value>
</Value>
<Value name="9">
<Value>BPCCreateTime</Value>
</Value>
<Value name="10">
<Value>BPCUpdateCtcpDr</Value>
</Value>
<Value name="11">
<Value>BPCUpdateDate</Value>
</Value>
<Value name="12">
<Value>BPCUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCBPComplication</DataLocation>
<DefaultData>DHCBPComplicationDefaultData</DefaultData>
<IdLocation>^DHCBPComplication</IdLocation>
<IndexLocation>^DHCBPComplication(0)</IndexLocation>
<StreamLocation>^User.DHCBPComplicationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
