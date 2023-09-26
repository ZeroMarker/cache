Class User.PIVAUser Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlTableName = PIVA_User, StorageStrategy = NewStorage1 ]
{

/// 人员
Property PUSUserDr As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = PUS_User_Dr ];

/// 配液中心
Property PUSLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = PUS_Loc_Dr ];

/// 开始休假日期
Property PUSUserStDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = PUS_UserStDate ];

/// 休假间隔天数
Property PUSUserDays As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PUS_UserDays ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCST.PIVA.User(0))</SqlIdExpression>
<SQLMap name="IndexLoc">
<Global>^DHCST.PIVA.User</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PUS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PUS_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PUS_User_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PUS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCST.PIVA.User</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PUS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PUS_User_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PUS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserStDate">
<Global>^DHCST.PIVA.User</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PUS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UserStDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PUS_UserStDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PUS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MastMap">
<Data name="PUS_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PUS_UserDays">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PUS_UserStDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PUS_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCST.PIVA.User</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PUS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PUS_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PUS_RowId</SqlRowIdName>
<StreamLocation>^DHCST.PIVA.UserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
