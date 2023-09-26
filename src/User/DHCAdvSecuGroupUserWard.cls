Class User.DHCAdvSecuGroupUserWard Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = SECUGUW_RowId, SqlTableName = DHC_AdvSecuGroupUserWard, StorageStrategy = SQLStorage ]
{

/// 安全小组  SECU_RowId
Property SECUGrpDr As User.DHCAdvSecuGroup [ SqlColumnNumber = 2, SqlFieldName = SECU_Grp_Dr ];

/// 安全小组人员  SECU_User_Dr
Property SECUUserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = SECU_User_Dr ];

/// 分管病区  SECU_Ward_Dr
Property SECUWardDr As User.PACWard [ SqlColumnNumber = 4, SqlFieldName = SECU_Ward_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVSECUGUW)</SqlIdExpression>
<SQLMap name="IndexGroUserWad">
<Global>^DHCADVSECUGUW</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SECUGUW_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GroupUserWard"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SECU_Grp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SECU_User_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SECU_Ward_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SECUGUW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<BlockCount>1</BlockCount>
<Data name="SECU_Grp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SECU_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SECU_Ward_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCADVSECUGUW</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SECUGUW_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SECUGUW_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvSecuGroupUserWardS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
