Class dhc.pa.data.KPICore Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = KPICore_rowid, SqlTableName = KPICore, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// KPIDr
Property KPIDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// SchemDr
Property SchemDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Index KPIDrUnqIdx1 On KPIDr [ Unique ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAKPICORE)</SqlIdExpression>
<SQLMap name="INDEXSCHEMKPI">
<Global>^DHCCJXPAKPICORE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>KPICore_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SchemKPI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SchemDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KPIDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KPICore_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="KPIDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SchemDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCJXPAKPICORE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>KPICore_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{KPICore_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.KPICoreS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
