/// 名称: 滴速维护　
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2017-05-23
Class User.DHCPHDrippingSpeed Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = DRSP_RowId, SqlTableName = DHC_PHDrippingSpeed, StorageStrategy = SQLStorage ]
{

/// DRSP_RowId  ^DHCPHDRSP
Property DRSPInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = DRSP_Inst_Dr ];

Property DRSPText As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DRSP_Text ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHDRSP(0))</SqlIdExpression>
<SQLMap name="InstIndex">
<Global>^DHCPHDRSP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DRSP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRSP_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRSP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DRSP_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRSP_Text">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHDRSP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DRSP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DRSP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DRSP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHDrippingSpeedS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
