/// InterLoc
Class dhc.pa.inter.InterLoc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InterLoc_rowid, SqlTableName = InterLoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// InterLoc_jxUnitDr
Property InterLocjxUnitDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 2, SqlFieldName = InterLoc_jxUnitDr ];

/// InterLoc_order
Property InterLocorder As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = InterLoc_order ];

/// InterLoc_code
Property InterLoccode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = InterLoc_code ];

/// InterLoc_name
Property InterLocname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = InterLoc_name ];

/// InterLoc_inLocSetDr
Property InterLocinLocSetDr As dhc.pa.inter.InterLocSet [ SqlColumnNumber = 6, SqlFieldName = InterLoc_inLocSetDr ];

/// InterLoc_remark
Property InterLocremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = InterLoc_remark ];

/// InterLoc_active
Property InterLocactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = InterLoc_active ];

/// InterLoc_patType
Property InterLocpatType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = InterLoc_patType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAINTERLOC(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="InterLoc_active">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="InterLoc_code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="InterLoc_inLocSetDr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="InterLoc_jxUnitDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="InterLoc_name">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="InterLoc_order">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="InterLoc_patType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="InterLoc_remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCCJXPAINTERLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InterLoc_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InterLoc_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCJXPAINTERLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InterLoc_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterLoc_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterLoc_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexJICode">
<Global>^DHCCJXPAINTERLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>InterLoc_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"JICode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterLoc_jxUnitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterLoc_inLocSetDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InterLoc_code}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{InterLoc_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexJILocSet">
<Global>^DHCCJXPAINTERLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>InterLoc_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"JILocSet"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterLoc_jxUnitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterLoc_inLocSetDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InterLoc_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocSetLoc">
<Global>^DHCCJXPAINTERLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>InterLoc_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocSetLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterLoc_inLocSetDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterLoc_code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InterLoc_jxUnitDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{InterLoc_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.inter.InterLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
