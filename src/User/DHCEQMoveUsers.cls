Class User.DHCEQMoveUsers Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MU_RowID, SqlTableName = DHC_EQMoveUsers, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MU_MoveDR
Property MUMoveDR As User.DHCEQMove [ SqlColumnNumber = 2, SqlFieldName = MU_MoveDR ];

/// MU_UserDR
Property MUUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MU_UserDR ];

/// MU_Remark
Property MURemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MU_Remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMoveUsers("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MU_MoveDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MU_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MU_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQMoveUsers</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{MU_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMove">
<Global>^DHCEQMoveUsers</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MU_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Move"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MU_MoveDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMoveUser">
<Global>^DHCEQMoveUsers</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MU_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MoveUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MU_UserDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMoveUsersS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
