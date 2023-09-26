/// 名称: 药品业务表6.5业务辅助表-治疗手术业务表
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2017-3-23
Class User.DHCPHCure Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PDCU_RowId, SqlTableName = DHC_PHCure, StorageStrategy = SQLStorage ]
{

/// PDCU_RowId  ^DHCPHCU
Property PDCUInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = PDCU_Inst_Dr ];

Property PDCUKeyWordDr As DHCPHKeyWord [ SqlColumnNumber = 3, SqlFieldName = PDCU_KeyWord_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHCU(0))</SqlIdExpression>
<SQLMap name="InstIndex">
<Global>^DHCPHCU</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDCU_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDCU_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDCU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PDCU_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDCU_KeyWord_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHCU</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDCU_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PDCU_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PDCU_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHCureS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
