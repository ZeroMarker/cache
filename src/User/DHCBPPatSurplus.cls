Class User.DHCBPPatSurplus Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPPS_RowId, SqlTableName = DHC_BP_PatSurplus, StorageStrategy = CacheStorage ]
{

Property BPPSPatRegisterDr As User.DHCBPPatRegister [ SqlColumnNumber = 2, SqlFieldName = BPPS_PatRegisterDr ];

Property BPPSPatMasDr As %String [ SqlColumnNumber = 3, SqlFieldName = BPPS_PatMasDr ];

Property BPPSDateMonth As %String [ SqlColumnNumber = 4, SqlFieldName = BPPS_DateMonth ];

Property BPPSArcimDr As %String [ SqlColumnNumber = 5, SqlFieldName = BPPS_ArcimDr ];

Property BPPSTotalSurplus As %String [ SqlColumnNumber = 6, SqlFieldName = BPPS_TotalSurplus ];

Index RegisterDr On BPPSPatRegisterDr As Exact;

Storage CacheStorage
{
<Data name="DHCBPPatSurplusClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPPatSurplusDefaultData">
<Value name="1">
<Value>BPPSPatRegisterDr</Value>
</Value>
<Value name="2">
<Value>BPPSPatMasDr</Value>
</Value>
<Value name="3">
<Value>BPPSDateMonth</Value>
</Value>
<Value name="4">
<Value>BPPSArcimDr</Value>
</Value>
<Value name="5">
<Value>BPPSTotalSurplus</Value>
</Value>
</Data>
<DataLocation>^DHCBPPatSurplus</DataLocation>
<DefaultData>DHCBPPatSurplusDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPPatSurplus</IdLocation>
<IndexLocation>^DHCBPPatSurplus(0)</IndexLocation>
<StreamLocation>^User.DHCBPPatSurplusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
