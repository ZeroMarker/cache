Class User.DHCEmConsultInd Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EC_RowID, SqlTableName = DHC_EmConsultInd, StorageStrategy = SQLStorage ]
{

/// 主表ID EC_ParRef_Dr
Property ECParRefDr As User.DHCEmConsult [ SqlColumnNumber = 2, SqlFieldName = EC_ParRef_Dr ];

/// 会诊指征 EC_IndItm_Dr
Property ECIndItmDr As User.DHCEmConsDicItem [ SqlColumnNumber = 3, SqlFieldName = EC_IndItm_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMCONI)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EC_IndItm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EC_ParRef_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEMCONI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexParRef">
<Global>^DHCEMCONI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ConsInd"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_ParRef_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsultIndS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
