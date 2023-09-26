Class User.DHCBPCTreatmentSuperCat Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCTSC_RowId, SqlTableName = DHC_BPC_TreatmentSuperCat, StorageStrategy = CacheStorage ]
{

Index Code On BPCTSCCode As Exact;

Property BPCTSCCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCTSC_Code ];

Property BPCTSCDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCTSC_Desc ];

Property BPCTSCActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = BPCTSC_Active ];

Property BPCTSCCtlocDr As %String [ SqlColumnNumber = 5, SqlFieldName = BPCTSC_Ctloc_Dr ];

Storage CacheStorage
{
<Data name="BPCTreatmentSuperCatClassName">
<Attribute>%%CLASSNAME</Attribute>
<Subscript>0</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="BPCTreatmentSuperCatDefaultData">
<Attribute>%%CLASSNAME</Attribute>
<Value name="1">
<Value>BPCTSCCode</Value>
</Value>
<Value name="2">
<Value>BPCTSCDesc</Value>
</Value>
<Value name="3">
<Value>BPCTSCActive</Value>
</Value>
<Value name="4">
<Value>BPCTSCCtlocDr</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("TreatmentSuperCat")</DataLocation>
<DefaultData>BPCTreatmentSuperCatDefaultData</DefaultData>
<IdLocation>^DHCBPC("TreatmentSuperCat")</IdLocation>
<IndexLocation>^DHCBPC("TreatmentSuperCat",0)</IndexLocation>
<SqlRowIdName>BPCTSC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCBPCTreatmentSuperCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
