Class dhc.pa.data.KPIPro Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = KPIPro_rowid, SqlTableName = KPIPro, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// KPIPro_kpiDr
Property KPIProkpiDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 2, SqlFieldName = KPIPro_kpiDr ];

/// KPIPro_pro
Property KPIPropro As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = KPIPro_pro ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAKPIPRO(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="KPIPro_kpiDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="KPIPro_pro">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCJXPAKPIPRO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>KPIPro_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{KPIPro_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexKpi">
<Global>^DHCCJXPAKPIPRO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>KPIPro_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"KPI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KPIPro_kpiDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KPIPro_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.KPIProS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
