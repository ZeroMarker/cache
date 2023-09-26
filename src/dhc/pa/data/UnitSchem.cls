/// UnitSchem
Class dhc.pa.data.UnitSchem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UnitSchem_rowid, SqlTableName = UnitSchem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On UnitSchemchildSub [ IdKey, PrimaryKey, Unique ];

/// UnitSchem_parRef
Relationship UnitSchemparRef As dhc.pa.data.JXUnit [ Cardinality = parent, Inverse = ChildUnitSchem, Required, SqlFieldName = UnitSchem_parRef ];

/// UnitSchem_childSub
Property UnitSchemchildSub As %Library.Float [ InitialExpression = {$i(^DHCCJXPAJXUNIT($p(%d(0),$c(1),1),"UnitSchem",0))}, SqlColumnNumber = 2, SqlFieldName = UnitSchem_childSub ];

/// UnitSchem_schemDr
Property UnitSchemschemDr As dhc.pa.data.Schem [ SqlColumnNumber = 3, SqlFieldName = UnitSchem_schemDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="UnitSchem_schemDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCJXPAJXUNIT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>JXUnit.JXUnit_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>UnitSchem_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{JXUnit.JXUnit_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitSchem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitSchem_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSchem">
<Global>^DHCCJXPAJXUNIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>JXUnit.JXUnit_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>UnitSchem_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitSchemSchem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXUnit.JXUnit_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitSchem_schemDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitSchem_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.UnitSchemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
