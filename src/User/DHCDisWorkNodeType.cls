Class User.DHCDisWorkNodeType Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = WN_RowID, SqlTableName = DHC_DisWorkNodeType, StorageStrategy = SQLStorage ]
{

/// 任务类型  WN_DisType_Dr 
Property WNDisTypeDr As User.DHCDisTypeAdd [ SqlColumnNumber = 2, SqlFieldName = WN_DisType_Dr ];

/// 工作结点  TRA_Arc_Dr
Property WNNodeDr As User.DHCDisWorkNode [ SqlColumnNumber = 3, SqlFieldName = WN_Node_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDISWNT)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="WN_DisType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WN_Node_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDISWNT</Global>
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
<Global>^DHCDISWNT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_RowID</Field>
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
<SQLMap name="IndexType">
<Global>^DHCDISWNT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Typepoint"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WN_Node_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WN_DisType_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDisWorkNodeTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
