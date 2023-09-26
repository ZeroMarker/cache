Class User.DHCBPCRecordCat Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCRC_RowId, SqlTableName = DHC_BPC_RecordCat, StorageStrategy = CacheStorage ]
{

Property BPCRCCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCRC_Code ];

Property BPCRCDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCRC_Desc ];

Storage CacheStorage
{
<Data name="DHCBPCRecordCatClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCRecordCatDefaultData">
<Value name="1">
<Value>BPCRCCode</Value>
</Value>
<Value name="2">
<Value>BPCRCDesc</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("RecordCat")</DataLocation>
<DefaultData>DHCBPCRecordCatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("RecordCat")</IdLocation>
<IndexLocation>^DHCBPC("RecordCat",0)</IndexLocation>
<StreamLocation>^User.DHCBPCRecordCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
