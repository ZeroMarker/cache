Class dhc.pa.data.KpiScoreType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = KpiScoreType_Rowid, SqlTableName = KpiScoreType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// KpiScoreType_KpiDr
Property KpiScoreTypeKpiDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 2, SqlFieldName = KpiScoreType_KpiDr ];

/// KpiScoreType_DirectScore
Property KpiScoreTypeDirectScore As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = KpiScoreType_DirectScore ];

/// KpiScoreType_LevelScore
Property KpiScoreTypeLevelScore As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = KpiScoreType_LevelScore ];

/// KpiScoreType_Active
Property KpiScoreTypeActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = KpiScoreType_Active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAKPISCORETYPE(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="KpiScoreType_Active">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="KpiScoreType_DirectScore">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="KpiScoreType_KpiDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="KpiScoreType_LevelScore">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCJXPAKPISCORETYPE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>KpiScoreType_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{KpiScoreType_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexKpi">
<Global>^DHCCJXPAKPISCORETYPE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>KpiScoreType_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"KPI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KpiScoreType_KpiDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KpiScoreType_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.KpiScoreTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
