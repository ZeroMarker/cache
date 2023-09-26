Class User.DHCDocPilotProAccount Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPA_RowId, SqlTableName = DHC_DocPilotProAccount, StorageStrategy = SQLStorage ]
{

Property ProjectName As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PPA_ProjectName ];

/// PPA_Account账号
Property Account As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PPA_Account ];

Property ProjectDr As User.DHCDocPilotProject [ SqlColumnNumber = 4, SqlFieldName = PPA_PProject_Dr ];

Property AccountSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PPA_AccountSum ];

Property UserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = PPA_User_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCDocPPA)</SqlIdExpression>
<SQLMap name="DataMasterIndex">
<Data name="PPA_Account">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPA_AccountSum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPA_PProject_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPA_ProjectName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PPA_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCDocPPA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PPA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PPA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexProjectDr">
<Global>^DHCDocPPA</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ProjectDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPA_PProject_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PPA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocPilotProAccountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
