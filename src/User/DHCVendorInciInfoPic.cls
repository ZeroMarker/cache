Class User.DHCVendorInciInfoPic Extends (%Persistent, User.Abstract) [ SqlRowIdName = VenIncPic_RowId, SqlTableName = DHC_VendorInciInfoPic, StorageStrategy = SQLStorage ]
{

Property VenIncPicVenIncDr As User.DHCVendorInciInfo [ SqlColumnNumber = 2, SqlFieldName = VenIncPic_VenInc_Dr ];

Property VenIncPicPicUrl As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = VenIncPic_PicUrl ];

Property VenIncPicSCIPicUrl As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = VenIncPic_SCIPicUrl ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVendorInciInFoPic)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VenIncPic_PicUrl">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VenIncPic_SCIPicUrl">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VenIncPic_VenInc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCVendorInciInFoPic</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VenIncPic_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{VenIncPic_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexParref">
<Global>^DHCVendorInciInFoPic</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VenIncPic_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"parref"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{VenIncPic_VenInc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{VenIncPic_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSCIPicUrl">
<Global>^DHCVendorInciInFoPic</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VenIncPic_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"SCIPicUrl"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{VenIncPic_SCIPicUrl}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{VenIncPic_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>VenIncPic_RowId</SqlRowIdName>
<StreamLocation>^User.DHCVendorInciInfoPicS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCVendorInciInFoPic)
	s oldI = +$g(^mdata("DHCVendorInciInFoPic"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCVendorInciInFoPic = maxI
	s ^mdata("DHCVendorInciInFoPic") = maxI
}

Parameter EXTENTSIZE = 250;

}
