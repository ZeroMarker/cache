Class User.DHCBPCBloodPurificationMode Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCBPM_RowId, SqlTableName = DHC_BPC_BloodPurificationMode, StorageStrategy = CacheStorage ]
{

Property BPCBPMCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCBPM_Code ];

Property BPCBPMDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCBPM_Desc ];

/// 是否为特殊净化
Property BPCBPMIsSpecial As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = BPCBPM_IsSpecial ];

/// 科室
Property BPCBPMLocationDr As %String [ SqlColumnNumber = 5, SqlFieldName = BPCBPM_Location_Dr ];

Storage CacheStorage
{
<Data name="DHCBPCBPModeClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCBPModeDefaultData">
<Value name="1">
<Value>BPCBPMCode</Value>
</Value>
<Value name="2">
<Value>BPCBPMDesc</Value>
</Value>
<Value name="3">
<Value>BPCBPMIsSpecial</Value>
</Value>
<Value name="4">
<Value>BPCBPMLocationDr</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("BloodPurificationMode")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("BloodPurificationMode")</IdLocation>
<IndexLocation>^DHCBPC("BloodPurificationMode")</IndexLocation>
<StreamLocation>^User.DHCBPCBloodPA06S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
