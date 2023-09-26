/// KpiRule
Class dhc.pa.inter.KpiRule Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = KpiRule_rowid, SqlTableName = KpiRule, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// KpiRule_KPIDr
Property KpiRuleKPIDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 2, SqlFieldName = KpiRule_KPIDr ];

/// KpiRule_sysSetDr
Property KpiRulesysSetDr As dhc.pa.inter.InterSysSet [ SqlColumnNumber = 3, SqlFieldName = KpiRule_sysSetDr ];

/// KpiRule_active
Property KpiRuleactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = KpiRule_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAKPIRULE(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="KpiRule_KPIDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="KpiRule_active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="KpiRule_sysSetDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCJXPAKPIRULE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>KpiRule_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{KpiRule_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCJXPAKPIRULE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>KpiRule_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KpiRule_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KpiRule_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSysSetKPI">
<Global>^DHCCJXPAKPIRULE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>KpiRule_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SysSetKPI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KpiRule_sysSetDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KpiRule_KPIDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KpiRule_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.inter.KpiRuleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
