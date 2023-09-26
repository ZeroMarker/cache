Class User.DHCCLCLabTestCode Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLCLTC_RowId, SqlTableName = DHC_CLC_LabTestCode, StorageStrategy = CacheStorage ]
{

Property CLCLTCCode As %String [ SqlColumnNumber = 2, SqlFieldName = CLCLTC_Code ];

Property CLCLTCDesc As %String [ SqlColumnNumber = 3, SqlFieldName = CLCLTC_Desc ];

Property CLCLTCAbbrev As %String [ SqlColumnNumber = 4, SqlFieldName = CLCLTC_Abbrev ];

Property CLCLTCStandardCode As %String [ SqlColumnNumber = 5, SqlFieldName = CLCLTC_StandardCode ];

Storage CacheStorage
{
<Data name="DHCCLCLabTestCodeClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLCLabTestCodeDefaultData">
<Value name="1">
<Value>CLCLTCCode</Value>
</Value>
<Value name="2">
<Value>CLCLTCDesc</Value>
</Value>
<Value name="3">
<Value>CLCLTCAbbrev</Value>
</Value>
<Value name="4">
<Value>CLCLTCStandardCode</Value>
</Value>
</Data>
<DataLocation>^DHCCLC("LabTestCode")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLC("LabTestCode")</IdLocation>
<IndexLocation>^DHCCLC("LabTestCode",0)</IndexLocation>
<StreamLocation>^User.DHCCLCLabTestCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
