Class User.DHCBPCTemplate Extends %Persistent [ Language = java, Owner = {_SYSTEM}, SqlRowIdName = BPCT_RowId, SqlTableName = DHC_BPC_Template, StorageStrategy = CacheStorage ]
{

Index Code On BPCTCode As Exact;

Property BPCTCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCT_Code ];

Property BPCTDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCT_Desc ];

Property BPCTActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = BPCT_Active ];

Property BPCTBPCTCDr As User.DHCBPCTemplateCat [ SqlColumnNumber = 5, SqlFieldName = BPCT_BPCTC_Dr ];

Property BPCTData As %String(MAXLEN = 2000) [ SqlColumnNumber = 6, SqlFieldName = BPCT_Data ];

Storage CacheStorage
{
<Data name="BPTemplateClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="BPTemplateDefaultData">
<Value name="1">
<Value>BPCTCode</Value>
</Value>
<Value name="2">
<Value>BPCTDesc</Value>
</Value>
<Value name="3">
<Value>BPCTActive</Value>
</Value>
<Value name="4">
<Value>BPCTBPCTCDr</Value>
</Value>
<Value name="5">
<Value>BPCTData</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("Template")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<IdLocation>^DHCBPC("Template")</IdLocation>
<IndexLocation>^DHCBPC("Template",0)</IndexLocation>
<SqlRowIdName>BPCT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCBPCTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
