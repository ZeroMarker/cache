/// 名称: 诊断与证型关联明细
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-8-25
Class User.DHCPHSyndromeGen Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHSG_RowId, SqlTableName = DHC_PHSyndromeGen, StorageStrategy = SQLStorage ]
{

/// ^DHCPHSYNGEN
Property PHSGLinkDr As DHCPHSyndromeIcd [ SqlColumnNumber = 2, SqlFieldName = PHSG_Link_Dr ];

Property PHSGGenDr As DHCPHExtGeneric [ SqlColumnNumber = 3, SqlFieldName = PHSG_Gen_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHSYNGEN(0))</SqlIdExpression>
<SQLMap name="GenIndex">
<Global>^DHCPHSYNGEN</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHSG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Gen"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHSG_Gen_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHSG_Link_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHSG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="LinkIndex">
<Global>^DHCPHSYNGEN</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHSG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Link"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHSG_Link_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHSG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHSG_Gen_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHSG_Link_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHSYNGEN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHSG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHSG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHSG_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHSyndromeGenS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
