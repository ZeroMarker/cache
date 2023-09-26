/// Param
Class dhc.pa.data.Param Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Param_rowid, SqlTableName = Param, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Param_code
Property Paramcode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Param_code ];

/// Param_name
Property Paramname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Param_name ];

/// Param_shortcut
Property Paramshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Param_shortcut ];

/// Param_desc
Property Paramdesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Param_desc ];

/// Param_value
Property Paramvalue As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = Param_value ];

/// Param_active
Property Paramactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = Param_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAPARAM(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="Param_active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Param_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Param_desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Param_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Param_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Param_value">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCCJXPAPARAM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Param_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Param_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCJXPAPARAM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Param_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Param_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Param_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCJXPAPARAM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Param_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Param_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Param_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortCut">
<Global>^DHCCJXPAPARAM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Param_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shortcut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Param_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Param_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.ParamS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
