Class User.DHCBPPatSetUpBedGroup Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPP_RowId, SqlTableName = DHC_BP_PatSetUpBedGroup, StorageStrategy = CacheStorage ]
{

Index BedGroup On BPPBPCBedGroupDr As Exact;

Index PatRegister On BPPBPPatRegisterDr As Exact;

/// 床位组
Property BPPBPCBedGroupDr As User.DHCBPCBedGroup [ SqlColumnNumber = 2, SqlFieldName = BPP_BPCBedGroup_Dr ];

/// 透析登记号
Property BPPBPPatRegisterDr As User.DHCBPPatRegister [ SqlColumnNumber = 3, SqlFieldName = BPP_BPPatRegister_Dr ];

Property BPPUserDr As %String [ SqlColumnNumber = 4, SqlFieldName = BPP_User_Dr ];

Property BPPDate As %Date [ SqlColumnNumber = 5, SqlFieldName = BPP_Date ];

Property BPPTime As %Time [ SqlColumnNumber = 6, SqlFieldName = BPP_Time ];

/// N正常，D删除
Property BPPStatus As %String(DISPLAYLIST = ",Normal,Delete", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,D") [ SqlColumnNumber = 7, SqlFieldName = BPP_Status ];

/// 接诊时间
Property BPPReceptionTime As %String [ SqlColumnNumber = 8, SqlFieldName = BPP_ReceptionTime ];

/// 班次
Property BPPDaySeqNo As %String [ SqlColumnNumber = 9, SqlFieldName = BPP_DaySeqNo ];

/// 床位
Property BPPBPCBedDr As User.DHCBPCBed [ SqlColumnNumber = 10, SqlFieldName = BPP_BPCBed_Dr ];

Storage CacheStorage
{
<Data name="DHCBPPatSetUpBedGroup">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPPatSetUpBedGroupDefaultData">
<Value name="1">
<Value>BPPBPCBedGroupDr</Value>
</Value>
<Value name="2">
<Value>BPPBPPatRegisterDr</Value>
</Value>
<Value name="3">
<Value>BPPUserDr</Value>
</Value>
<Value name="4">
<Value>BPPDate</Value>
</Value>
<Value name="5">
<Value>BPPTime</Value>
</Value>
<Value name="6">
<Value>BPPStatus</Value>
</Value>
<Value name="7">
<Value>BPPReceptionTime</Value>
</Value>
<Value name="8">
<Value>BPPDaySeqNo</Value>
</Value>
<Value name="9">
<Value>BPPBPCBedDr</Value>
</Value>
</Data>
<DataLocation>^DHCBPPatSetUpBedGroup</DataLocation>
<DefaultData>DHCBPPatSetUpBedGroupDefaultData</DefaultData>
<IdLocation>^DHCBPPatSetUpBedGroup</IdLocation>
<IndexLocation>^DHCBPPatSetUpBedGroup(0)</IndexLocation>
<StreamLocation>^User.DHCBPPatSetUpBedGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
