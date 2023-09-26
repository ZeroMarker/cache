/// UnitResult
Class dhc.pa.data.UnitResult Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UnitResult_rowid, SqlTableName = UnitResult, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On UnitResultchildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildUnitResultDetail As dhc.pa.data.UnitResultDetail [ Cardinality = children, Inverse = UnitResultDetailparRef ];

/// UnitResult_parRef
Relationship UnitResultparRef As dhc.pa.data.Stratagem [ Cardinality = parent, Inverse = ChildUnitResult, Required, SqlFieldName = UnitResult_parRef ];

/// UnitResult_childSub
Property UnitResultchildSub As %Library.Float [ InitialExpression = {$i(^DHCCJXPASTRATAGEM($p(%d(0),$c(1),1),"UnitResult",0))}, SqlColumnNumber = 2, SqlFieldName = UnitResult_childSub ];

/// UnitResult_schemDr
Property UnitResultschemDr As dhc.pa.data.Schem [ SqlColumnNumber = 3, SqlFieldName = UnitResult_schemDr ];

/// UnitResult_appSysDr
Property UnitResultappSysDr As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = UnitResult_appSysDr ];

/// UnitResult_jxUnitDr
Property UnitResultjxUnitDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 5, SqlFieldName = UnitResult_jxUnitDr ];

/// UnitResult_period
Property UnitResultperiod As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = UnitResult_period ];

/// UnitResult_auditDr
Property UnitResultauditDr As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = UnitResult_auditDr ];

/// UnitResult_auditDate
Property UnitResultauditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = UnitResult_auditDate ];

/// UnitResult_auditState
Property UnitResultauditState As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = UnitResult_auditState ];

/// 计算总分
Property UnitResulttotalScore As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = UnitResult_totalScore ];

/// 最终总分
Property UnitResultRScore As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = UnitResult_RScore ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="UnitResult_RScore">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UnitResult_appSysDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UnitResult_auditDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UnitResult_auditDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UnitResult_auditState">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="UnitResult_jxUnitDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UnitResult_period">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UnitResult_schemDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UnitResult_totalScore">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCCJXPASTRATAGEM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>UnitResult_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitResult"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitResult_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPeriod">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>UnitResult_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Period"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitResult_period}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitResult_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPeriodUnitSchemApp">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>UnitResult_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PUSA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitResult_period}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitResult_jxUnitDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UnitResult_schemDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{UnitResult_appSysDr}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{UnitResult_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnitResultAppSys">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>UnitResult_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitResultAppSys"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitResult_appSysDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitResult_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnitResultJXUnit">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>UnitResult_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitResultJXUnit"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitResult_jxUnitDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitResult_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnitResultSchem">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>UnitResult_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitResultSchem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitResult_schemDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitResult_jxUnitDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UnitResult_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnitResultUserDate">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>UnitResult_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitResultUserDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitResult_auditDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitResult_auditDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UnitResult_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.UnitResultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
