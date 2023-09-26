Class User.DHCItmTrackDetailAddion Extends (%Persistent, User.Abstract) [ SqlRowIdName = DHCITDA_RowId, SqlTableName = DHC_ItmTrackDetail_Addion, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property DHCITDADHCITDDR As User.DHCItmTrackDetail [ SqlColumnNumber = 2, SqlFieldName = DHCITDA_DHCITD_DR ];

Property DHCITDAPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCITDA_Pointer ];

Property DHCITDAType As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DHCITDA_Type ];

Property DHCITDADate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = DHCITDA_Date ];

Property DHCITDATime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = DHCITDA_Time ];

Property DHCITDASSUSRDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = DHCITDA_SSUSR_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCITD("IA"))</SqlIdExpression>
<SQLMap name="IndexDHCITD">
<Global>^DHCITD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCITDA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"DHCITD"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCITDA_DHCITD_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCITDA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypePointer">
<Global>^DHCITD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCITDA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IATypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCITDA_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCITDA_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCITDA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DHCITDA_DHCITD_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCITDA_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCITDA_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCITDA_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCITDA_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCITDA_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCITD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHCITDA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"IA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCITDA_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DHCITDA_RowId</SqlRowIdName>
<StreamLocation>^User.DHCItmTrackDetailAddionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCITD("IA"))
	s oldI = +$g(^mdata("DHCITMTRACKDETAILADDION"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCITD("IA") = maxI
	s ^mdata("DHCITMTRACKDETAILADDION") = maxI
}

}
