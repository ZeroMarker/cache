/// Common Interface Log
Class User.DHCCILog Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock, SqlTableName = DHC_CILog ]
{

Index ReqDateIdx On CILRequestDate;

/// Receiver Message Status
Property CILReceiverMsgStatus As %String(DISPLAYLIST = ",None,Receive Success,Receive Failure", TRUNCATE = 1, VALUELIST = ",N,RS,RF") [ Required, SqlFieldName = CIL_ReceiverMsgStatus ];

/// Request Date
Property CILRequestDate As %Date [ Required, SqlFieldName = CIL_RequestDate ];

/// CIL
Property CILRequestXmlData As %String(MAXLEN = 99999, TRUNCATE = 1) [ SqlFieldName = CIL_RequestXmlData ];

/// Request Time
Property CILRequestTime As %Time [ Required, SqlFieldName = CIL_RequestTime ];

/// Response Date
Property CILResponseDate As %Date [ SqlFieldName = CIL_ResponseDate ];

/// Response Time
Property CILResponseTime As %Time [ SqlFieldName = CIL_ResponseTime ];

/// Response XmlData
Property CILResponseXmlData As %String(MAXLEN = 99999, TRUNCATE = 1) [ SqlFieldName = CIL_ResponseXmlData ];

/// Message Status
Property CILSendMsgStatus As %String(DISPLAYLIST = ",Send Success,Send Failure", TRUNCATE = 1, VALUELIST = ",SS,SF") [ Required, SqlFieldName = CIL_SendMsgStatus ];

Storage Default
{
<Data name="DHCCILogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CILRequestXmlData</Value>
</Value>
<Value name="3">
<Value>CILResponseXmlData</Value>
</Value>
<Value name="4">
<Value>CILRequestDate</Value>
</Value>
<Value name="5">
<Value>CILRequestTime</Value>
</Value>
<Value name="6">
<Value>CILResponseDate</Value>
</Value>
<Value name="7">
<Value>CILResponseTime</Value>
</Value>
<Value name="8">
<Value>CILSendMsgStatus</Value>
</Value>
<Value name="9">
<Value>CILReceiverMsgStatus</Value>
</Value>
</Data>
<DataLocation>^User.DHCCILogD</DataLocation>
<DefaultData>DHCCILogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCCILogD</IdLocation>
<IndexLocation>^User.DHCCILogI</IndexLocation>
<StreamLocation>^User.DHCCILogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
