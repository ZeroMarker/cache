Class User.DHCBPCInquiryCode Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_BPC_InquiryCode, StorageStrategy = CacheStorage ]
{

Property BPCICCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCIC_Code ];

Property BPCICDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCIC_Desc ];

Property BPCICType As %String(DISPLAYLIST = ",Patient,Baseline,ICD,Docter,Order,Record,Lab,EMR", MAXLEN = 8, SELECTIVITY = "11.1111%", TRUNCATE = 1, VALUELIST = ",P,B,I,D,O,R,L,E") [ SqlColumnNumber = 4, SqlFieldName = BPCIC_Type ];

Property BPCICCtlocDr As %String [ SqlColumnNumber = 5, SqlFieldName = BPCIC_Ctloc_Dr ];

Property BPCICOption As %String(MAXLEN = 500) [ SqlColumnNumber = 6, SqlFieldName = BPCIC_Option ];

Index Type On BPCICType As Exact;

Storage CacheStorage
{
<Data name="DHCBPCInquiryCodeClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCInquiryCodeDefaultData">
<Value name="1">
<Value>BPCICCode</Value>
</Value>
<Value name="2">
<Value>BPCICDesc</Value>
</Value>
<Value name="3">
<Value>BPCICType</Value>
</Value>
<Value name="4">
<Value>BPCICCtlocDr</Value>
</Value>
<Value name="5">
<Value>BPCICOption</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("InquiryCode")</DataLocation>
<DefaultData>DHCBPCInquiryCodeDefaultData</DefaultData>
<IdLocation>^DHCBPC("InquiryCode")</IdLocation>
<IndexLocation>^DHCBPC("InquiryCode",0)</IndexLocation>
<StreamLocation>^User.DHCBPCInquiryCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
