Class User.DHCAdvSecuGroupUser Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = SECUGU_RowId, SqlTableName = DHC_AdvSecuGroupUser, StorageStrategy = SQLStorage ]
{

/// 安全小组  SECU_RowId
Property SECUGrpDr As User.DHCAdvSecuGroup [ SqlColumnNumber = 2, SqlFieldName = SECU_Grp_Dr ];

/// 安全小组人员  SECU_User_Dr
Property SECUUserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = SECU_User_Dr ];

/// 组长  SECU_LeadFlag
Property SECULeadFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SECU_LeadFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVSECUGU)</SqlIdExpression>
<SQLMap name="IndexGroUser">
<Global>^DHCADVSECUGU</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SECUGU_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GroupUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SECU_Grp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SECU_User_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SECUGU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<BlockCount>1</BlockCount>
<Data name="SECU_Grp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SECU_LeadFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SECU_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCADVSECUGU</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SECUGU_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SECUGU_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvSecuGroupUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
