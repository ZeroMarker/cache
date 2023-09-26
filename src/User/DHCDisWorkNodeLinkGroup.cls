Class User.DHCDisWorkNodeLinkGroup Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = WN_RowID, SqlTableName = DHC_DisWorkNodeLinkGroup, StorageStrategy = SQLStorage ]
{

/// 服务组  WN_SerGro _Dr
Property WNSerGroDr As User.DHCDisServiceGroup [ SqlColumnNumber = 2, SqlFieldName = WN_SerGro_Dr ];

/// 岗位  WN_Node_Dr
Property WNNodeDr As User.DHCDisWorkNode [ SqlColumnNumber = 3, SqlFieldName = WN_Node_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDISWNLG)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="WN_Node_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WN_SerGro_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCDISWNLG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{WN_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexNode">
<Global>^DHCDISWNLG</Global>
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
<SQLMap name="IndexSGro">
<Global>^DHCDISWNLG</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SerGro"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WN_SerGro_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDisWorkNodeLinkGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
