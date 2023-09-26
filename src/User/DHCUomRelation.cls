Class User.DHCUomRelation Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UOMREL_RowID, SqlTableName = DHC_UomRelation, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property UOMRELUOMDR As User.CTUOM [ SqlColumnNumber = 2, SqlFieldName = UOMREL_UOM_DR ];

Property UOMRELNCSCODE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = UOMREL_NCSCODE ];

Property UOMRELNCSDESC As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = UOMREL_NCSDESC ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCUOMREL)</SqlIdExpression>
<SQLMap name="DATAMASTER">
<Data name="UOMREL_NCSCODE">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UOMREL_NCSDESC">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UOMREL_UOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCUOMREL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UOMREL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{UOMREL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexUom">
<Global>^DHCUOMREL</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UOM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UOMREL_UOM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UOMREL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCUomRelationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCUOMREL)
	s oldI = +$g(^mdata("DHCUOMREL"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCUOMREL = maxI
	s ^mdata("DHCUOMREL") = maxI
}

}
