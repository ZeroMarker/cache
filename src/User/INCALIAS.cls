Class User.INCALIAS Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INCA_ROWID, SqlTableName = INC_ALIAS, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INCA_INCI_DR
Property INCAINCIDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = INCA_INCI_DR ];

/// INCA_CODE
Property INCACODE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INCA_CODE ];

/// INCA_DESC
Property INCADESC As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INCA_DESC ];

/// INCA_TEXT
Property INCATEXT As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INCA_TEXT ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^INCALIAS)</SqlIdExpression>
<SQLMap name="INDEXALIAS">
<Global>^INCALIAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INCA_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({INCA_Text})</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({INCA_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INCA_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXINCAINCIDR">
<Global>^INCALIAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCA_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCA_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCA_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXTEXT">
<Global>^INCALIAS</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Text"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({INCA_Text})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCA_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MASTERINCALIAS">
<Data name="INCA_CODE">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INCA_DESC">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INCA_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INCA_TEXT">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^INCALIAS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INCA_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INCA_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.INCALIASS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^INCALIAS)
	s oldI = +$g(^mdata("INCALIAS"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^INCALIAS = maxI
	s ^mdata("INCALIAS") = maxI
}

}
