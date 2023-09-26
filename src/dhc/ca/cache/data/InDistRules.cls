Class dhc.ca.cache.data.InDistRules Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InDistRules_rowid, SqlTableName = InDistRules, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildInDeptTypeRules As dhc.ca.cache.data.InDeptTypeRules [ Cardinality = children, Inverse = InDeptTypeRulesparRef ];

Relationship ChildInDeptRules As dhc.ca.cache.data.InDeptRules [ Cardinality = children, Inverse = InDeptRulesparRef ];

/// InDistRules_code
Property InDistRulescode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = InDistRules_code ];

/// InDistRules_name
Property InDistRulesname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = InDistRules_name ];

/// InDistRules_shortcut
Property InDistRulesshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = InDistRules_shortcut ];

/// InDistRules_flag
Property InDistRulesflag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = InDistRules_flag ];

/// InDistRules_active
Property InDistRulesactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = InDistRules_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAINDISTRULE(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="InDistRules_active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="InDistRules_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="InDistRules_flag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="InDistRules_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="InDistRules_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCAINDISTRULE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InDistRules_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InDistRules_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCAINDISTRULE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InDistRules_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDistRules_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDistRules_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCAINDISTRULE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InDistRules_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDistRules_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDistRules_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCAINDISTRULE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InDistRules_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDistRules_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDistRules_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortcut">
<Global>^DHCCAINDISTRULE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InDistRules_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shortcut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDistRules_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDistRules_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.InDistRulesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
