Class dhc.ca.cache.data.UnitTypes Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UnitTypes_rowid, SqlTableName = UnitTypes, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// UnitTypes_code
Property UnitTypescode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = UnitTypes_code ];

/// UnitTypes_name
Property UnitTypesname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = UnitTypes_name ];

/// UnitTypes_shortcut
Property UnitTypesshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = UnitTypes_shortcut ];

/// UnitTypes_remark
Property UnitTypesremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = UnitTypes_remark ];

/// UnitTypes_flag
Property UnitTypesflag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = UnitTypes_flag ];

/// UnitTypes_active
Property UnitTypesactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = UnitTypes_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAUNITTYPES(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="UnitTypes_active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UnitTypes_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UnitTypes_flag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UnitTypes_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UnitTypes_remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UnitTypes_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCAUNITTYPES</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UnitTypes_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{UnitTypes_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCAUNITTYPES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UnitTypes_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitTypes_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitTypes_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCAUNITTYPES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UnitTypes_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitTypes_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitTypes_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlag">
<Global>^DHCCAUNITTYPES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UnitTypes_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Flag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitTypes_flag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitTypes_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCAUNITTYPES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UnitTypes_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitTypes_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitTypes_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortcut">
<Global>^DHCCAUNITTYPES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UnitTypes_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shortcut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitTypes_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitTypes_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.UnitTypesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
