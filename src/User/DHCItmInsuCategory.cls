Class User.DHCItmInsuCategory Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IC_RowId, SqlTableName = DHC_ItmInsuCategory, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IC_Code
Property ICCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ Required, SqlColumnNumber = 2, SqlFieldName = IC_Code ];

/// IC_Desc
Property ICDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ Required, SqlColumnNumber = 3, SqlFieldName = IC_Desc ];

/// IC_SelfPayRate
Property ICSelfPayRate As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = IC_SelfPayRate ];

/// IC_DateFrom
Property ICDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = IC_DateFrom ];

/// IC_DateTo
Property ICDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = IC_DateTo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCITMIC)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IC_SelfPayRate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCITMIC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCITMIC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({IC_Desc})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexcode">
<Global>^DHCITMIC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({IC_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCItmInsuCategoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCITMIC)
	s oldI = +$g(^mdata("DHCITMINSUCATEGORY"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCITMIC = maxI
	s ^mdata("DHCITMINSUCATEGORY") = maxI
}

}
