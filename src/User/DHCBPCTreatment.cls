Class User.DHCBPCTreatment Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCT_RowId, SqlTableName = DHC_BPC_Treatment, StorageStrategy = CacheStorage ]
{

Property BPCTCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCT_Code ];

Property BPCTDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCT_Desc ];

Property BPCTSymptom As %String(MAXLEN = 200) [ SqlColumnNumber = 4, SqlFieldName = BPCT_Symptom ];

Property BPCTTreatment As %String(MAXLEN = 200) [ SqlColumnNumber = 5, SqlFieldName = BPCT_Treatment ];

Property BPCTBPTCatDr As %String [ SqlColumnNumber = 6, SqlFieldName = BPCT_BPTCat_Dr ];

Storage CacheStorage
{
<Data name="DHCBPCTreatmentClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCTreatmentDefaultData">
<Value name="1">
<Value>BPCTCode</Value>
</Value>
<Value name="2">
<Value>BPCTDesc</Value>
</Value>
<Value name="3">
<Value>BPCTSymptom</Value>
</Value>
<Value name="4">
<Value>BPCTTreatment</Value>
</Value>
<Value name="5">
<Value>BPCTBPTCatDr</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("Treatment")</DataLocation>
<IdLocation>^DHCBPC("Treatment")</IdLocation>
<IndexLocation>^DHCBPC("Treatment",0)</IndexLocation>
<StreamLocation>^User.DHCBPCTreatmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
