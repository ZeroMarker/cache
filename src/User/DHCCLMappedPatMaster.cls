Class User.DHCCLMappedPatMaster Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLMPAPMI_RowId, SqlTableName = DHC_CL_MappedPatMaster, StorageStrategy = CacheStorage ]
{

Property CLMPAPMIPAPMIDr As %String [ SqlColumnNumber = 2, SqlFieldName = CLMPAPMI_PAPMI_Dr ];

Property CLMPAPMIMappedPatientNo As %String [ SqlColumnNumber = 3, SqlFieldName = CLMPAPMI_MappedPatientNo ];

Index Papmi On CLMPAPMIPAPMIDr As Exact;

Index MappedPapmi On CLMPAPMIMappedPatientNo As Exact;

Storage CacheStorage
{
<Data name="DHCCLMappedPatMasterClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLMappedPatMasterDefaultData">
<Value name="1">
<Value>CLMPAPMIPAPMIDr</Value>
</Value>
<Value name="2">
<Value>CLMPAPMIMappedPatientNo</Value>
</Value>
</Data>
<DataLocation>^DHCCLMappedPatMaster</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLMappedPatMaster</IdLocation>
<IndexLocation>^DHCCLMappedPatMaster(0)</IndexLocation>
<StreamLocation>^User.DHCCLMappedPatMasterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
