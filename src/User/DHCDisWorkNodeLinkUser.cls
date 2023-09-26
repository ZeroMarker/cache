Class User.DHCDisWorkNodeLinkUser Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = WN_RowID, SqlTableName = DHC_DisWorkNodeLinkUser, StorageStrategy = SQLStorage ]
{

/// 护工姓名  WN_User_Dr 
Property WNUserDr As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = WN_User_Dr ];

/// 工作结点  TRA_Arc_Dr
Property WNNodeDr As User.DHCDisWorkNode [ SqlColumnNumber = 3, SqlFieldName = WN_Node_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDISWLU)</SqlIdExpression>
<SQLMap name="IndexNode">
<Global>^DHCDISWLU</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Node"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WN_Node_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPoint">
<Global>^DHCDISWLU</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WN_User_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDate">
<Data name="WN_Node_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WN_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCDISWLU</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{WN_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDisWorkNodeLinkUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
