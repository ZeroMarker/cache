Class User.DHCCLMappedPaAdm Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLMPAADM_RowId, SqlTableName = DHC_CL_MappedPaAdm, StorageStrategy = CacheStorage ]
{

Property CLMPAADMAdmDr As %String [ SqlColumnNumber = 2, SqlFieldName = CLMPAADM_Adm_Dr ];

Property CLMPAADMMappedAdmNo As %String [ SqlColumnNumber = 3, SqlFieldName = CLMPAADM_MappedAdmNo ];

Index Adm On CLMPAADMAdmDr As Exact;

Index MappedAdm On CLMPAADMMappedAdmNo As Exact;

Storage CacheStorage
{
<Data name="DHCCLMappedPaAdmClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLMappedPaAdmDefaultData">
<Value name="1">
<Value>CLMPAADMAdmDr</Value>
</Value>
<Value name="2">
<Value>CLMPAADMMappedAdmNo</Value>
</Value>
</Data>
<DataLocation>^DHCCLMappedPaAdm</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLMappedPaAdm</IdLocation>
<IndexLocation>^DHCCLMappedPaAdm(0)</IndexLocation>
<StreamLocation>^User.DHCCLMappedPaAdmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
