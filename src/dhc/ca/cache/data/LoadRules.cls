Class dhc.ca.cache.data.LoadRules Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LoadRules_rowid, SqlTableName = LoadRules, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// LoadRules_order
Property LoadRulesorder As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = LoadRules_order ];

/// LoadRules_code
Property LoadRulescode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = LoadRules_code ];

/// LoadRules_name
Property LoadRulesname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = LoadRules_name ];

/// LoadRules_deptSetDr
Property LoadRulesdeptSetDr As dhc.ca.cache.data.InDeptSets [ SqlColumnNumber = 5, SqlFieldName = LoadRules_deptSetDr ];

/// LoadRules_itemSetDr
Property LoadRulesitemSetDr As dhc.ca.cache.data.InItemSets [ SqlColumnNumber = 6, SqlFieldName = LoadRules_itemSetDr ];

/// LoadRules_itemTypeDr
Property LoadRulesitemTypeDr As dhc.ca.cache.data.DataItemTypes [ SqlColumnNumber = 7, SqlFieldName = LoadRules_itemTypeDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCALOADRULES(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="LoadRules_code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LoadRules_deptSetDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LoadRules_itemSetDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LoadRules_itemTypeDr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LoadRules_name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LoadRules_order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCALOADRULES</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LoadRules_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{LoadRules_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCALOADRULES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LoadRules_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LoadRules_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LoadRules_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCALOADRULES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LoadRules_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LoadRules_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LoadRules_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrder">
<Global>^DHCCALOADRULES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LoadRules_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Order"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LoadRules_order}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LoadRules_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.LoadRulesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
