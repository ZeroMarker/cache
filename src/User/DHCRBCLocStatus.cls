Class User.DHCRBCLocStatus Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCRBC_LocStatus, StorageStrategy = SQLStorage ]
{

/// DLS_LOC_DR
Property DLSLOCDR As CTLoc [ SqlColumnNumber = 2, SqlFieldName = DLS_LOC_DR ];

/// DLS_StatusCode
Property DLSStatusCode As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DLS_StatusCode ];

/// DLS_StatusDesc
Property DLSStatusDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DLS_StatusDesc ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCRBCLocStatus("Status"))</SqlIdExpression>
<SQLMap name="IndexLoc">
<Global>^DHCRBCLocStatusi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DLS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LocId"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DLS_LOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DLS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DLS_LOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DLS_StatusCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DLS_StatusDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCRBCLocStatus</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DLS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DLS_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DLS_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCRBCLocStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
