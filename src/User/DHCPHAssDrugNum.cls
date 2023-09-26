/// 名称: 辅助用药个数 
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-11-24
Class User.DHCPHAssDrugNum Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHAD_RowId, SqlTableName = DHC_PHAssDrugNum, StorageStrategy = SQLStorage ]
{

/// PHAD_RowId  ^DHCPHADN
Property PHADInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = PHAD_Inst_Dr ];

Property PHADNum As %String [ SqlColumnNumber = 3, SqlFieldName = PHAD_Num ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHADN(0))</SqlIdExpression>
<SQLMap name="IndexInst">
<Global>^DHCPHADN</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHAD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAD_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHAD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHAD_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHAD_Num">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHADN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHAD_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHAssDrugNumS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
