/// 名称: 药品业务表6.5业务辅助表-症状业务表
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2017-3-23
Class User.DHCPHSymptomBus Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PSYM_RowId, SqlTableName = DHC_PHSymptomBus, StorageStrategy = SQLStorage ]
{

/// PSYM_RowId  ^DHCLIBALLI
Property PSYMInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = PSYM_Inst_Dr ];

Property PSYMKeyWordDr As DHCPHKeyWord [ SqlColumnNumber = 3, SqlFieldName = PSYM_KeyWord_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHSYM(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PSYM_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PSYM_KeyWord_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHSYM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PSYM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PSYM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="InstIndex">
<Global>^DHCPHSYM</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PSYM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PSYM_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PSYM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PSYM_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHSymptomBusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
