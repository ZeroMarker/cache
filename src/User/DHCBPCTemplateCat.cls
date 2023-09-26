Class User.DHCBPCTemplateCat Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCTC_RowId, SqlTableName = DHC_BPC_TemplateCat, StorageStrategy = CacheStorage ]
{

Index Code On BPCTCCode As Exact;

Property BPCTCCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCTC_Code ];

Property BPCTCDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCTC_Desc ];

Property BPCTCActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = BPCTC_Active ];

Property BPCTCBPCTSCDr As User.DHCBPCTemplateSuperCat [ SqlColumnNumber = 5, SqlFieldName = BPCTC_BPCTSC_Dr ];

Storage CacheStorage
{
<Data name="BPCTemplateCatClassName">
<Subscript>0</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="BPCTemplateCatDefaultData">
<Value name="1">
<Value>BPCTCCode</Value>
</Value>
<Value name="2">
<Value>BPCTCDesc</Value>
</Value>
<Value name="3">
<Value>BPCTCActive</Value>
</Value>
<Value name="4">
<Value>BPCTCBPCTSCDr</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("TCat")</DataLocation>
<DefaultData>DHCBPCTemplateCatDefaultData</DefaultData>
<IdLocation>^DHCBPC("TCat")</IdLocation>
<IndexLocation>^DHCBPC("TCat",0)</IndexLocation>
<SqlRowIdName>BPCTC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCBPCTemplateCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
