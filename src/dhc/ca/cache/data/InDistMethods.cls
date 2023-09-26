Class dhc.ca.cache.data.InDistMethods Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InDistMethods_rowid, SqlTableName = InDistMethods, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// InDistMethods_priority
Property InDistMethodspriority As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = InDistMethods_priority ];

/// InDistMethods_inFiltRuleDr
Property InDistMethodsinFiltRuleDr As dhc.ca.cache.data.InFiltRules [ SqlColumnNumber = 3, SqlFieldName = InDistMethods_inFiltRuleDr ];

/// InDistMethods_inDistRuleDr
Property InDistMethodsinDistRuleDr As dhc.ca.cache.data.InDistRules [ SqlColumnNumber = 4, SqlFieldName = InDistMethods_inDistRuleDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAINDISTMETHODS(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="InDistMethods_inDistRuleDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="InDistMethods_inFiltRuleDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="InDistMethods_priority">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCAINDISTMETHODS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InDistMethods_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InDistMethods_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFD">
<Global>^DHCCAINDISTMETHODS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>InDistMethods_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDistMethods_inFiltRuleDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDistMethods_inDistRuleDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InDistMethods_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPriority">
<Global>^DHCCAINDISTMETHODS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InDistMethods_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Priority"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDistMethods_priority}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDistMethods_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.InDistMethodsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
