Class User.DHCConTrackStorage Extends (%Persistent, User.Abstract) [ SqlRowIdName = COPIC_RowId, SqlTableName = DHC_ConTrackStorage, StorageStrategy = SQLStorage ]
{

Property COPICCONDR As User.DHCConTrack [ SqlColumnNumber = 2, SqlFieldName = COPIC_ConT_DR ];

Property COPICNAME As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = COPIC_NAME ];

Property COPICTYPE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = COPIC_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSTMCONTPIC)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="COPIC_ConT_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="COPIC_NAME">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="COPIC_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSTMCONTPIC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>COPIC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{COPIC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexConPicName">
<Global>^DHCSTMCONTPIC</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>COPIC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{COPIC_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{COPIC_NAME}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{COPIC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexContPIc">
<Global>^DHCSTMCONTPIC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>COPIC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>{COPIC_ConT_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{COPIC_NAME}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{COPIC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexCOPIC">
<Global>^DHCSTMCONTPIC</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>COPIC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{COPIC_ConT_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{COPIC_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{COPIC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>COPIC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCConTrackStorageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSTMCONTPIC)
	s oldI = +$g(^mdata("DHCSTMCONTPIC"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSTMCONTPIC = maxI
	s ^mdata("DHCSTMCONTPIC") = maxI
}

Parameter EXTENTSIZE = 250;

}
