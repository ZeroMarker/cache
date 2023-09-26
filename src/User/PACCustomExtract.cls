/// Custom Extract(2340)
Class User.PACCustomExtract Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_CustomExtract, StorageStrategy = SQLStorage ]
{

/// Code
Property CUSTEXTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CUSTEXT_Code ];

/// Delete Script
Property CUSTEXTDeleteScript As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CUSTEXT_DeleteScript ];

/// Description
Property CUSTEXTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CUSTEXT_Desc ];

/// Extract Script
Property CUSTEXTExtractScript As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CUSTEXT_ExtractScript ];

Relationship ChildPACCustomExtractReport As PACCustomExtractReport [ Cardinality = children, Inverse = REPParRef ];

Parameter EXTENTSIZE = 2;

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="CUSTEXTCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="CUSTEXTDeleteScript">
<Selectivity>1</Selectivity>
</Property>
<Property name="CUSTEXTDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="CUSTEXTExtractScript">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("CUSTEXT",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="CUSTEXT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CUSTEXT_DeleteScript">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CUSTEXT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CUSTEXT_ExtractScript">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CUSTEXT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CUSTEXT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CUSTEXT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CUSTEXT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CUSTEXT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CUSTEXT_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CUSTEXT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CUSTEXT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CUSTEXT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CUSTEXT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CUSTEXT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CUSTEXT_RowId</SqlRowIdName>
<StreamLocation>^User.PACCustomExtractS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
