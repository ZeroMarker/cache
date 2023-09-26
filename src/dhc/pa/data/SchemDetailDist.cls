/// SchemdetailDist
Class dhc.pa.data.SchemDetailDist Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SchemDetailDist_rowid, SqlTableName = SchemDetailDist, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SchemDetailDistchildSub [ IdKey, PrimaryKey, Unique ];

/// SchemDetailDist_parRef
Relationship SchemDetailDistparRef As dhc.pa.data.SchemDetail [ Cardinality = parent, Inverse = ChildSchemDetailDist, Required, SqlFieldName = SchemDetailDist_parRef ];

/// SchemDetailDist_childSub
Property SchemDetailDistchildSub As %Library.Float [ InitialExpression = {$i(^DHCCJXPASTRATAGEM($p(%d(0),"||"),"Schem",$p(%d(0),"||",2),"SchemDetail",$p(%d(0),"||",3),"SchemDetailDist",0))}, SqlColumnNumber = 2, SqlFieldName = SchemDetailDist_childSub ];

/// SchemDetailDist_order
Property SchemDetailDistorder As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = SchemDetailDist_order ];

/// SchemDetailDist_valueLower
Property SchemDetailDistvalueLower As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = SchemDetailDist_valueLower ];

/// SchemDetailDist_valueUp
Property SchemDetailDistvalueUp As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = SchemDetailDist_valueUp ];

/// SchemDetailDist_scoreLower
Property SchemDetailDistscoreLower As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = SchemDetailDist_scoreLower ];

/// SchemDetailDist_scoreUp
Property SchemDetailDistscoreUp As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = SchemDetailDist_scoreUp ];

/// SchemDetailDist_rangeDr
Property SchemDetailDistrangeDr As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = SchemDetailDist_rangeDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="SchemDetailDist_order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SchemDetailDist_rangeDr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SchemDetailDist_scoreLower">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SchemDetailDist_scoreUp">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SchemDetailDist_valueLower">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SchemDetailDist_valueUp">
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
<Field>Schem.Schem_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>SchemDetail.SchemDetail_childSub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L5}</Expression>
<Field>SchemDetailDist_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SchemDetailDist"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Schem.Schem_childSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SchemDetail.SchemDetail_childSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SchemDetailDist_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSDDRanger">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>Schem.Schem_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>SchemDetail.SchemDetail_childSub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>SchemDetailDist_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SchemDetailDistRanger"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Schem.Schem_childSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SchemDetailDist_rangeDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SchemDetail.SchemDetail_childSub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SchemDetailDist_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSchemDetailDistOrder">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>Schem.Schem_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>SchemDetail.SchemDetail_childSub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>SchemDetailDist_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SchemDetailDistOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Schem.Schem_childSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SchemDetailDist_order}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SchemDetail.SchemDetail_childSub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SchemDetailDist_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.SchemDetailDistS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
