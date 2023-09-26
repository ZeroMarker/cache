/// Adjust
Class dhc.pa.data.Adjust Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Adjust_rowid, SqlTableName = Adjust, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On AdjustchildSub [ IdKey, PrimaryKey, Unique ];

/// Adjust_parRef
Relationship AdjustparRef As dhc.pa.data.Stratagem [ Cardinality = parent, Inverse = ChildAdjust, Required, SqlFieldName = Adjust_parRef ];

/// Adjust_userDr
Property AdjustuserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = Adjust_userDr ];

/// Adjust_date
Property Adjustdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = Adjust_date ];

/// Adjust_info
Property Adjustinfo As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Adjust_info ];

/// Adjust_childSub
Property AdjustchildSub As %Library.Float [ InitialExpression = {$i(^DHCCJXPASTRATAGEM($p(%d(0),$c(1),1),"Adjust",0))}, SqlColumnNumber = 2, SqlFieldName = Adjust_childSub ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="Adjust_date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Adjust_info">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Adjust_userDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCJXPASTRATAGEM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>Adjust_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adjust"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Adjust_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>Adjust_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdjustUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Adjust_userDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Adjust_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.AdjustS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
