Class User.DHCEmPatChkAdm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCA_RowID, SqlTableName = DHC_EmPatChkAdm, StorageStrategy = SQLStorage ]
{

/// 预检表 PCA_Chk_Dr
Property PCAChkDr As User.DHCEmPatCheckLev [ SqlColumnNumber = 2, SqlFieldName = PCA_Chk_Dr ];

/// 时间 PCA_Adm_Dr
Property PCAAdmDr As User.PAAdm [ SqlColumnNumber = 3, SqlFieldName = PCA_Adm_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMPCA)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PCA_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCA_Chk_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEMPCA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PCA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmCheckLev">
<Global>^DHCEMPCA</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PCA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmChkLev"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCA_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCA_Chk_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PCA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatCheckLev">
<Global>^DHCEMPCA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PCA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatCheckLev"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCA_Chk_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatChkAdmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
