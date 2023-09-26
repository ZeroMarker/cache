/// URDetailAdd
Class dhc.pa.data.URDetailAdd Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = URDetailAdd_rowid, SqlTableName = URDetailAdd, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On URDetailAddchildSub [ IdKey, PrimaryKey, Unique ];

/// URDetailAdd_parRef
Relationship URDetailAddparRef As dhc.pa.data.UnitResultDetail [ Cardinality = parent, Inverse = ChildURDetailAdd, Required, SqlFieldName = URDetailAdd_parRef ];

/// URDetailAdd_childSub
Property URDetailAddchildSub As %Library.Float [ InitialExpression = {$i(^DHCCJXPASTRATAGEM($p(%d(0),"||"),"UnitResult",$p(%d(0),"||",2),"URDetail",$p(%d(0),"||",3),"URDetailAdd",0))}, SqlColumnNumber = 2, SqlFieldName = URDetailAdd_childSub ];

/// URDetailAdd_flag
Property URDetailAddflag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = URDetailAdd_flag ];

/// URDetailAdd_changeValue
Property URDetailAddchangeValue As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = URDetailAdd_changeValue ];

/// URDetailAdd_score
Property URDetailAddscore As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = URDetailAdd_score ];

/// URDetailAdd_baseValue
Property URDetailAddbaseValue As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = URDetailAdd_baseValue ];

/// URDetailAdd_base
Property URDetailAddbase As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = URDetailAdd_base ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="URDetailAdd_base">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="URDetailAdd_baseValue">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="URDetailAdd_changeValue">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="URDetailAdd_flag">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="URDetailAdd_score">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCJXPASTRATAGEM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>UnitResult.UnitResult_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>UnitResultDetail.UnitResultDetail_childSub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L5}</Expression>
<Field>URDetailAdd_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitResultDetailAdd"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitResult.UnitResult_childSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitResultDetail.UnitResultDetail_childSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{URDetailAdd_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRepRecord">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>UnitResult.UnitResult_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>UnitResultDetail.UnitResultDetail_childSub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>URDetailAdd_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"URDA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitResult.UnitResult_childSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitResultDetail.UnitResultDetail_childSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{URDetailAdd_flag}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{URDetailAdd_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.URDetailAddS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
