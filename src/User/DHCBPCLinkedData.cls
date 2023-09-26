Class User.DHCBPCLinkedData Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_BPC_LinkedData, StorageStrategy = CacheStorage ]
{

Property BPCLDSourceCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCLD_SourceCode ];

Property BPCLDLinkedCode As %String [ SqlColumnNumber = 3, SqlFieldName = BPCLD_LinkedCode ];

Property BPCLDSourceOption As %String [ SqlColumnNumber = 4, SqlFieldName = BPCLD_SourceOption ];

Property BPCLDLinkedOption As %String [ SqlColumnNumber = 5, SqlFieldName = BPCLD_LinkedOption ];

Property BPCLDIsVisible As %Boolean [ SqlColumnNumber = 6, SqlFieldName = BPCLD_IsVisible ];

Index SourceCode On BPCLDSourceCode As Exact;

Index LinkedCode On BPCLDLinkedCode As Exact;

Storage CacheStorage
{
<Data name="DHCBPCLindedDataClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCLinkedDataDefaultData">
<Value name="1">
<Value>BPCLDSourceCode</Value>
</Value>
<Value name="2">
<Value>BPCLDLinkedCode</Value>
</Value>
<Value name="3">
<Value>BPCLDSourceOption</Value>
</Value>
<Value name="4">
<Value>BPCLDLinkedOption</Value>
</Value>
<Value name="5">
<Value>BPCLDIsVisible</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("LinkedData")</DataLocation>
<DefaultData>DHCBPCLinkedDataDefaultData</DefaultData>
<IdLocation>^DHCBPC("LinkedData")</IdLocation>
<IndexLocation>^DHCBPC("LinkedData",0)</IndexLocation>
<StreamLocation>^User.DHCBPCLinkedDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
