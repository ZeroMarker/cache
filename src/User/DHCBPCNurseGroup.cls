Class User.DHCBPCNurseGroup Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCNG_RowId, SqlTableName = DHC_BPC_NurseGroup, StorageStrategy = CacheStorage ]
{

Property BPCNGCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCNG_Code ];

Property BPCNGDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCNG_Desc ];

Property BPCNGWardDr As %String [ SqlColumnNumber = 4, SqlFieldName = BPCNG_Ward_Dr ];

Storage CacheStorage
{
<Data name="DHCBPCNurseGroupClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCNurseGroupDefaultData">
<Value name="1">
<Value>BPCNGCode</Value>
</Value>
<Value name="2">
<Value>BPCNGDesc</Value>
</Value>
<Value name="3">
<Value>BPCNGWardDr</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("NurseGroup")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("NurseGroup")</IdLocation>
<IndexLocation>^User.DHCBPCNurseGroupI</IndexLocation>
<SqlRowIdName>BPCNG_RowId</SqlRowIdName>
<StreamLocation>^User.DHCBPCNurseGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
