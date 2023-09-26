Class User.DHCStkSysLibrary Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SSL_RowID, SqlTableName = DHC_StkSysLibrary, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SSL_Key
Property SSLKey As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SSL_Key ];

/// SSL_Name
Property SSLName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SSL_Name ];

/// SSL_SSP_Dr
Property SSLSSPDr As User.DHCStkSysPerview [ SqlColumnNumber = 4, SqlFieldName = SSL_SSP_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSSL)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SSL_Key">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SSL_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SSL_SSP_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSSL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SSL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SSL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexKeyPerview">
<Global>^DHCSSL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SSL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"KP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SSL_Key}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SSL_SSP_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SSL_Name}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SSL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkSysLibraryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSSL)
	s oldI = +$g(^mdata("DHCSTKSYSLIBRARY"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSSL = maxI
	s ^mdata("DHCSTKSYSLIBRARY") = maxI
}

}
