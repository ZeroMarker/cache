/// SubJxUnit
Class dhc.pa.data.SubJxUnit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SubJxUnit_rowid, SqlTableName = SubJxUnit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SubJxUnit_jxUnitSetDr
Property SubJxUnitjxUnitSetDr As dhc.pa.data.jxUnitSet [ SqlColumnNumber = 2, SqlFieldName = SubJxUnit_jxUnitSetDr ];

/// SubJxUnit_jxUnitDr
Property SubJxUnitjxUnitDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 3, SqlFieldName = SubJxUnit_jxUnitDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPASUBJXUNIT(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="SubJxUnit_jxUnitDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SubJxUnit_jxUnitSetDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCJXPASUBJXUNIT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SubJxUnit_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SubJxUnit_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexJxUnitSet">
<Global>^DHCCJXPASUBJXUNIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SubJxUnit_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"JxUnitSet"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SubJxUnit_jxUnitSetDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SubJxUnit_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.SubJxUnitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
