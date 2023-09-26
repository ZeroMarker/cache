Class User.DHCICUCInquiryCode Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_ICUC_InquiryCode, StorageStrategy = CacheStorage ]
{

Property ICUCICCode As %String [ SqlColumnNumber = 2, SqlFieldName = ICUCIC_Code ];

Property ICUCICDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ICUCIC_Desc ];

Property ICUCICType As %String(DISPLAYLIST = ",Patient,Baseline,ICD,Docter,Order,Record,Lab,EMR", MAXLEN = 8, SELECTIVITY = "11.1111%", TRUNCATE = 1, VALUELIST = ",P,B,I,D,O,R,L,E") [ SqlColumnNumber = 4, SqlFieldName = ICUCIC_Type ];

Property ICUCICCtlocDr As %String [ SqlColumnNumber = 5, SqlFieldName = ICUCIC_Ctloc_Dr ];

Property ICUCICOption As %String(MAXLEN = 500) [ SqlColumnNumber = 6, SqlFieldName = ICUCIC_Option ];

Index Type On ICUCICType As Exact;

Storage CacheStorage
{
<Data name="DHCICUCInquiryCodeClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCICUCInquiryCodeDefaultData">
<Value name="1">
<Value>ICUCICCode</Value>
</Value>
<Value name="2">
<Value>ICUCICDesc</Value>
</Value>
<Value name="3">
<Value>ICUCICType</Value>
</Value>
<Value name="4">
<Value>ICUCICCtlocDr</Value>
</Value>
<Value name="5">
<Value>ICUCICOption</Value>
</Value>
</Data>
<DataLocation>^DHCICUC("InquiryCode")</DataLocation>
<DefaultData>DHCICUCInquiryCodeDefaultData1</DefaultData>
<IdLocation>^DHCICUC("InquiryCode")</IdLocation>
<IndexLocation>^DHCICUC("InquiryCode",0)</IndexLocation>
<StreamLocation>^User.DHCICUCInquiryCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
