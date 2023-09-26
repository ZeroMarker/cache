/// InterKPI
Class dhc.bonus.inter.InterKPI Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InterKPI_rowid, SqlTableName = InterKPI, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// InterKPI_kpiDr
Property InterKPIkpiDr As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 2, SqlFieldName = InterKPI_kpiDr ];

/// InterKPI_okrDr
Property InterKPIokrDr As dhc.bonus.inter.OutKpiRule [ SqlColumnNumber = 3, SqlFieldName = InterKPI_okrDr ];

/// InterKPI_remark
Property InterKPIremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = InterKPI_remark ];

/// InterKPI_active
Property InterKPIactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = InterKPI_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAINTERKPI(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="InterKPI_active">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="InterKPI_kpiDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="InterKPI_okrDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="InterKPI_remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^dhcbsInterKPI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InterKPI_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InterKPI_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^dhcbsInterKPI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InterKPI_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterKPI_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterKPI_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIKKPI">
<Global>^dhcbsInterKPI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InterKPI_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IKKPI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterKPI_kpiDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterKPI_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIKKPIOKR">
<Global>^dhcbsInterKPI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>InterKPI_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IKKPICode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterKPI_kpiDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterKPI_okrDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InterKPI_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexokpi">
<Global>^dhcbsInterKPI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>InterKPI_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutKPI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterKPI_okrDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterKPI_kpiDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InterKPI_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.bonus.inter.InterKPIS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
