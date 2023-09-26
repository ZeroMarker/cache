Class User.DHCMDTSignVerify Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SoapBodyUse = encoded, SqlRowIdName = MS_RowID, SqlTableName = DHC_MDTSignVerify, StorageStrategy = NewStorage1 ]
{

/// 签名是否成功
Property MSIsValid As %String [ SqlFieldName = MS_IsValid ];

/// 指向CA.DigitalSignature
Property MSSignID As CA.DigitalSignature [ SqlFieldName = MS_SignID ];

/// 签名错误信息
Property MSErrInfo As %String [ SqlFieldName = MS_ErrInfo ];

/// 由USBKEY提供的方法产生的Hash
Property MSContentHash As %String(MAXLEN = 9999) [ SqlFieldName = MS_ContentHash ];

/// 电子签名对应的业务数据类型
Property MSSignType As %String [ SqlFieldName = MS_SignType ];

/// 电子签名对应的业务数据ID
Property MSSourceID As %String [ SqlFieldName = MS_SourceID ];

/// CertCode
Property MSCertCode As %String [ SqlFieldName = MS_CertCode ];

/// Cert
Property MSCert As %String [ SqlFieldName = MS_Cert ];

/// 签名值
Property MSSignedData As %String(MAXLEN = 9999) [ SqlFieldName = MS_SignedData ];

/// 数值签名userid
Property MSUserID As User.SSUser [ SqlFieldName = MS_UserID ];

/// 签名日志日期
Property MSDate As %Date [ SqlFieldName = MS_Date ];

/// 签名日志时间
Property MSTime As %Time [ SqlFieldName = MS_Time ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCMDTSV)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MS_Cert">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MS_CertCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MS_ContentHash">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MS_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MS_ErrInfo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MS_IsValid">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MS_SignID">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MS_SignType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MS_SignedData">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MS_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MS_Time">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MS_UserID">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCMDTSV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="SourceIndex">
<Global>^DHCMDTSV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SorType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MS_SignType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MS_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMDTSignVerifyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
