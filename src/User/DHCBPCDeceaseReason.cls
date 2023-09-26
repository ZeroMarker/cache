Class User.DHCBPCDeceaseReason Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCDR_RowId, SqlTableName = DHC_BPC_DeceaseReason, StorageStrategy = CacheStorage ]
{

Property BPCDRCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCDR_Code ];

Property BPCDRDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCDR_Desc ];

Storage CacheStorage
{
<Data name="DHCBPCDeceaseReasonClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCDeceaseReasonDefaultData">
<Attribute>%%CLASSNAME</Attribute>
<Value name="1">
<Value>BPCDRCode</Value>
</Value>
<Value name="2">
<Value>BPCDRDesc</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("DeceaseReason")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("DeceaseReason")</IdLocation>
<IndexLocation>^DHCBPC("DeceaseReason")</IndexLocation>
<StreamLocation>^User.DHCBPCDeceaseReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
