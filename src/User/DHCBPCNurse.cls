Class User.DHCBPCNurse Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCN_RowId, SqlTableName = DHC_BPC_Nurse, StorageStrategy = CacheStorage ]
{

Property BPCNBPCNurseGroupDr As User.DHCBPCNurseGroup [ SqlColumnNumber = 2, SqlFieldName = BPCN_BPCNurseGroup_Dr ];

Property BPCNNurseCTCPDr As %String [ SqlColumnNumber = 3, SqlFieldName = BPCN_NurseCTCP_Dr ];

Storage CacheStorage
{
<Data name="DHCBPCNurseClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCNurseDefaultData">
<Value name="1">
<Value>BPCNBPCNurseGroupDr</Value>
</Value>
<Value name="2">
<Value>BPCNNurseCTCPDr</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("Nurse")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("Nurse")</IdLocation>
<IndexLocation>^DHCBPC("Nurse")</IndexLocation>
<StreamLocation>^User.DHCBPCNurseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
