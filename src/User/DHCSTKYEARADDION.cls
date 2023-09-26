Class User.DHCSTKYEARADDION Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = STADD_ROWID, SqlTableName = DHC_STKYEARADDION, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// STADD_STKYR_DR
Property STADDSTKYRDR As User.DhcStkYearReport [ SqlColumnNumber = 2, SqlFieldName = STADD_STKYR_DR ];

/// STADD_INCLB_DR
Property STADDINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 3, SqlFieldName = STADD_INCLB_DR ];

/// STADD_QTY
Property STADDQTY As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = STADD_QTY ];

/// STADD_CTUOM_DR
Property STADDCTUOMDR As User.CTUOM [ SqlColumnNumber = 5, SqlFieldName = STADD_CTUOM_DR ];

/// STADD_EXECUTEDATA
Property STADDEXECUTEDATA As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = STADD_EXECUTEDATA ];

/// STADD_TYPE
Property STADDTYPE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = STADD_TYPE ];

/// STADD_REMARKS
Property STADDREMARKS As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = STADD_REMARKS ];

/// STADD_PRICE
Property STADDPRICE As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = STADD_PRICE ];

/// STADD_CTLOC_DR
Property STADDCTLOCDR As User.CTLoc [ SqlColumnNumber = 10, SqlFieldName = STADD_CTLOC_DR ];

/// STADD_AVAILQTY
Property STADDAVAILQTY As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = STADD_AVAILQTY ];

/// STADD_BILLNO
Property STADDBILLNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = STADD_BILLNO ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^STADDION)</SqlIdExpression>
<SQLMap name="IndexSTKAdd">
<Global>^STADDION</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>STADD_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"STADD"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{STADD_STKYR_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{STADD_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexstky">
<Global>^STADDION</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>STADD_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{STADD_EXECUTEDATA}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{STADD_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MASTERMAPSTADDION">
<Data name="STADD_AVAILQTY">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="STADD_BILLNO">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="STADD_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="STADD_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="STADD_EXECUTEDATA">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="STADD_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="STADD_PRICE">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="STADD_QTY">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="STADD_REMARKS">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="STADD_STKYR_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="STADD_TYPE">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^STADDION</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>STADD_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{STADD_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCSTKYEARADDIONS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^STADDION)
	s oldI = +$g(^mdata("DHCSTKYEARADDION"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^STADDION = maxI
	s ^mdata("DHCSTKYEARADDION") = maxI
}

}
