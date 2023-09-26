Class User.PIVAConfigTable Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIVACT_Rowid, SqlTableName = PIVA_ConfigTable, StorageStrategy = SQLStorage ]
{

/// PIVACT_LOC_DR
Property PIVACTLOCDR As User.CTLoc [ Required, SqlColumnNumber = 2, SqlFieldName = PIVACT_LOC_DR ];

/// PIVACT_Code
Property PIVACTCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PIVACT_Code ];

/// PIVACT_Desc
Property PIVACTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PIVACT_Desc ];

Storage SQLStorage
{
<SqlIdExpression>$i(^PIVACT)</SqlIdExpression>
<SQLMap name="DataMasterPIVACT">
<Data name="PIVACT_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIVACT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PIVACT_LOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PIVACT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIVACT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PIVACT_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PIVACTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIVACT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PIVACT_LOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIVACT_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PIVACT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PIVACTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIVACT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PIVACT_LOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIVACT_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PIVACT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^PIVACTi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PIVACT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PIVACT_LOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIVACT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PIVAConfigTable</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
