/// SchemDetailAdd
Class dhc.pa.data.SchemDetailAdd Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SchemDetailAdd_rowid, SqlTableName = SchemDetailAdd, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SchemDetailAddchildSub [ IdKey, PrimaryKey, Unique ];

/// SchemDetailAdd_parRef
Relationship SchemDetailAddparRef As dhc.pa.data.SchemDetail [ Cardinality = parent, Inverse = ChildSchemDetailAdd, Required, SqlFieldName = SchemDetailAdd_parRef ];

/// SchemDetailAdd_childSub
Property SchemDetailAddchildSub As %Library.Float [ InitialExpression = {$i(^DHCCJXPASTRATAGEM($p(%d(0),"||"),"Schem",$p(%d(0),"||",2),"SchemDetail",$p(%d(0),"||",3),"SchemDetailAdd",0))}, SqlColumnNumber = 2, SqlFieldName = SchemDetailAdd_childSub ];

/// SchemDetailAdd_flag
Property SchemDetailAddflag As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SchemDetailAdd_flag ];

/// SchemDetailAdd_changeValue
Property SchemDetailAddchangeValue As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = SchemDetailAdd_changeValue ];

/// SchemDetailAdd_score
Property SchemDetailAddscore As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = SchemDetailAdd_score ];

/// SchemDetailAdd_baseValue
Property SchemDetailAddbaseValue As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = SchemDetailAdd_baseValue ];

/// SchemDetailAdd_baseValue
Property SchemDetailAddbase As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = SchemDetailAdd_base ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="SchemDetailAdd_base">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SchemDetailAdd_baseValue">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SchemDetailAdd_changeValue">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SchemDetailAdd_flag">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SchemDetailAdd_score">
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
<Field>SchemDetailAdd_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SchemDetailAdd"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Schem.Schem_childSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SchemDetail.SchemDetail_childSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SchemDetailAdd_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSchemDetailAddFlag">
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
<Field>SchemDetailAdd_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SchemDetailAddFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Schem.Schem_childSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SchemDetailAdd_flag}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SchemDetail.SchemDetail_childSub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SchemDetailAdd_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.SchemDetailAddS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
