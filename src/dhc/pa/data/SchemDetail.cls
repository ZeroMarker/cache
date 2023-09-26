/// SchemDetail
Class dhc.pa.data.SchemDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SchemDetail_rowid, SqlTableName = SchemDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SchemDetailchildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildSchemDetailAdd As dhc.pa.data.SchemDetailAdd [ Cardinality = children, Inverse = SchemDetailAddparRef ];

Relationship ChildSchemDetailDist As dhc.pa.data.SchemDetailDist [ Cardinality = children, Inverse = SchemDetailDistparRef ];

/// SchemDetail_parRef
Relationship SchemDetailparRef As dhc.pa.data.Schem [ Cardinality = parent, Inverse = ChildSchemDetail, Required, SqlFieldName = SchemDetail_parRef ];

/// SchemDetail_childSub
Property SchemDetailchildSub As %Library.Float [ InitialExpression = {$i(^DHCCJXPASTRATAGEM($p(%d(0),"||"),"Schem",$p(%d(0),"||",2),"SchemDetail",0))}, SqlColumnNumber = 2, SqlFieldName = SchemDetail_childSub ];

/// SchemDetail_order
Property SchemDetailorder As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = SchemDetail_order ];

/// SchemDetail_KPIDr
Property SchemDetailKPIDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 4, SqlFieldName = SchemDetail_KPIDr ];

/// SchemDetail_isTarget
Property SchemDetailisTarget As %Library.Float(SELECTIVITY = "33.3333%") [ SqlColumnNumber = 5, SqlFieldName = SchemDetail_isTarget ];

/// SchemDetail_rate
Property SchemDetailrate As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = SchemDetail_rate ];

/// SchemDetail_parent
Property SchemDetailparent As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = SchemDetail_parent ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="SchemDetail_KPIDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SchemDetail_isTarget">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SchemDetail_order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SchemDetail_parent">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SchemDetail_rate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
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
<Field>SchemDetail_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SchemDetail"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Schem.Schem_childSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SchemDetail_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexIsTarget">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>Schem.Schem_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>SchemDetail_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SchemDetailTarget"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SchemDetail_isTarget}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SchemDetail_KPIDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{Schem.Schem_childSub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SchemDetail_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParent">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>Schem.Schem_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>SchemDetail_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SchemDetailParent"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SchemDetail_parent}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Schem.Schem_childSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SchemDetail_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSchemDetailOrder">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>Schem.Schem_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>SchemDetail_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SchemDetailOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SchemDetail_order}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Schem.Schem_childSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SchemDetail_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.SchemDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
