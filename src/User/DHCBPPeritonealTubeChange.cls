Class User.DHCBPPeritonealTubeChange Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPPTC_RowId, SqlTableName = DHC_BP_PeritonealTubeChange, StorageStrategy = CacheStorage ]
{

Property BPPTCBPPatRegisterDr As User.DHCBPPatRegister [ SqlColumnNumber = 2, SqlFieldName = BPPTC_BPPatRegister_Dr ];

Property BPPTCDate As %Date [ SqlColumnNumber = 3, SqlFieldName = BPPTC_Date ];

Property BPPTCTime As %Time [ SqlColumnNumber = 4, SqlFieldName = BPPTC_Time ];

Property BPPTCSystolicBP As %Float [ SqlColumnNumber = 5, SqlFieldName = BPPTC_SystolicBP ];

Property BPPTCDiastolicBP As %Float [ SqlColumnNumber = 6, SqlFieldName = BPPTC_DiastolicBP ];

Property BPPTCPulse As %Float [ SqlColumnNumber = 7, SqlFieldName = BPPTC_Pulse ];

Property BPPTCReason As %String [ SqlColumnNumber = 8, SqlFieldName = BPPTC_Reason ];

Property BPPTCIsDisconnect As %Boolean [ SqlColumnNumber = 9, SqlFieldName = BPPTC_IsDisconnect ];

Property BPPTCIsSmoothChange As %Boolean [ SqlColumnNumber = 10, SqlFieldName = BPPTC_IsSmoothChange ];

Property BPPTCInput As %Float [ SqlColumnNumber = 11, SqlFieldName = BPPTC_Input ];

Property BPPTCOutput As %Float [ SqlColumnNumber = 12, SqlFieldName = BPPTC_Output ];

Property BPPTCIsNormalDrainage As %Boolean [ SqlColumnNumber = 13, SqlFieldName = BPPTC_IsNormalDrainage ];

Property BPPTCNote As %String(MAXLEN = 500) [ SqlColumnNumber = 14, SqlFieldName = BPPTC_Note ];

Index PatRegister On BPPTCBPPatRegisterDr As Exact;

Index Date On BPPTCDate As Exact;

Storage CacheStorage
{
<Data name="BPPeritonealTubeChangeClassData">
<Value name="1">
<Value>BPPTCBPPatRegisterDr</Value>
</Value>
<Value name="2">
<Value>BPPTCDate</Value>
</Value>
<Value name="3">
<Value>BPPTCTime</Value>
</Value>
<Value name="4">
<Value>BPPTCSystolicBP</Value>
</Value>
<Value name="5">
<Value>BPPTCDiastolicBP</Value>
</Value>
<Value name="6">
<Value>BPPTCPulse</Value>
</Value>
<Value name="7">
<Value>BPPTCReason</Value>
</Value>
<Value name="8">
<Value>BPPTCIsDisconnect</Value>
</Value>
<Value name="9">
<Value>BPPTCIsSmoothChange</Value>
</Value>
<Value name="10">
<Value>BPPTCInput</Value>
</Value>
<Value name="11">
<Value>BPPTCOutput</Value>
</Value>
<Value name="12">
<Value>BPPTCIsNormalDrainage</Value>
</Value>
<Value name="13">
<Value>BPPTCNote</Value>
</Value>
</Data>
<Data name="BPPeritonealTubeChangeClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<DataLocation>^DHCBPPeritonealTubeChange</DataLocation>
<IdLocation>^DHCBPPeritonealTubeChange</IdLocation>
<IndexLocation>^DHCBPPeritonealTubeChange(0)</IndexLocation>
<StreamLocation>^User.DHCBPPeritoF7D1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
