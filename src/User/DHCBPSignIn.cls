Class User.DHCBPSignIn Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPSI_RowId, SqlTableName = DHC_BP_SignIn, StorageStrategy = CacheStorage ]
{

Index RegNo On BPSIRegNo;

Index Date On BPSIDate As Exact;

Property BPSIRegNo As %String [ SqlColumnNumber = 2, SqlFieldName = BPSI_RegNo ];

Property BPSIDate As %Date [ SqlColumnNumber = 3, SqlFieldName = BPSI_Date ];

Property BPSITime As %Time [ SqlColumnNumber = 4, SqlFieldName = BPSI_Time ];

Property BPSIStatus As %String(DISPLAYLIST = ",Normal,Delete", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,D") [ SqlColumnNumber = 5, SqlFieldName = BPSI_Status ];

Property BPSICtcpDr As %String [ SqlColumnNumber = 6, SqlFieldName = BPSI_Ctcp_Dr ];

/// 签到设备
Property BPSIEquip As %String [ SqlColumnNumber = 7, SqlFieldName = BPSI_Equip ];

/// 当前班次签到序号
Property BPSISeqNo As %String [ SqlColumnNumber = 8, SqlFieldName = BPSI_SeqNo ];

/// 班次
Property BPSIDaySeqNo As %String [ SqlColumnNumber = 9, SqlFieldName = BPSI_DaySeqNo ];

/// 接诊时间
Property BPSIReceiveTime As %String [ SqlColumnNumber = 10, SqlFieldName = BPSI_ReceiveTime ];

Storage CacheStorage
{
<Data name="DHCBPSignInClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPSignInDefaultData">
<Value name="1">
<Value>BPSIRegNo</Value>
</Value>
<Value name="2">
<Value>BPSIDate</Value>
</Value>
<Value name="3">
<Value>BPSITime</Value>
</Value>
<Value name="4">
<Value>BPSIStatus</Value>
</Value>
<Value name="5">
<Value>BPSICtcpDr</Value>
</Value>
<Value name="6">
<Value>BPSIEquip</Value>
</Value>
<Value name="7">
<Value>BPSISeqNo</Value>
</Value>
<Value name="8">
<Value>BPSIDaySeqNo</Value>
</Value>
<Value name="9">
<Value>BPSIReceiveTime</Value>
</Value>
</Data>
<DataLocation>^DHCBPSignIn</DataLocation>
<DefaultData>DHCBPSignInDefaultData</DefaultData>
<IdLocation>^DHCBPSignIn</IdLocation>
<IndexLocation>^DHCBPSignIn(0)</IndexLocation>
<StreamLocation>^User.DHCBPSignInS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
