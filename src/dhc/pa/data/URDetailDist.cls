/// URDetailDist
Class dhc.pa.data.URDetailDist Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = URDetailDist_rowid, SqlTableName = URDetailDist, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On URDetailDistchildSub [ IdKey, PrimaryKey, Unique ];

/// URDetailDist_parRef
Relationship URDetailDistparRef As dhc.pa.data.UnitResultDetail [ Cardinality = parent, Inverse = ChildURDetailDist, Required, SqlFieldName = URDetailDist_parRef ];

/// URDetailDist_childSub
Property URDetailDistchildSub As %Library.Float [ InitialExpression = {$i(^DHCCJXPASTRATAGEM($p(%d(0),"||"),"UnitResult",$p(%d(0),"||",2),"URDetail",$p(%d(0),"||",3),"URDetailDist",0))}, SqlColumnNumber = 2, SqlFieldName = URDetailDist_childSub ];

/// URDetailDist_order
Property URDetailDistorder As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = URDetailDist_order ];

/// URDetailDist_valueLower
Property URDetailDistvalueLower As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = URDetailDist_valueLower ];

/// URDetailDist_valueUp
Property URDetailDistvalueUp As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = URDetailDist_valueUp ];

/// URDetailDist_scoreLower
Property URDetailDistscoreLower As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = URDetailDist_scoreLower ];

/// URDetailDist_scoreUp
Property URDetailDistscoreUp As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = URDetailDist_scoreUp ];

/// URDetailDist_rangeDr
Property URDetailDistrangeDr As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = URDetailDist_rangeDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="URDetailDist_order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="URDetailDist_rangeDr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="URDetailDist_scoreLower">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="URDetailDist_scoreUp">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="URDetailDist_valueLower">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="URDetailDist_valueUp">
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
<Field>URDetailDist_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitResultDetailDist"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitResult.UnitResult_childSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitResultDetail.UnitResultDetail_childSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{URDetailDist_childSub}</Expression>
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
<Field>URDetailDist_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"URDD"</Expression>
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
<Expression>{URDetailDist_rangeDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{URDetailDist_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexURDetailDistOrder">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>UnitResult.UnitResult_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>UnitResultDetail.UnitResultDetail_childSub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>URDetailDist_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitResultDetailDistOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{URDetailDist_order}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitResult.UnitResult_childSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UnitResultDetail.UnitResultDetail_childSub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{URDetailDist_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.URDetailDistS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
