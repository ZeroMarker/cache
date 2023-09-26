Class dhc.ca.cache.data.AccPeriods Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AccPeriods_rowid, SqlTableName = AccPeriods, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On AccPeriodschildSub [ IdKey, PrimaryKey, Unique ];

/// AccountMonths Parent Reference
Relationship AccPeriodsparRef As dhc.ca.cache.data.AccountMonths [ Cardinality = parent, Inverse = ChildAccPeriods, Required, SqlFieldName = AccPeriods_parRef ];

/// AccPeriods_childSub
Property AccPeriodschildSub As %Library.Float [ InitialExpression = {$i(^DHCCAACCOUNTMONTHS($p(%d(0),$c(1),1),"Periods",0))}, SqlColumnNumber = 2, SqlFieldName = AccPeriods_childSub ];

/// AccPeriods_periodDr
Property AccPeriodsperiodDr As dhc.ca.cache.data.AccPeriod [ SqlColumnNumber = 3, SqlFieldName = AccPeriods_periodDr ];

/// AccPeriods_monthDr
Property AccPeriodsmonthDr As dhc.ca.cache.data.AccountMonths [ SqlColumnNumber = 4, SqlFieldName = AccPeriods_monthDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="AccPeriods_monthDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AccPeriods_periodDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCAACCOUNTMONTHS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AccountMonths.AccountMonths_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>AccPeriods_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AccountMonths.AccountMonths_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Periods"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AccPeriods_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPeriod">
<Global>^DHCCAACCOUNTMONTHS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>AccountMonths.AccountMonths_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>AccPeriods_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Period"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AccountMonths.AccountMonths_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AccPeriods_periodDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AccPeriods_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.AccPeriodsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
