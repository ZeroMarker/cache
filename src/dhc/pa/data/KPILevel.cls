Class dhc.pa.data.KPILevel Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = KPILevel_rowid, SqlTableName = KPILevel, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// KPILvel_KPIDr
Property KPILvelKPIDr As dhc.pa.data.KpiScoreType [ SqlColumnNumber = 2, SqlFieldName = KPILvel_KPIDr ];

/// KPILevel_LevelDr
Property KPILevelLevelDr As dhc.pa.data.ScoreLevel [ SqlColumnNumber = 3, SqlFieldName = KPILevel_LevelDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAKPILEVEL)</SqlIdExpression>
<SQLMap name="Master">
<Data name="KPILevel_LevelDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="KPILvel_KPIDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCJXPAKPILEVEL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>KPILevel_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{KPILevel_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexKPILevel">
<Global>^DHCCJXPAKPILEVEL</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>KPILevel_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"KPILevel"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KPILvel_KPIDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KPILevel_LevelDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KPILevel_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.KPILevelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
