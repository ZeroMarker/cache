Class User.DHCPENewRecvMessage Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right, SqlTableName = DHC_PE_NewRecvMessage ]
{

Parameter ClassName = "User.DHCPENewRecvMessage";

/// 短信ID
Property NRMSmsID As %String [ SqlFieldName = NRM_SmsID ];

/// 发送号码
Property NRMSendNum As %String [ SqlFieldName = NRM_SendNum ];

/// 接收号码
Property NRMBid As %String [ SqlFieldName = NRM_Bid ];

/// 短信内容
Property NRMContent As %String(MAXLEN = 500) [ SqlFieldName = NRM_Content ];

/// 业务类型
Property NRMType As %String [ SqlFieldName = NRM_Type ];

/// xml中返回日期
Property NRMSendDate As %Library.Date [ SqlFieldName = NRM_SendDate ];

/// xml中返回时间
Property NRMSendTime As %Library.Time [ SqlFieldName = NRM_SendTime ];

/// 接受短信人
Property NRMRecvUserDR As User.SSUser [ SqlFieldName = NRM_RecvUser_DR ];

/// 接受日期
Property NRMRecvDate As %Library.Date [ SqlFieldName = NRM_RecvDate ];

/// 接受时间
Property NRMRecvTime As %Library.Time [ SqlFieldName = NRM_RecvTime ];

Storage Default
{
<Data name="DHCPENewRecvMessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NRMBid</Value>
</Value>
<Value name="3">
<Value>NRMContent</Value>
</Value>
<Value name="4">
<Value>NRMRecvDate</Value>
</Value>
<Value name="5">
<Value>NRMRecvTime</Value>
</Value>
<Value name="6">
<Value>NRMRecvUserDR</Value>
</Value>
<Value name="7">
<Value>NRMSendNum</Value>
</Value>
<Value name="8">
<Value>NRMSmsID</Value>
</Value>
<Value name="9">
<Value>NRMSendDate</Value>
</Value>
<Value name="10">
<Value>NRMSendTime</Value>
</Value>
<Value name="11">
<Value>NRMType</Value>
</Value>
</Data>
<DataLocation>^User.DHCPENewRecvMessageD</DataLocation>
<DefaultData>DHCPENewRecvMessageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPENewRecvMessageD</IdLocation>
<IndexLocation>^User.DHCPENewRecvMessageI</IndexLocation>
<StreamLocation>^User.DHCPENewRecvMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
