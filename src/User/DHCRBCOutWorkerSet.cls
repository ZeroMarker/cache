Class User.DHCRBCOutWorkerSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DOW_RowID, SqlTableName = DHCRBC_OutWorkerSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DOW_USER_DR
Property DOWUSERDR As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = DOW_USER_DR ];

/// DOW_Type
Property DOWType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DOW_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCOutWorkerSet)</SqlIdExpression>
<SQLMap name="IndexUSER">
<Global>^DHCRBCOutWorkerSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DOW_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"USER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DOW_USER_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DOW_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DOW_USER_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBCOutWorkerSet</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DOW_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DOW_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCOutWorkerSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
