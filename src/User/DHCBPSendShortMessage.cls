Class User.DHCBPSendShortMessage Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPSSM_RowId, SqlTableName = DHC_BP_SendShortMessage, StorageStrategy = CacheStorage ]
{

Index PatRegister On BPSSMBPPatRegisterDr As Exact;

Index Date On BPSSMDate As Exact;

Property BPSSMBPPatRegisterDr As User.DHCBPPatRegister [ SqlColumnNumber = 2, SqlFieldName = BPSSM_BPPatRegister_Dr ];

Property BPSSMDate As %Date [ SqlColumnNumber = 3, SqlFieldName = BPSSM_Date ];

Property BPSSMTime As %Time [ SqlColumnNumber = 4, SqlFieldName = BPSSM_Time ];

Property BPSSMStatus As %String(DISPLAYLIST = ",Normal,Cancel", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,C") [ SqlColumnNumber = 5, SqlFieldName = BPSSM_Status ];

Property BPSSMCtcpDr As %String [ SqlColumnNumber = 6, SqlFieldName = BPSSM_Ctcp_Dr ];

/// 电话号码
Property BPSSMPhone As %String [ SqlColumnNumber = 7, SqlFieldName = BPSSM_Phone ];

/// 发生内容
Property BPSSMNote As %String(MAXLEN = 1000) [ SqlColumnNumber = 8, SqlFieldName = BPSSM_Note ];

/// 班次
Property BPSSMDaySeqNo As %String [ SqlColumnNumber = 9, SqlFieldName = BPSSM_DaySeqNo ];

Storage CacheStorage
{
<Data name="DHCBPSendShortMessageClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPSendShortMessageDefaultData">
<Value name="1">
<Value>BPSSMBPPatRegisterDr</Value>
</Value>
<Value name="2">
<Value>BPSSMDate</Value>
</Value>
<Value name="3">
<Value>BPSSMTime</Value>
</Value>
<Value name="4">
<Value>BPSSMStatus</Value>
</Value>
<Value name="5">
<Value>BPSSMCtcpDr</Value>
</Value>
<Value name="6">
<Value>BPSSMPhone</Value>
</Value>
<Value name="7">
<Value>BPSSMNote</Value>
</Value>
<Value name="8">
<Value>BPSSMDaySeqNo</Value>
</Value>
</Data>
<DataLocation>^DHCBPSendShortMessage</DataLocation>
<DefaultData>DHCBPSendShortMessageDefaultData</DefaultData>
<IdLocation>^DHCBPSendShortMessage</IdLocation>
<IndexLocation>^DHCBPSendShortMessage(0)</IndexLocation>
<StreamLocation>^User.DHCBPSendShortMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
