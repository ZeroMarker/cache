/// 体检电子签名日志
Class User.DHCPECASignLog Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_PE_CASignLog ]
{

/// 签名是否成功
Property SLIsValid As %String [ SqlFieldName = SL_IsValid ];

/// 指向CA.DigitalSignature
Property SLSignID As CA.DigitalSignature [ SqlFieldName = SL_SignID ];

/// 签名错误信息
Property SLErrInfo As %String [ SqlFieldName = SL_ErrInfo ];

/// 由USBKEY提供的方法产生的Hash
Property SLContentHash As %String(MAXLEN = 9999) [ SqlFieldName = SL_ContentHash ];

/// 电子签名对应的业务数据类型
Property SLSignType As %String [ SqlFieldName = SL_SignType ];

/// 电子签名对应的业务数据ID
Property SLSourceID As %String [ SqlFieldName = SL_SourceID ];

/// CertCode
Property SLCertCode As %String(MAXLEN = 9999) [ SqlFieldName = SL_CertCode ];

/// Cert
Property SLCert As %String(MAXLEN = 9999) [ SqlFieldName = SL_Cert ];

/// 签名值
Property SLSignedData As %String(MAXLEN = 9999) [ SqlFieldName = SL_SignedData ];

/// 数值签名userid
Property SLUserID As User.SSUser [ SqlFieldName = SL_UserID ];

/// 签名日志日期
Property SLDate As %Date [ SqlFieldName = SL_Date ];

/// 签名日志时间
Property SLTime As %Time [ SqlFieldName = SL_Time ];

Index TypeSourceIndex On (SLSignType, SLSourceID);

Storage Default
{
<Data name="DHCPECASignLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SLSignID</Value>
</Value>
<Value name="3">
<Value>SLErrInfo</Value>
</Value>
<Value name="4">
<Value>SLContentHash</Value>
</Value>
<Value name="5">
<Value>SLSignType</Value>
</Value>
<Value name="6">
<Value>SLSourceID</Value>
</Value>
<Value name="7">
<Value>SLCertCode</Value>
</Value>
<Value name="8">
<Value>SLCert</Value>
</Value>
<Value name="9">
<Value>SLSignedData</Value>
</Value>
<Value name="10">
<Value>SLUserID</Value>
</Value>
<Value name="11">
<Value>SLDate</Value>
</Value>
<Value name="12">
<Value>SLTime</Value>
</Value>
<Value name="13">
<Value>SLIsValid</Value>
</Value>
</Data>
<DataLocation>^User.DHCPECASignLogD</DataLocation>
<DefaultData>DHCPECASignLogDefaultData</DefaultData>
<IdLocation>^User.DHCPECASignLogD</IdLocation>
<IndexLocation>^User.DHCPECASignLogI</IndexLocation>
<StreamLocation>^User.DHCPECASignLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
