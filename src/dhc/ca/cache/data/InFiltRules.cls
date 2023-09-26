Class dhc.ca.cache.data.InFiltRules Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InFiltRules_rowid, SqlTableName = InFiltRules, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildInFiltItems As dhc.ca.cache.data.InFiltItems [ Cardinality = children, Inverse = InFiltItemsparRef ];

Relationship ChildInFiltfDepts As dhc.ca.cache.data.InFiltfDepts [ Cardinality = children, Inverse = InFiltfDeptsparRef ];

Relationship ChildInFilttDepts As dhc.ca.cache.data.InFilttDepts [ Cardinality = children, Inverse = InFilttDeptsparRef ];

Relationship ChildInFiltPatDepts As dhc.ca.cache.data.InFiltPatDepts [ Cardinality = children, Inverse = InFiltPatDeptsparRef ];

/// InFiltRules_code
Property InFiltRulescode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = InFiltRules_code ];

/// InFiltRules_name
Property InFiltRulesname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = InFiltRules_name ];

/// InFiltRules_shortcut
Property InFiltRulesshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = InFiltRules_shortcut ];

/// InFiltRules_itemDr
Property InFiltRulesitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 5, SqlFieldName = InFiltRules_itemDr ];

/// InFiltRules_active
Property InFiltRulesactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = InFiltRules_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAINFILTRULE(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="InFiltRules_active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="InFiltRules_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="InFiltRules_itemDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="InFiltRules_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="InFiltRules_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCAINFILTRULE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InFiltRules_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InFiltRules_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCAINFILTRULE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InFiltRules_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InFiltRules_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InFiltRules_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCAINFILTRULE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InFiltRules_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InFiltRules_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InFiltRules_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCAINFILTRULE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InFiltRules_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InFiltRules_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InFiltRules_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortcut">
<Global>^DHCCAINFILTRULE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InFiltRules_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shortcut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InFiltRules_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InFiltRules_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.InFiltRulesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
