Class User.DHCCLMappedOEOrdExec Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLMOEORE_RowId, SqlTableName = DHC_CL_MappedOEOrdExec, StorageStrategy = CacheStorage ]
{

Property CLMOEOREOEOrdExecDr As %String [ SqlColumnNumber = 2, SqlFieldName = CLMOEORE_OEOrdExec_Dr ];

Property CLMOEOREMappedOeoreNo As %String [ SqlColumnNumber = 3, SqlFieldName = CLMOEORE_MappedOeoreNo ];

Index OEORE On CLMOEOREOEOrdExecDr As Exact;

Index MappedOEORE On CLMOEOREMappedOeoreNo As Exact;

Storage CacheStorage
{
<Data name="MappedOEOrdExecClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="MappedOEOrdExecDefaultData">
<Value name="1">
<Value>CLMOEOREOEOrdExecDr</Value>
</Value>
<Value name="2">
<Value>CLMOEOREMappedOeoreNo</Value>
</Value>
</Data>
<DataLocation>^DHCCLMappedOEOrdExec</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLMappedOEOrdExec</IdLocation>
<IndexLocation>^DHCCLMappedOEOrdExec(0)</IndexLocation>
<SqlRowIdName>CLMOEORE_RowId</SqlRowIdName>
<StreamLocation>^User.DHCCLMappedOEOrdExecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
