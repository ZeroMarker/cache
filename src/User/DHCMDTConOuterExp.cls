Class User.DHCMDTConOuterExp Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MD_RowID, SqlTableName = DHC_MDTConOuterExp, StorageStrategy = SQLStorage ]
{

/// 关联表ID  MD_ParRef_Dr
Property MDParRefDr As User.DHCMDTConsult [ SqlColumnNumber = 2, SqlFieldName = MD_ParRef_Dr ];

/// 外院专家ID  MD_OutExp_Dr
Property MDOutExpDr As User.DHCMDTOuterExpert [ SqlColumnNumber = 3, SqlFieldName = MD_OutExp_Dr ];

/// 会诊意见  MD_Opinion
Property MDOpinion As %Library.String(COLLATION = "Exact", MAXLEN = 1500, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MD_Opinion ];

/// 关联院内用户:发送的时候授权给会诊专家，完成的时候收回
Property MDUserDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = MD_User_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCMDTCOE)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MD_Opinion">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MD_OutExp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MD_ParRef_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MD_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCMDTCOE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOutExp">
<Global>^DHCMDTCOE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutExp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MD_OutExp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParref">
<Global>^DHCMDTCOE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParRef"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MD_ParRef_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCMDTCOE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MD_User_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMDTConOuterExpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
