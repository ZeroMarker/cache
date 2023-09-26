Class User.DHCCLCMappingCode Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLCMC_RowId, SqlTableName = DHC_CLC_MappingCode, StorageStrategy = CacheStorage ]
{

Property CLCMCCLCMSDr As User.DHCCLCMappingService [ SqlColumnNumber = 2, SqlFieldName = CLCMC_CLCMS_Dr ];

Property CLCMCCodeDr As %String [ SqlColumnNumber = 3, SqlFieldName = CLCMC_Code_Dr ];

Property CLCMCCode As %String [ SqlColumnNumber = 4, SqlFieldName = CLCMC_Code ];

Property CLCMCDesc As %String [ SqlColumnNumber = 5, SqlFieldName = CLCMC_Desc ];

Property CLCMCMappedCode As %String [ SqlColumnNumber = 6, SqlFieldName = CLCMC_MappedCode ];

Property CLCMCMappedDesc As %String [ SqlColumnNumber = 7, SqlFieldName = CLCMC_MappedDesc ];

Property CLCMCDate As %Date [ SqlColumnNumber = 8, SqlFieldName = CLCMC_Date ];

Property CLCMCTime As %Time [ SqlColumnNumber = 9, SqlFieldName = CLCMC_Time ];

Property CLCMCUpdateDate As %Date [ SqlColumnNumber = 10, SqlFieldName = CLCMC_UpdateDate ];

Property CLCMCUpdateTime As %Time [ SqlColumnNumber = 11, SqlFieldName = CLCMC_UpdateTime ];

Index CodeDr On (CLCMCCLCMSDr As Exact, CLCMCCodeDr As Exact);

Index Code On (CLCMCCLCMSDr As Exact, CLCMCCode As Exact);

Index MappedCode On (CLCMCCLCMSDr As Exact, CLCMCMappedCode As Exact);

Storage CacheStorage
{
<Data name="DHCCLCMappingCodeClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLCMappingCodeDefaultData">
<Value name="1">
<Value>CLCMCCLCMSDr</Value>
</Value>
<Value name="2">
<Value>CLCMCCodeDr</Value>
</Value>
<Value name="3">
<Value>CLCMCCode</Value>
</Value>
<Value name="4">
<Value>CLCMCDesc</Value>
</Value>
<Value name="5">
<Value>CLCMCMappedCode</Value>
</Value>
<Value name="6">
<Value>CLCMCMappedDesc</Value>
</Value>
<Value name="7">
<Value>CLCMCDate</Value>
</Value>
<Value name="8">
<Value>CLCMCTime</Value>
</Value>
<Value name="9">
<Value>CLCMCUpdateDate</Value>
</Value>
<Value name="10">
<Value>CLCMCUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCCLC("MappingCode")</DataLocation>
<DefaultData>DHCCLCMappingCodeDefaultData1</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLC("MappingCode")</IdLocation>
<IndexLocation>^DHCCLC("MappingCode",0)</IndexLocation>
<StreamLocation>^User.DHCCLCMappingCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
