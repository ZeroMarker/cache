/// 名称: 药品业务表-药敏结果细菌业务表
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2017-4-10
Class User.DHCPHOrganismBus Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHORG_RowId, SqlTableName = DHC_PHOrganismBus, StorageStrategy = SQLStorage ]
{

/// PSYM_RowId  ^DHCPHORGBUS
Property PHORGInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = PHORG_Inst_Dr ];

Property PHORGOrgDr As DHCPHBTOrganism [ SqlColumnNumber = 3, SqlFieldName = PHORG_Org_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i( ^DHCPHORGBUS(0))</SqlIdExpression>
<SQLMap name="InstIndex">
<Global>^DHCPHORGBUS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHORG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHORG_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHORG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHORG_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHORG_Org_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHORGBUS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHORG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHORG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHORG_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHOrganismBusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
