Class User.DHCAppTestCat Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = AC_RowID, SqlTableName = DHC_AppTestCat, StorageStrategy = SQLStorage ]
{

/// 分类代码  AC_Code
Property ACCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AC_Code ];

/// 分类描述  AC_Desc
Property ACDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AC_Desc ];

/// 集团化医院  AC_Hosp_Dr
Property ACHospDr As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = AC_Hosp_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPTC)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCAPPTC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AC_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCAPPTC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AC_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="AC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AC_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCAPPTC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppTestCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
