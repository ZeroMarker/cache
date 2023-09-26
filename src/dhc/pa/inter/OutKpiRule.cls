/// OutKpiRule
Class dhc.pa.inter.OutKpiRule Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OutKpiRule_rowid, SqlTableName = OutKpiRule, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OutKpiRule_outKpiCode
Property OutKpiRuleoutKpiCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = OutKpiRule_outKpiCode ];

/// OutKpiRule_outKpiName
Property OutKpiRuleoutKpiName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = OutKpiRule_outKpiName ];

/// OutKpiRule_inLocSetDr
Property OutKpiRuleinLocSetDr As dhc.pa.inter.InterLocSet [ SqlColumnNumber = 4, SqlFieldName = OutKpiRule_inLocSetDr ];

/// OutKpiRule_active
Property OutKpiRuleactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = OutKpiRule_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAOUTKPIRULE(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="OutKpiRule_active">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OutKpiRule_inLocSetDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OutKpiRule_outKpiCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OutKpiRule_outKpiName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCJXPAOUTKPIRULE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OutKpiRule_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OutKpiRule_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCJXPAOUTKPIRULE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OutKpiRule_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OutKpiRule_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OutKpiRule_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocSetKPI">
<Global>^DHCCJXPAOUTKPIRULE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OutKpiRule_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocSetKPI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OutKpiRule_inLocSetDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OutKpiRule_outKpiCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OutKpiRule_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutKpiCode">
<Global>^DHCCJXPAOUTKPIRULE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OutKpiRule_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutKpiCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OutKpiRule_outKpiCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OutKpiRule_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutKpiName">
<Global>^DHCCJXPAOUTKPIRULE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OutKpiRule_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutKpiName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OutKpiRule_outKpiName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OutKpiRule_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.inter.OutKpiRuleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
