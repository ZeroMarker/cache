Class User.DHCSTBookCat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BC_RowID, SqlTableName = DHCST_BookCat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BC_Code
Property BCCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = BC_Code ];

/// BC_Desc
Property BCDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BC_Desc ];

/// BC_Remarks
Property BCRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BC_Remarks ];

/// BC_UseFlag
Property BCUseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = BC_UseFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSTBC)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BC_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BC_UseFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCSTBC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{BC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCSTBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({BC_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCSTBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DESC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({BC_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCSTBookCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSTBC)
	s oldI = +$g(^mdata("DHCSTBOOKCAT"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSTBC = maxI
	s ^mdata("DHCSTBOOKCAT") = maxI
}

}
