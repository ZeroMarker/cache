Class User.DHCAdvSecuGroupUserLoc Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = SECUGUL_RowID, SqlTableName = DHC_AdvSecuGroupUserLoc, StorageStrategy = SQLStorage ]
{

/// 安全小组  SECUGUL_Grp_Dr
Property SECUGULGrpDr As User.DHCAdvSecuGroup [ SqlColumnNumber = 2, SqlFieldName = SECUGUL_Grp_Dr ];

/// 安全小组人员  SECUGUL_User_Dr
Property SECUGULUserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = SECUGUL_User_Dr ];

/// 分管科室  SECUGUL_Loc_Dr
Property SECUGULLocDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = SECUGUL_Loc_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVSECUGUL)</SqlIdExpression>
<SQLMap name="GroUserLocIndex">
<Global>^DHCADVSECUGUL</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SECUGUL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GroupUserLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SECUGUL_Grp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SECUGUL_User_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SECUGUL_Loc_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SECUGUL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="SECUGUL_Grp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SECUGUL_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SECUGUL_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCADVSECUGUL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SECUGUL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SECUGUL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvSecuGroupUserLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
