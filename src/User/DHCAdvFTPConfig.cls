Class User.DHCAdvFTPConfig Extends %Persistent [ SqlRowIdName = FTP_RowID, SqlTableName = DHC_AdvFTPConfig, StorageStrategy = SQLStorage ]
{

/// FTP代码  FTP_Code
Property FTPCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = FTP_Code ];

/// FTP描述  FTP_Desc
Property FTPDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = FTP_Desc ];

/// FTP地址  FTP_AddressIP
Property FTPAddressIP As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = FTP_AddressIP ];

/// 账号  FTP_UserName
Property FTPUserName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = FTP_UserName ];

/// 密码  FTP_PassWord
Property FTPPassWord As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = FTP_PassWord ];

/// 端口  FTP_Port
Property FTPPort As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = FTP_Port ];

///  医院 FTP_Hosp_Dr
Property FTPHospDr As User.CTHospital [ SqlColumnNumber = 8, SqlFieldName = FTP_Hosp_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVFTPC)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCADVFTPC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FTP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({FTP_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FTP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="FTP_AddressIP">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FTP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FTP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FTP_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="FTP_PassWord">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FTP_Port">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="FTP_UserName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCADVFTPC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>FTP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{FTP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvFTPConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
