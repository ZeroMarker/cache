Class User.DHCBPBedScheme Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPBS_RowId, SqlTableName = DHC_BP_BedScheme, StorageStrategy = CacheStorage ]
{

Index BedWeek On (BPBSBPBedDr As Exact, BPBSWeeKSeqNo As Exact);

/// 第一血液净化方式指针
Property BPSBPCBPModeDr As User.DHCBPCBloodPurificationMode [ SqlColumnNumber = 13, SqlFieldName = BPS_BPCBPMode_Dr ];

/// 第二血液净化方式指针
Property BPSSecondBPCBPModeDr As User.DHCBPCBloodPurificationMode [ SqlColumnNumber = 14, SqlFieldName = BPS_SecondBPCBPMode_Dr ];

Property BPBSBPBedDr As User.DHCBPCBed [ SqlColumnNumber = 2, SqlFieldName = BPBS_BPBed_Dr ];

Property BPBSBPPatRegisterDr As User.DHCBPPatRegister [ SqlColumnNumber = 3, SqlFieldName = BPBS_BPPatRegister_Dr ];

Property BPBSWeeKSeqNo As %Integer [ SqlColumnNumber = 4, SqlFieldName = BPBS_WeeKSeqNo ];

Property BPBSDaySeqNo As %String(DISPLAYLIST = ",AM,PM,Evening", MAXLEN = 7, SELECTIVITY = "25%", VALUELIST = ",A,P,E") [ SqlColumnNumber = 5, SqlFieldName = BPBS_DaySeqNo ];

Storage CacheStorage
{
<Data name="DHCBPBedSchemeClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPBedSchemeDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>BPSBPCBPModeDr</Value>
</Value>
<Value name="2">
<Value>BPSSecondBPCBPModeDr</Value>
</Value>
</Data>
<Data name="DHCBPBedSchemeDefaultName">
<Value name="1">
<Value>BPBSBPBedDr</Value>
</Value>
<Value name="2">
<Value>BPBSBPPatRegisterDr</Value>
</Value>
<Value name="3">
<Value>BPBSWeeKSeqNo</Value>
</Value>
<Value name="4">
<Value>BPBSDaySeqNo</Value>
</Value>
</Data>
<DataLocation>^DHCBPBedScheme</DataLocation>
<DefaultData>DHCBPBedSchemeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPBedScheme</IdLocation>
<IndexLocation>^DHCBPBedScheme(0)</IndexLocation>
<StreamLocation>^User.DHCBPBedSchemeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
