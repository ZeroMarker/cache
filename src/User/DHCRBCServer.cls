Class User.DHCRBCServer Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCS_RowID, SqlTableName = DHCRBC_Server, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DCS_Name
Property DCSName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DCS_Name ];

/// DCS_IP
Property DCSIP As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DCS_IP ];

/// DCS_Port
Property DCSPort As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DCS_Port ];

/// DCS_Type
Property DCSType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DCS_Type ];

/// DCS_User
Property DCSUser As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DCS_User ];

/// DCS_Pwd
Property DCSPwd As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DCS_Pwd ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCServer("Server"))</SqlIdExpression>
<SQLMap name="MasterDataIndex">
<Data name="DCS_IP">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCS_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCS_Port">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DCS_Pwd">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DCS_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DCS_User">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCRBCServer</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DCS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Server"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCServerS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
