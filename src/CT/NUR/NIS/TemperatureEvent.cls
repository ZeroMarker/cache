Class CT.NUR.NIS.TemperatureEvent Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ROWID, SqlTableName = TemperatureEvent, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CODE
Property CODE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CODE ];

/// DEPICT
Property DEPICT As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DEPICT ];

/// TYPE
Property TYPE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = TYPE ];

/// TYPE_CODE
Property TYPECODE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = TYPE_CODE ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^CT.NUR.NIS.TemperatureEvent("typ"))</SqlIdExpression>
<SQLMap name="DATAMASTER">
<Data name="CODE">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DEPICT">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TYPE">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TYPE_CODE">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^CT.NUR.NIS.TemperatureEvent</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"typ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTYPEDESC">
<Global>^CT.NUR.NIS.TemperatureEvent</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>L3</Expression>
<Field>ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"TYPDESC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEPICT}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^CT.NUR.NIS.TemperatureEventS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
