Class web.DHCPE.Message.SMS Extends (%Persistent, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = persistent, Inheritance = right ]
{

Parameter XMLNAME = "SMS";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Relationship Message As web.DHCPE.Message.Message(XMLNAME = "Message", XMLPROJECTION = "ELEMENT") [ Cardinality = many, Inverse = SMS ];

Property type As %String(MAXLEN = "", XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Storage Default
{
<Data name="SMSDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>type</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.Message.SMSD</DataLocation>
<DefaultData>SMSDefaultData</DefaultData>
<IdLocation>^web.DHCPE.Message.SMSD</IdLocation>
<IndexLocation>^web.DHCPE.Message.SMSI</IndexLocation>
<StreamLocation>^web.DHCPE.Message.SMSS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
