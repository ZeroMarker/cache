Class User.DHCICUCInquiryHeaderGroup Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_ICUC_InquiryHeaderGroup, StorageStrategy = CacheStorage ]
{

Property ICUCIHGCode As %String [ SqlColumnNumber = 2, SqlFieldName = ICUCIHG_Code ];

Property ICUCIHGDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ICUCIHG_Desc ];

Index Code On ICUCIHGCode As Exact;

Storage CacheStorage
{
<Data name="DHCICUCInquiryHeaderGroupClass">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCICUCInquiryHeaderGroupData">
<Value name="1">
<Value>ICUCIHGCode</Value>
</Value>
<Value name="2">
<Value>ICUCIHGDesc</Value>
</Value>
</Data>
<DataLocation>^DHCICUC("InquiryHeaderGroup")</DataLocation>
<IdLocation>^DHCICUC("InquiryHeaderGroup")</IdLocation>
<IndexLocation>^DHCICUC("InquiryHeaderGroup",0)</IndexLocation>
<StreamLocation>^User.DHCICUCInquA099S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
