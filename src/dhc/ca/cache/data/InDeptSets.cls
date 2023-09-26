Class dhc.ca.cache.data.InDeptSets Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InDeptSets_rowid, SqlTableName = InDeptSets, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildInDepts As dhc.ca.cache.data.InDepts [ Cardinality = children, Inverse = InDeptsparRef ];

/// InDeptSets_order
Property InDeptSetsorder As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = InDeptSets_order ];

/// InDeptSets_code
Property InDeptSetscode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = InDeptSets_code ];

/// InDeptSets_name
Property InDeptSetsname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = InDeptSets_name ];

/// InDeptSets_shortcut
Property InDeptSetsshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = InDeptSets_shortcut ];

/// InDeptSets_remark
Property InDeptSetsremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = InDeptSets_remark ];

/// InDeptSets_active
Property InDeptSetsactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = InDeptSets_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAINDEPTSETS(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="InDeptSets_active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="InDeptSets_code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="InDeptSets_name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="InDeptSets_order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="InDeptSets_remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="InDeptSets_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCAINDEPTSETS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InDeptSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InDeptSets_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCAINDEPTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InDeptSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDeptSets_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDeptSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCAINDEPTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InDeptSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDeptSets_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDeptSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCAINDEPTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InDeptSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDeptSets_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDeptSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSetOrder">
<Global>^DHCCAINDEPTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InDeptSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SetOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDeptSets_order}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDeptSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortcut">
<Global>^DHCCAINDEPTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InDeptSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shortcut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDeptSets_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDeptSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.InDeptSetsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
