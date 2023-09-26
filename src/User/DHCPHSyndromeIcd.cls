/// 名称: 诊断与证型关联
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-8-22
Class User.DHCPHSyndromeIcd Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHSI_RowId, SqlTableName = DHC_PHSyndromeIcd, StorageStrategy = SQLStorage ]
{

/// ^DHCPHSYNICD
Property PHSIICDDr As DHCExtIcdFeild [ SqlColumnNumber = 2, SqlFieldName = PHSI_ICD_Dr ];

Property PHSISynDr As DHCPHSyndrome [ SqlColumnNumber = 3, SqlFieldName = PHSI_Syn_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHSYNICD(0))</SqlIdExpression>
<SQLMap name="ICDIndex">
<Global>^DHCPHSYNICD</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHSI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ICD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHSI_ICD_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHSI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHSI_ICD_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHSI_Syn_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHSYNICD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHSI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHSI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="SYNIndex">
<Global>^DHCPHSYNICD</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHSI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SYN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHSI_Syn_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHSI_ICD_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHSI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHSI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHSyndromeIcdS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
