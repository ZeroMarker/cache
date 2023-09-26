/// 名称: 药品业务表-药敏结果菌属业务表
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2017-4-10
Class User.DHCPHGenusBus Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHGEN_RowId, SqlTableName = DHC_PHGenusBus, StorageStrategy = SQLStorage ]
{

/// PSYM_RowId  ^DHCPHGENUSBUS
Property PHGENInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = PHGEN_Inst_Dr ];

Property PHGENGenusDr As DHCPHBtGenus [ SqlColumnNumber = 3, SqlFieldName = PHGEN_Genus_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i( ^DHCPHGENUSBUS(0))</SqlIdExpression>
<SQLMap name="InstIndex">
<Global>^DHCPHGENUSBUS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHGEN_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHGEN_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHGEN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHGEN_Genus_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHGEN_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHGENUSBUS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHGEN_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHGEN_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHGEN_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHGenusBusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
