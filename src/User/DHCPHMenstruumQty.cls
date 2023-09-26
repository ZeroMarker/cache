/// 名称: 药品业务表-溶媒量业务表
/// 编写者:基础数据平台组-高姗姗
/// 编写日期: 2016-11-22
Class User.DHCPHMenstruumQty Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHMQ_RowId, SqlTableName = DHC_PHMenstruumQty, StorageStrategy = SQLStorage ]
{

/// PHMQ_RowId  ^DHCPHMQ
Property PHMQInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = PHMQ_Inst_Dr ];

Property PHMQCatDr As DHCPHMenstruumCat [ SqlColumnNumber = 3, SqlFieldName = PHMQ_Cat_Dr ];

Property PHMQCatQtyMin As %String [ SqlColumnNumber = 4, SqlFieldName = PHMQ_CatQtyMin ];

Property PHMQCatQtyMax As %String [ SqlColumnNumber = 5, SqlFieldName = PHMQ_CatQtyMax ];

Property PHMQCatQtyUomDr As DHCPHExtUom [ SqlColumnNumber = 6, SqlFieldName = PHMQ_CatQtyUom_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHMQ(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHMQ_CatQtyMax">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHMQ_CatQtyMin">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHMQ_CatQtyUom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHMQ_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHMQ_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHMQ</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHMQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHMQ_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInst">
<Global>^DHCPHMQ</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHMQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMQ_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHMQ_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHMenstruumQtyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
