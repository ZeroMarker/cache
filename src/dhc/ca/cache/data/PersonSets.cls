Class dhc.ca.cache.data.PersonSets Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PersonSets_rowid, SqlTableName = PersonSets, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PersonSets_order
Property PersonSetsorder As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PersonSets_order ];

/// PersonSets_code
Property PersonSetscode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PersonSets_code ];

/// PersonSets_name
Property PersonSetsname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PersonSets_name ];

/// PersonSets_shortcut
Property PersonSetsshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PersonSets_shortcut ];

/// PersonSets_remark
Property PersonSetsremark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PersonSets_remark ];

/// PersonSets_active
Property PersonSetsactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PersonSets_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAPERSONSETS(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="PersonSets_active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PersonSets_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PersonSets_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PersonSets_order">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PersonSets_remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PersonSets_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCCAPERSONSETS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PersonSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PersonSets_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCAPERSONSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PersonSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PersonSets_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PersonSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCAPERSONSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PersonSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PersonSets_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PersonSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrder">
<Global>^DHCCAPERSONSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PersonSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Order"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PersonSets_order}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PersonSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.PersonSetsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
