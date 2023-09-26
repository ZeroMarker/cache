Class User.DHCPENewSendMessage Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right, SqlTableName = DHC_PE_NewSendMessage ]
{

Parameter ClassName = "User.DHCPENewSendMessage";

/// 登记号
Property NSMRegNo As %String [ SqlFieldName = NSM_RegNo ];

/// 移动电话
Property NSMMobile As %String [ Required, SqlFieldName = NSM_Mobile ];

/// 短信内容
Property NSMContent As %String(MAXLEN = 500) [ SqlFieldName = NSM_Content ];

/// 业务系统类型
Property NSMType As %String [ SqlFieldName = NSM_Type ];

/// 短信状态 0待发送 1发送 2发送成功 3发送失败 4重发
Property NSMStatus As %String [ SqlFieldName = NSM_Status ];

/// 业务数据对应ID
Property NSMSourceID As %String [ SqlFieldName = NSM_SourceID ];

/// 期望发送日期
Property NSMExpectSendDate As %Library.Date [ SqlFieldName = NSM_ExpectSendDate ];

/// 创建人
Property NSMCreateUserDR As User.SSUser [ SqlFieldName = NSM_CreateUser_DR ];

/// 创建日期
Property NSMCreateDate As %Library.Date [ SqlFieldName = NSM_CreateDate ];

/// 创建时间
Property NSMCreateTime As %Library.Time [ SqlFieldName = NSM_CreateTime ];

/// 发送人
Property NSMSendUserDR As User.SSUser [ SqlFieldName = NSM_SendUser_DR ];

/// 发送日期
Property NSMSendDate As %Library.Date [ SqlFieldName = NSM_SendDate ];

/// 发送时间
Property NSMSendTime As %Library.Time [ SqlFieldName = NSM_SendTime ];

/// 关联ID，发送失败重新发送时
Property NSMRelateDR As User.DHCPENewSendMessage [ SqlFieldName = NSM_Relate_DR ];

/// 短信ID
Property NSMSmsID As %String [ SqlFieldName = NSM_SmsID ];

/// 接口登录名
Property NSMBid As %String [ SqlFieldName = NSM_Bid ];

Property NSMSendLevel As %Integer [ SqlFieldName = NSM_SendLevel ];

Property NSMName As %String [ SqlFieldName = NSM_Name ];

Property NSMSex As %String [ SqlFieldName = NSM_Sex ];

Property NSMReportDate As %Library.Date [ SqlFieldName = NSM_ReportDate ];

Property NSMReportTime As %Library.Time [ SqlFieldName = NSM_ReportTime ];

Property NSMUpdateUserDR As User.SSUser [ SqlFieldName = NSM_UpdateUser_DR ];

Property NSMUpdateDate As %Library.Date [ SqlFieldName = NSM_UpdateDate ];

Property NSMUpdateTime As %Library.Time [ SqlFieldName = NSM_UpdateTime ];

Property NSMLocDR As %Library.Time [ SqlFieldName = NSM_Loc_DR ];

Index DateTypeIndex On (NSMExpectSendDate, NSMType As AlphaUp, NSMStatus As AlphaUp);

Index SmsIDIndex On NSMSmsID As AlphaUp;

Index NSMRegNoIndex On NSMRegNo As AlphaUp;

Index TypeSourceIndex On (NSMType As AlphaUp, NSMSourceID As AlphaUp);

ClassMethod ReIndex()
{
	d ..%BuildIndices()
}

Storage Default
{
<Data name="DHCPENewSendMessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NSMContent</Value>
</Value>
<Value name="3">
<Value>NSMCreateDate</Value>
</Value>
<Value name="4">
<Value>NSMCreateTime</Value>
</Value>
<Value name="5">
<Value>NSMCreateUserDR</Value>
</Value>
<Value name="6">
<Value>NSMExpectSendDate</Value>
</Value>
<Value name="7">
<Value>NSMMobile</Value>
</Value>
<Value name="8">
<Value>NSMRegNo</Value>
</Value>
<Value name="9">
<Value>NSMRelateDR</Value>
</Value>
<Value name="10">
<Value>NSMSendDate</Value>
</Value>
<Value name="11">
<Value>NSMSendTime</Value>
</Value>
<Value name="12">
<Value>NSMSendUserDR</Value>
</Value>
<Value name="13">
<Value>NSMStatus</Value>
</Value>
<Value name="14">
<Value>NSMType</Value>
</Value>
<Value name="15">
<Value>NSMBid</Value>
</Value>
<Value name="16">
<Value>NSMSendLevel</Value>
</Value>
<Value name="17">
<Value>NSMSmsID</Value>
</Value>
<Value name="18">
<Value>NSMName</Value>
</Value>
<Value name="19">
<Value>NSMSex</Value>
</Value>
<Value name="20">
<Value>NSMReportDate</Value>
</Value>
<Value name="21">
<Value>NSMReportTime</Value>
</Value>
<Value name="22">
<Value>NSMUpdateDate</Value>
</Value>
<Value name="23">
<Value>NSMUpdateTime</Value>
</Value>
<Value name="24">
<Value>NSMUpdateUserDR</Value>
</Value>
<Value name="25">
<Value>NSMSourceID</Value>
</Value>
<Value name="26">
<Value>NSMLocDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCPENewSendMessageD</DataLocation>
<DefaultData>DHCPENewSendMessageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPENewSendMessageD</IdLocation>
<IndexLocation>^User.DHCPENewSendMessageI</IndexLocation>
<StreamLocation>^User.DHCPENewSendMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
