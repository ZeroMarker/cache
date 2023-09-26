Class User.DHCEmPatChkSpec Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = PCSP_RowID, SqlTableName = DHC_EmPatChkSpec, StorageStrategy = SQLStorage ]
{

/// 预检表   PCSP_Chk_Dr
Property PCSPChkDr As User.DHCEmPatCheckLev [ SqlColumnNumber = 2, SqlFieldName = PCSP_Chk_Dr ];

/// 描述  PCSP_SpecDise_Dr
Property PCSPSpecDiseDr As User.DHCEmSpecDise [ SqlColumnNumber = 3, SqlFieldName = PCSP_SpecDise_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMPCSP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PCSP_Chk_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCSP_SpecDise_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMPCSP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCSP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PCSP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPatCheckLev">
<Global>^DHCEMPCSP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PCSP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatCheckLev"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCSP_Chk_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCSP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatChkSpecS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
