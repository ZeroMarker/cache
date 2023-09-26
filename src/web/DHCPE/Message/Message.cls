/// Created from: d:/fs.xsd
Class web.DHCPE.Message.Message Extends (%Persistent, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = persistent, Inheritance = right ]
{

Parameter XMLNAME = "Message";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 公用
Property SmsID As %String(MAXLEN = "", XMLNAME = "SmsID", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property Bid As %String(MAXLEN = "", XMLNAME = "Bid", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property Content As %String(MAXLEN = "", XMLNAME = "Content", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// 发送短信
Property RecvNum As %String(MAXLEN = "", XMLNAME = "RecvNum", XMLPROJECTION = "ATTRIBUTE");

Property SendLevel As %String(MAXLEN = "", XMLNAME = "SendLevel", XMLPROJECTION = "ATTRIBUTE");

/// 接受公用
Property SendNum As %String(MAXLEN = "", XMLNAME = "SendNum", XMLPROJECTION = "ATTRIBUTE");

/// 接受短信
Property RecvTime As %String(MAXLEN = "", XMLNAME = "RecvTime", XMLPROJECTION = "ATTRIBUTE");

/// 接受回执
Property Status As %String(MAXLEN = "", XMLNAME = "Status", XMLPROJECTION = "ATTRIBUTE");

Property ReportTime As %String(MAXLEN = "", XMLNAME = "ReportTime", XMLPROJECTION = "ATTRIBUTE");

Relationship SMS As web.DHCPE.Message.SMS(XMLNAME = "SMS", XMLPROJECTION = "NONE") [ Cardinality = one, Inverse = Message ];

Storage Default
{
<Data name="MessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Bid</Value>
</Value>
<Value name="3">
<Value>Content</Value>
</Value>
<Value name="4">
<Value>RecvNum</Value>
</Value>
<Value name="5">
<Value>SMS</Value>
</Value>
<Value name="6">
<Value>SendLevel</Value>
</Value>
<Value name="7">
<Value>SmsID</Value>
</Value>
<Value name="8">
<Value>RecvTime</Value>
</Value>
<Value name="9">
<Value>ReportTime</Value>
</Value>
<Value name="10">
<Value>SendNum</Value>
</Value>
<Value name="11">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.Message.MessageD</DataLocation>
<DefaultData>MessageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.Message.MessageD</IdLocation>
<IndexLocation>^web.DHCPE.Message.MessageI</IndexLocation>
<StreamLocation>^web.DHCPE.Message.MessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
