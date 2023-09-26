Class User.DHCEmPatChkFall Extends (%Persistent, %XML.Adaptor) [ Owner = {_SYSTEM}, SqlRowIdName = PCF_RowId, SqlTableName = DHC_EmPatChkFall, StorageStrategy = NewStorage1 ]
{

/// 预检表  PCF_Chk_Dr
Property PCFChkDr As User.DHCEmPatCheckLev [ SqlColumnNumber = 2, SqlFieldName = PCF_Chk_Dr ];

/// 创伤主id  PCF_Fall_Dr
Property PCFFallDr As User.DHCEmFall [ SqlColumnNumber = 3, SqlFieldName = PCF_Fall_Dr ];

/// 创伤子表id  PCF_FallItem_Dr
Property PCFFallItemDr As User.DHCEmFallItem [ SqlColumnNumber = 4, SqlFieldName = PCF_FallItem_Dr ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCEMPCF)</SqlIdExpression>
<SQLMap name="IndexPatCheckLev">
<Global>^DHCEMPCF</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PCF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CHECKLEV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCF_Chk_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="PCF_Chk_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCF_FallItem_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCF_Fall_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMPCF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PCF_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatChkFallS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
