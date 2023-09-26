Class User.DHCEmConsultDiag Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EC_RowID, SqlTableName = DHC_EmConsultDiag, StorageStrategy = SQLStorage ]
{

/// 诊断ID  EC_MR_Dr
Property ECMRDr As User.MRDiagnos [ SqlColumnNumber = 2, SqlFieldName = EC_MR_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMCD)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EC_MR_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEMCD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMrDiag">
<Global>^DHCEMCD</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_MR_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsultDiagS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
